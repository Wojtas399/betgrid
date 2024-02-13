import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../auth/auth_service.dart';
import '../../../../data/repository/grand_prix/grand_prix_repository.dart';
import '../../../../data/repository/grand_prix_bet/grand_prix_bet_repository.dart';
import '../../../../model/grand_prix.dart';
import '../../../../model/grand_prix_bet.dart';
import '../../../riverpod_provider/grand_prix_id_provider.dart';
import 'grand_prix_bet_notifier_state.dart';

part 'grand_prix_bet_notifier.g.dart';

@Riverpod(dependencies: [grandPrixId])
class GrandPrixBetNotifier extends _$GrandPrixBetNotifier {
  String? _grandPrixBetId;

  @override
  Stream<GrandPrixBetNotifierState?> build() async* {
    final String? grandPrixId = ref.watch(grandPrixIdProvider);
    if (grandPrixId == null) throw 'Grand prix id not found';
    final String? grandPrixName = await _loadGrandPrixName(grandPrixId);
    final Stream<GrandPrixBet?> bet$ = _getBetForGrandPrix(grandPrixId);
    await for (final bet in bet$) {
      _grandPrixBetId = bet?.id;
      yield GrandPrixBetNotifierState(
        grandPrixName: grandPrixName,
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
    state = AsyncData(state.value?.copyWith(
      status: const GrandPrixBetNotifierStatusSavingData(),
    ));
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
    state = AsyncData(state.value?.copyWith(
      status: const GrandPrixBetNotifierStatusDataSaved(),
    ));
  }

  Future<String?> _loadGrandPrixName(String grandPrixId) async {
    final GrandPrix? grandPrix = await ref
        .read(grandPrixRepositoryProvider)
        .loadGrandPrixById(grandPrixId: grandPrixId);
    return grandPrix?.name;
  }

  Stream<GrandPrixBet?> _getBetForGrandPrix(String grandPrixId) =>
      ref.watch(authServiceProvider).loggedUserId$.switchMap<GrandPrixBet?>(
        (String? loggedUserId) {
          return loggedUserId == null
              ? throw 'Logged user id not found'
              : ref
                  .watch(grandPrixBetRepositoryProvider)
                  .getGrandPrixBetByGrandPrixId(
                    userId: loggedUserId,
                    grandPrixId: grandPrixId,
                  );
        },
      );
}
