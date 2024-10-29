import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/repository/auth/auth_repository.dart';
import '../../../../data/repository/driver/driver_repository.dart';
import '../../../../data/repository/grand_prix_bet/grand_prix_bet_repository.dart';
import '../../../../model/driver.dart';
import '../../../../model/grand_prix_bet.dart';
import '../../../extensions/drivers_list_extensions.dart';
import 'grand_prix_bet_editor_state.dart';

@injectable
class GrandPrixBetEditorCubit extends Cubit<GrandPrixBetEditorState> {
  final AuthRepository _authRepository;
  final GrandPrixBetRepository _grandPrixBetRepository;
  final DriverRepository _driverRepository;
  StreamSubscription<GrandPrixBet?>? _grandPrixBetListener;
  String? _grandPrixId;

  GrandPrixBetEditorCubit(
    this._authRepository,
    this._grandPrixBetRepository,
    this._driverRepository,
  ) : super(const GrandPrixBetEditorState());

  @override
  Future<void> close() {
    _grandPrixBetListener?.cancel();
    return super.close();
  }

  Future<void> initialize({
    required String grandPrixId,
  }) async {
    _grandPrixId = grandPrixId;
    final List<Driver> sortedAllDrivers = await _loadAllDriversAndSort();
    _grandPrixBetListener = _getBetForGrandPrix(grandPrixId).listen(
      (GrandPrixBet? bet) => _manageGrandPrixBetUpdate(bet, sortedAllDrivers),
    );
  }

  void onQualiStandingsChanged({
    required int standing,
    required String driverId,
  }) {
    final List<String?> updatedQualiStandings = [
      ...state.qualiStandingsByDriverIds,
    ];
    final int matchingValueIndex = updatedQualiStandings.indexOf(driverId);
    if (matchingValueIndex >= 0) {
      updatedQualiStandings[matchingValueIndex] = null;
    }
    updatedQualiStandings[standing - 1] = driverId;
    emit(state.copyWith(
      status: GrandPrixBetEditorStateStatus.completed,
      qualiStandingsByDriverIds: updatedQualiStandings,
    ));
  }

  void onRaceP1DriverChanged(String driverId) {
    emit(state.copyWith(
      status: GrandPrixBetEditorStateStatus.completed,
      raceForm: state.raceForm.copyWith(
        p1DriverId: driverId,
      ),
    ));
  }

  void onRaceP2DriverChanged(String driverId) {
    emit(state.copyWith(
      status: GrandPrixBetEditorStateStatus.completed,
      raceForm: state.raceForm.copyWith(
        p2DriverId: driverId,
      ),
    ));
  }

  void onRaceP3DriverChanged(String driverId) {
    emit(state.copyWith(
      status: GrandPrixBetEditorStateStatus.completed,
      raceForm: state.raceForm.copyWith(
        p3DriverId: driverId,
      ),
    ));
  }

  void onRaceP10DriverChanged(String driverId) {
    emit(state.copyWith(
      status: GrandPrixBetEditorStateStatus.completed,
      raceForm: state.raceForm.copyWith(
        p10DriverId: driverId,
      ),
    ));
  }

  void onRaceFastestLapDriverChanged(String driverId) {
    emit(state.copyWith(
      status: GrandPrixBetEditorStateStatus.completed,
      raceForm: state.raceForm.copyWith(
        fastestLapDriverId: driverId,
      ),
    ));
  }

  void onDnfDriverSelected(String driverId) {
    if (state.allDrivers == null) return;
    final Driver? selectedDriver = state.allDrivers!.firstWhereOrNull(
      (Driver driver) => driver.id == driverId,
    );
    if (selectedDriver == null ||
        state.raceForm.dnfDrivers.contains(selectedDriver)) {
      return;
    }
    final List<Driver> updatedDnfDrivers = [...state.raceForm.dnfDrivers];
    updatedDnfDrivers.add(selectedDriver);
    emit(state.copyWith(
      raceForm: state.raceForm.copyWith(
        dnfDrivers: updatedDnfDrivers,
      ),
    ));
  }

  void onDnfDriverRemoved(String driverId) {
    if (state.allDrivers == null) return;
    final int indexOfDriverToRemove = state.raceForm.dnfDrivers.indexWhere(
      (Driver driver) => driver.id == driverId,
    );
    if (indexOfDriverToRemove == -1) return;
    final List<Driver> updatedDnfDrivers = [...state.raceForm.dnfDrivers];
    updatedDnfDrivers.removeAt(indexOfDriverToRemove);
    emit(state.copyWith(
      raceForm: state.raceForm.copyWith(
        dnfDrivers: updatedDnfDrivers,
      ),
    ));
  }

  void onSafetyCarPredictionChanged(bool willBeSafetyCar) {
    emit(state.copyWith(
      status: GrandPrixBetEditorStateStatus.completed,
      raceForm: state.raceForm.copyWith(
        willBeSafetyCar: willBeSafetyCar,
      ),
    ));
  }

  void onRedFlagPredictionChanged(bool willBeRedFlag) {
    emit(state.copyWith(
      status: GrandPrixBetEditorStateStatus.completed,
      raceForm: state.raceForm.copyWith(
        willBeRedFlag: willBeRedFlag,
      ),
    ));
  }

  Future<void> submit() async {
    if (_grandPrixId == null) return;
    final String? loggedUserId = await _authRepository.loggedUserId$.first;
    if (loggedUserId == null) return;
    emit(state.copyWith(
      status: GrandPrixBetEditorStateStatus.saving,
    ));
    if (state.originalGrandPrixBet == null) {
      await _addGrandPrixBet(loggedUserId);
    } else {
      await _updateGrandPrixBet(loggedUserId);
    }
    emit(state.copyWith(
      status: GrandPrixBetEditorStateStatus.successfullySaved,
    ));
  }

  Future<List<Driver>> _loadAllDriversAndSort() async {
    final List<Driver> allDrivers =
        await _driverRepository.getAllDrivers().first;
    final List<Driver> sortedAllDrivers = [...allDrivers];
    sortedAllDrivers.sortByTeamAndSurname();
    return sortedAllDrivers;
  }

  Stream<GrandPrixBet?> _getBetForGrandPrix(String grandPrixId) =>
      _authRepository.loggedUserId$.whereNotNull().switchMap(
            (String loggedUserId) =>
                _grandPrixBetRepository.getGrandPrixBetForPlayerAndGrandPrix(
              playerId: loggedUserId,
              grandPrixId: grandPrixId,
            ),
          );

  void _manageGrandPrixBetUpdate(GrandPrixBet? bet, List<Driver> allDrivers) {
    GrandPrixBetEditorState newState = state.copyWith(
      status: GrandPrixBetEditorStateStatus.completed,
      allDrivers: allDrivers,
    );
    if (bet == null) {
      emit(newState);
      return;
    }
    final List<Driver> dnfDrivers = bet.dnfDriverIds
        .whereNotNull()
        .map(
          (String driverId) => allDrivers.firstWhere(
            (Driver driver) => driver.id == driverId,
          ),
        )
        .toList();
    emit(newState.copyWith(
      originalGrandPrixBet: bet,
      qualiStandingsByDriverIds: bet.qualiStandingsByDriverIds,
      raceForm: state.raceForm.copyWith(
        p1DriverId: bet.p1DriverId,
        p2DriverId: bet.p2DriverId,
        p3DriverId: bet.p3DriverId,
        p10DriverId: bet.p10DriverId,
        fastestLapDriverId: bet.fastestLapDriverId,
        dnfDrivers: dnfDrivers,
        willBeSafetyCar: bet.willBeSafetyCar,
        willBeRedFlag: bet.willBeRedFlag,
      ),
    ));
  }

  Future<void> _addGrandPrixBet(String loggedUserId) async {
    await _grandPrixBetRepository.addGrandPrixBet(
      playerId: loggedUserId,
      grandPrixId: _grandPrixId!,
      qualiStandingsByDriverIds: state.qualiStandingsByDriverIds,
      p1DriverId: state.raceForm.p1DriverId,
      p2DriverId: state.raceForm.p2DriverId,
      p3DriverId: state.raceForm.p3DriverId,
      p10DriverId: state.raceForm.p10DriverId,
      fastestLapDriverId: state.raceForm.fastestLapDriverId,
      dnfDriverIds:
          state.raceForm.dnfDrivers.map((Driver driver) => driver.id).toList(),
      willBeSafetyCar: state.raceForm.willBeSafetyCar,
      willBeRedFlag: state.raceForm.willBeRedFlag,
    );
  }

  Future<void> _updateGrandPrixBet(String loggedUserId) async {
    await _grandPrixBetRepository.updateGrandPrixBet(
      playerId: loggedUserId,
      grandPrixBetId: state.originalGrandPrixBet!.id,
      qualiStandingsByDriverIds: state.qualiStandingsByDriverIds,
      p1DriverId: state.raceForm.p1DriverId,
      p2DriverId: state.raceForm.p2DriverId,
      p3DriverId: state.raceForm.p3DriverId,
      p10DriverId: state.raceForm.p10DriverId,
      fastestLapDriverId: state.raceForm.fastestLapDriverId,
      dnfDriverIds:
          state.raceForm.dnfDrivers.map((Driver driver) => driver.id).toList(),
      willBeSafetyCar: state.raceForm.willBeSafetyCar,
      willBeRedFlag: state.raceForm.willBeRedFlag,
    );
  }
}
