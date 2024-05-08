import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/repository/auth/auth_repository.dart';
import '../../../../data/repository/grand_prix/grand_prix_repository.dart';
import '../../../../data/repository/grand_prix_bet/grand_prix_bet_repository.dart';
import '../../../../dependency_injection.dart';
import '../../../../model/grand_prix.dart';
import '../../../../model/grand_prix_bet.dart';

part 'grand_prix_bets_initialization_controller.g.dart';

@riverpod
class GrandPrixBetsInitializationController
    extends _$GrandPrixBetsInitializationController {
  @override
  Future<void> build() async {}

  Future<void> initialize() async {
    final String? loggedUserId =
        await getIt.get<AuthRepository>().loggedUserId$.first;
    if (loggedUserId == null) return;
    final List<GrandPrixBet>? bets = await getIt
        .get<GrandPrixBetRepository>()
        .getAllGrandPrixBetsForPlayer(playerId: loggedUserId)
        .first;
    if (bets == null || bets.isEmpty) await _initializeBets(loggedUserId);
  }

  Future<void> _initializeBets(String loggedUserId) async {
    final List<GrandPrix>? grandPrixes =
        await getIt.get<GrandPrixRepository>().getAllGrandPrixes().first;
    if (grandPrixes != null) {
      await getIt.get<GrandPrixBetRepository>().addGrandPrixBets(
            playerId: loggedUserId,
            grandPrixBets: _createBetsForGrandPrixes(
              grandPrixes,
              loggedUserId,
            ),
          );
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
