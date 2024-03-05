import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/auth_service.dart';
import '../../data/repository/grand_prix/grand_prix_repository.dart';
import '../../data/repository/grand_prix_bet/grand_prix_bet_repository.dart';
import '../../model/grand_prix.dart';
import '../../model/grand_prix_bet.dart';

part 'all_grand_prix_bets_initialization_provider.g.dart';

@riverpod
Future<void> allGrandPrixBetsInitialization(
  AllGrandPrixBetsInitializationRef ref,
) async {
  final String? loggedUserId =
      await ref.read(authServiceProvider).loggedUserId$.first;
  if (loggedUserId == null) return;
  final Stream<List<GrandPrixBet>?> bets$ = ref
      .read(grandPrixBetRepositoryProvider)
      .getAllGrandPrixBets(playerId: loggedUserId);
  await for (final bets in bets$) {
    if (bets == null || bets.isEmpty) {
      await _initializeBets(ref, loggedUserId);
    }
    return;
  }
}

Future<void> _initializeBets(
  AllGrandPrixBetsInitializationRef ref,
  String loggedUserId,
) async {
  final List<String?> defaultQualiStandings = List.generate(20, (_) => null);
  final List<String?> defaultDnfDrivers = List.generate(3, (_) => null);
  final Stream<List<GrandPrix>?> grandPrixes$ =
      ref.read(grandPrixRepositoryProvider).getAllGrandPrixes();
  await for (final grandPrixes in grandPrixes$) {
    if (grandPrixes != null) {
      await ref.read(grandPrixBetRepositoryProvider).addGrandPrixBets(
            playerId: loggedUserId,
            grandPrixBets: grandPrixes
                .map(
                  (GrandPrix gp) => GrandPrixBet(
                    id: '',
                    playerId: loggedUserId,
                    grandPrixId: gp.id,
                    qualiStandingsByDriverIds: defaultQualiStandings,
                    dnfDriverIds: defaultDnfDrivers,
                  ),
                )
                .toList(),
          );
      return;
    }
  }
}
