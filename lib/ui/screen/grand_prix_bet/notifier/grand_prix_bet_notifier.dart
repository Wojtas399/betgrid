import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../auth/auth_service.dart';
import '../../../../data/repository/grand_prix_bet/grand_prix_bet_repository.dart';
import '../../../../model/grand_prix_bet.dart';
import '../../../riverpod_provider/grand_prix_id_provider.dart';
import 'grand_prix_bet_notifier_state.dart';

part 'grand_prix_bet_notifier.g.dart';

@Riverpod(dependencies: [grandPrixId])
class GrandPrixBetNotifier extends _$GrandPrixBetNotifier {
  String? _grandPrixBetId;

  @override
  Stream<GrandPrixBetNotifierState?> build() {
    final String? grandPrixId = ref.watch(grandPrixIdProvider);
    if (grandPrixId == null) throw 'Grand prix id not found';
    final authService = ref.watch(authServiceProvider);
    final grandPrixBetRepository = ref.watch(grandPrixBetRepositoryProvider);
    return authService.loggedUserId$.switchMap<GrandPrixBet?>(
      (String? loggedUserId) {
        return loggedUserId == null
            ? throw 'Logged user id not found'
            : grandPrixBetRepository.getGrandPrixBetByGrandPrixId(
                userId: loggedUserId,
                grandPrixId: grandPrixId,
              );
      },
    ).map(
      (grandPrixBet) {
        _grandPrixBetId = grandPrixBet?.id;
        return GrandPrixBetNotifierState(
          qualiStandingsByDriverIds: grandPrixBet?.qualiStandingsByDriverIds,
          p1DriverId: grandPrixBet?.p1DriverId,
          p2DriverId: grandPrixBet?.p2DriverId,
          p3DriverId: grandPrixBet?.p3DriverId,
          p10DriverId: grandPrixBet?.p10DriverId,
          fastestLapDriverId: grandPrixBet?.fastestLapDriverId,
          dnfDriverIds: grandPrixBet?.dnfDriverIds,
          willBeSafetyCar: grandPrixBet?.willBeSafetyCar,
          willBeRedFlag: grandPrixBet?.willBeRedFlag,
        );
      },
    );
  }

  void onQualificationDriverChanged(int positionIndex, String driverId) {
    final List<String?> updatedStandings = [
      ...?state.value?.qualiStandingsByDriverIds,
    ];
    updatedStandings[positionIndex] = driverId;
    state = AsyncData(state.value?.copyWith(
      qualiStandingsByDriverIds: updatedStandings,
    ));
  }

  void onP1DriverChanged(String driverId) {
    state = AsyncData(state.value?.copyWith(
      p1DriverId: driverId,
    ));
  }

  void onP2DriverChanged(String driverId) {
    state = AsyncData(state.value?.copyWith(
      p2DriverId: driverId,
    ));
  }

  void onP3DriverChanged(String driverId) {
    state = AsyncData(state.value?.copyWith(
      p3DriverId: driverId,
    ));
  }

  void onP10DriverChanged(String driverId) {
    state = AsyncData(state.value?.copyWith(
      p10DriverId: driverId,
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
    final authService = ref.read(authServiceProvider);
    final grandPrixBetRepository = ref.read(grandPrixBetRepositoryProvider);
    final String? loggedUserId = await authService.loggedUserId$.first;
    if (loggedUserId == null) {
      throw '[QualificationsBetDriversStandingsProvide] Logged user id not found';
    }
    if (_grandPrixBetId == null) {
      throw '[QualificationsBetDriversStandingsProvide] Grand prix bet id not found';
    }
    final GrandPrixBetNotifierState? currentState = state.value;
    await grandPrixBetRepository.updateGrandPrixBet(
      userId: loggedUserId,
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
  }
}
