import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/repository/auth/auth_repository.dart';
import '../../../../data/repository/grand_prix_bet/grand_prix_bet_repository.dart';
import '../../../../model/driver.dart';
import '../../../../model/grand_prix_bet.dart';
import '../../../../use_case/get_all_drivers_from_season_use_case.dart';
import '../../../extensions/drivers_list_extensions.dart';
import 'grand_prix_bet_editor_state.dart';

@injectable
class GrandPrixBetEditorCubit extends Cubit<GrandPrixBetEditorState> {
  final AuthRepository _authRepository;
  final GrandPrixBetRepository _grandPrixBetRepository;
  final GetAllDriversFromSeasonUseCase _getAllDriversFromSeasonUseCase;
  final String _grandPrixId;
  StreamSubscription<_ListenedParams?>? _listener;

  GrandPrixBetEditorCubit(
    this._authRepository,
    this._grandPrixBetRepository,
    this._getAllDriversFromSeasonUseCase,
    @factoryParam this._grandPrixId,
  ) : super(const GrandPrixBetEditorState());

  @override
  Future<void> close() {
    _listener?.cancel();
    return super.close();
  }

  void initialize() {
    _listener = Rx.combineLatest2(
      _getAllSortedDrivers(),
      _getBetForGrandPrix(),
      (List<Driver> allDrivers, GrandPrixBet? gpBet) => (
        allDrivers: allDrivers,
        gpBet: gpBet,
      ),
    ).listen(_manageListenedParams);
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
      (Driver driver) => driver.seasonDriverId == driverId,
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
      (Driver driver) => driver.seasonDriverId == driverId,
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

  Stream<List<Driver>> _getAllSortedDrivers() {
    return _getAllDriversFromSeasonUseCase(2024).map(
      (List<Driver> allDriversFromSeason) {
        final sortedAllDriversFromSeason = [...allDriversFromSeason];
        sortedAllDriversFromSeason.sortByTeamAndSurname();
        return sortedAllDriversFromSeason;
      },
    );
  }

  Stream<GrandPrixBet?> _getBetForGrandPrix() {
    return _authRepository.loggedUserId$.whereNotNull().switchMap(
          (String loggedUserId) =>
              _grandPrixBetRepository.getGrandPrixBetForPlayerAndGrandPrix(
            playerId: loggedUserId,
            grandPrixId: _grandPrixId,
          ),
        );
  }

  void _manageListenedParams(_ListenedParams listenedParams) {
    final GrandPrixBet? gpBet = listenedParams.gpBet;
    final List<Driver> allDrivers = listenedParams.allDrivers;
    GrandPrixBetEditorState newState = state.copyWith(
      status: GrandPrixBetEditorStateStatus.completed,
      allDrivers: allDrivers,
    );
    if (gpBet == null) {
      emit(newState);
      return;
    }
    final List<Driver> dnfDrivers = gpBet.dnfSeasonDriverIds
        .whereNotNull()
        .map(
          (String driverId) => allDrivers.firstWhere(
            (Driver driver) => driver.seasonDriverId == driverId,
          ),
        )
        .toList();
    emit(newState.copyWith(
      originalGrandPrixBet: gpBet,
      qualiStandingsByDriverIds: gpBet.qualiStandingsBySeasonDriverIds,
      raceForm: state.raceForm.copyWith(
        p1DriverId: gpBet.p1SeasonDriverId,
        p2DriverId: gpBet.p2SeasonDriverId,
        p3DriverId: gpBet.p3SeasonDriverId,
        p10DriverId: gpBet.p10SeasonDriverId,
        fastestLapDriverId: gpBet.fastestLapSeasonDriverId,
        dnfDrivers: dnfDrivers,
        willBeSafetyCar: gpBet.willBeSafetyCar,
        willBeRedFlag: gpBet.willBeRedFlag,
      ),
    ));
  }

  Future<void> _addGrandPrixBet(String loggedUserId) async {
    await _grandPrixBetRepository.addGrandPrixBet(
      playerId: loggedUserId,
      grandPrixId: _grandPrixId,
      qualiStandingsByDriverIds: state.qualiStandingsByDriverIds,
      p1DriverId: state.raceForm.p1DriverId,
      p2DriverId: state.raceForm.p2DriverId,
      p3DriverId: state.raceForm.p3DriverId,
      p10DriverId: state.raceForm.p10DriverId,
      fastestLapDriverId: state.raceForm.fastestLapDriverId,
      dnfDriverIds: state.raceForm.dnfDrivers
          .map((Driver driver) => driver.seasonDriverId)
          .toList(),
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
      dnfDriverIds: state.raceForm.dnfDrivers
          .map((Driver driver) => driver.seasonDriverId)
          .toList(),
      willBeSafetyCar: state.raceForm.willBeSafetyCar,
      willBeRedFlag: state.raceForm.willBeRedFlag,
    );
  }
}

typedef _ListenedParams = ({List<Driver> allDrivers, GrandPrixBet? gpBet});
