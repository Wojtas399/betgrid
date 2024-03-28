import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/auth/auth_repository_method_providers.dart';
import '../../data/repository/grand_prix/grand_prix_repository.dart';
import '../../data/repository/grand_prix_bet/grand_prix_bet_repository.dart';
import '../../model/grand_prix.dart';
import '../../model/grand_prix_bet.dart';

part 'grand_prix_bets_initialization_controller.g.dart';

@riverpod
class GrandPrixBetsInitializationController
    extends _$GrandPrixBetsInitializationController {
  @override
  Future<void> build() async {}

  Future<void> initialize() async {
    final String? loggedUserId = await ref.watch(loggedUserIdProvider.future);
    if (loggedUserId == null) return;
    final Stream<List<GrandPrixBet>?> bets$ = ref
        .read(grandPrixBetRepositoryProvider)
        .getAllGrandPrixBets(playerId: loggedUserId);
    await for (final bets in bets$) {
      if (bets == null || bets.isEmpty) {
        await _initializeBets(loggedUserId);
      }
      return;
    }
  }

  Future<void> _initializeBets(String loggedUserId) async {
    final Stream<List<GrandPrix>?> grandPrixes$ =
        ref.read(grandPrixRepositoryProvider).getAllGrandPrixes();
    await for (final grandPrixes in grandPrixes$) {
      if (grandPrixes != null) {
        await ref.read(grandPrixBetRepositoryProvider).addGrandPrixBets(
              playerId: loggedUserId,
              grandPrixBets: _createBetsForGrandPrixes(
                grandPrixes,
                loggedUserId,
              ),
            );
        return;
      }
    }
  }

  List<GrandPrixBet> _createBetsForGrandPrixes(
    List<GrandPrix> grandPrixes,
    String loggedUserId,
  ) {
    final List<String?> defaultQualiStandings = List.generate(20, (_) => null);
    final List<String?> defaultDnfDrivers = List.generate(3, (_) => null);
    return grandPrixes
        .map(
          (GrandPrix gp) => GrandPrixBet(
            id: '',
            playerId: loggedUserId,
            grandPrixId: gp.id,
            qualiStandingsByDriverIds: defaultQualiStandings,
            dnfDriverIds: defaultDnfDrivers,
          ),
        )
        .toList();
  }
}
