import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/repository/grand_prix_bet/grand_prix_bet_repository.dart';
import '../../../../model/grand_prix_bet.dart';
import '../../grand_prix/grand_prix_id_provider.dart';
import '../../player/player_id_provider.dart';
import 'grand_prix_bet_notifier_state.dart';

part 'grand_prix_bet_notifier_provider.g.dart';

@Riverpod(dependencies: [grandPrixId, playerId])
class GrandPrixBetNotifier extends _$GrandPrixBetNotifier {
  String? _grandPrixBetId;

  @override
  Stream<GrandPrixBetNotifierState?> build() async* {
    final String? grandPrixId = ref.watch(grandPrixIdProvider);
    final String? playerId = ref.watch(playerIdProvider);
    if (grandPrixId == null) throw 'Grand prix id not found';
    if (playerId == null) throw 'Player id not found';
    final Stream<GrandPrixBet?> bet$ = ref
        .watch(grandPrixBetRepositoryProvider)
        .getBetByGrandPrixIdAndPlayerId(
          playerId: playerId,
          grandPrixId: grandPrixId,
        );
    await for (final bet in bet$) {
      _grandPrixBetId = bet?.id;
      yield GrandPrixBetNotifierState(
        qualiStandingsByDriverIds: bet?.qualiStandingsByDriverIds,
        p1DriverId: bet?.p1DriverId,
        p2DriverId: bet?.p2DriverId,
        p3DriverId: bet?.p3DriverId,
        p10DriverId: bet?.p10DriverId,
        fastestLapDriverId: bet?.fastestLapDriverId,
        dnfDriverIds: bet?.dnfDriverIds,
        willBeSafetyCar: bet?.willBeSafetyCar,
        willBeRedFlag: bet?.willBeRedFlag,
      );
    }
  }

  void onQualificationDriverChanged(int positionIndex, String driverId) {
    final List<String?> updatedStandings = [
      ...?state.value?.qualiStandingsByDriverIds,
    ];
    final int indexOfExistingPosition = updatedStandings.indexWhere(
      (el) => el == driverId,
    );
    if (indexOfExistingPosition >= 0) {
      updatedStandings[indexOfExistingPosition] = null;
    }
    updatedStandings[positionIndex] = driverId;
    state = AsyncData(state.value?.copyWith(
      qualiStandingsByDriverIds: updatedStandings,
    ));
  }

  void onP1DriverChanged(String driverId) {
    final currState = state.value;
    state = AsyncData(currState?.copyWith(
      p1DriverId: driverId,
      p2DriverId:
          currState.p2DriverId == driverId ? null : currState.p2DriverId,
      p3DriverId:
          currState.p3DriverId == driverId ? null : currState.p3DriverId,
      p10DriverId:
          currState.p10DriverId == driverId ? null : currState.p10DriverId,
    ));
  }

  void onP2DriverChanged(String driverId) {
    final currState = state.value;
    state = AsyncData(currState?.copyWith(
      p2DriverId: driverId,
      p1DriverId:
          currState.p1DriverId == driverId ? null : currState.p1DriverId,
      p3DriverId:
          currState.p3DriverId == driverId ? null : currState.p3DriverId,
      p10DriverId:
          currState.p10DriverId == driverId ? null : currState.p10DriverId,
    ));
  }

  void onP3DriverChanged(String driverId) {
    final currState = state.value;
    state = AsyncData(currState?.copyWith(
      p3DriverId: driverId,
      p1DriverId:
          currState.p1DriverId == driverId ? null : currState.p1DriverId,
      p2DriverId:
          currState.p2DriverId == driverId ? null : currState.p2DriverId,
      p10DriverId:
          currState.p10DriverId == driverId ? null : currState.p10DriverId,
    ));
  }

  void onP10DriverChanged(String driverId) {
    final currState = state.value;
    state = AsyncData(currState?.copyWith(
      p10DriverId: driverId,
      p1DriverId:
          currState.p1DriverId == driverId ? null : currState.p1DriverId,
      p2DriverId:
          currState.p2DriverId == driverId ? null : currState.p2DriverId,
      p3DriverId:
          currState.p3DriverId == driverId ? null : currState.p3DriverId,
    ));
  }

  void onFastestLapDriverChanged(String driverId) {
    state = AsyncData(state.value?.copyWith(
      fastestLapDriverId: driverId,
    ));
  }

  void onDnfDriverChanged(int dnfIndex, String driverId) {
    final List<String?> updatedDnfDriverIds = [
      ...?state.value?.dnfDriverIds,
    ];
    final int indexOfExistingPosition = updatedDnfDriverIds.indexWhere(
      (el) => el == driverId,
    );
    if (indexOfExistingPosition >= 0) {
      updatedDnfDriverIds[indexOfExistingPosition] = null;
    }
    updatedDnfDriverIds[dnfIndex] = driverId;
    state = AsyncData(state.value?.copyWith(
      dnfDriverIds: updatedDnfDriverIds,
    ));
  }

  void onSafetyCarPossibilityChanged(bool willBeSafetyCar) {
    state = AsyncData(state.value?.copyWith(
      willBeSafetyCar: willBeSafetyCar,
    ));
  }

  void onRedFlagPossibilityChanged(bool willBeRedFlag) {
    state = AsyncData(state.value?.copyWith(
      willBeRedFlag: willBeRedFlag,
    ));
  }

  Future<void> saveStandings() async {
    final grandPrixBetRepository = ref.read(grandPrixBetRepositoryProvider);
    if (_grandPrixBetId == null) {
      throw '[QualificationsBetDriversStandingsProvide] Grand prix bet id not found';
    }
    final GrandPrixBetNotifierState? currentState = state.value;
    state = AsyncData(state.value?.copyWith(
      status: const GrandPrixBetNotifierStatusSavingData(),
    ));
    await grandPrixBetRepository.updateGrandPrixBet(
      playerId: ref.watch(playerIdProvider)!,
      grandPrixBetId: _grandPrixBetId!,
      qualiStandingsByDriverIds: currentState?.qualiStandingsByDriverIds,
      p1DriverId: currentState?.p1DriverId,
      p2DriverId: currentState?.p2DriverId,
      p3DriverId: currentState?.p3DriverId,
      p10DriverId: currentState?.p10DriverId,
      fastestLapDriverId: currentState?.fastestLapDriverId,
      dnfDriverIds: currentState?.dnfDriverIds,
      willBeSafetyCar: currentState?.willBeSafetyCar,
      willBeRedFlag: currentState?.willBeRedFlag,
    );
    state = AsyncData(state.value?.copyWith(
      status: const GrandPrixBetNotifierStatusDataSaved(),
    ));
  }
}
