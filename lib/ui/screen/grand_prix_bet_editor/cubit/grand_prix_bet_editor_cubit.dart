import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/repository/auth/auth_repository.dart';
import '../../../../data/repository/grand_prix_bet/grand_prix_bet_repository.dart';
import '../../../../model/driver_details.dart';
import '../../../../model/grand_prix_bet.dart';
import '../../../../use_case/get_details_of_all_drivers_from_season_use_case.dart';
import '../../../extensions/list_of_driver_details_extensions.dart';
import 'grand_prix_bet_editor_state.dart';

@injectable
class GrandPrixBetEditorCubit extends Cubit<GrandPrixBetEditorState> {
  final AuthRepository _authRepository;
  final GrandPrixBetRepository _grandPrixBetRepository;
  final GetDetailsOfAllDriversFromSeasonUseCase
      _getDetailsOfAllDriversFromSeasonUseCase;
  final int _season;
  final String _seasonGrandPrixId;
  StreamSubscription<_ListenedParams?>? _listener;

  GrandPrixBetEditorCubit(
    this._authRepository,
    this._grandPrixBetRepository,
    this._getDetailsOfAllDriversFromSeasonUseCase,
    @factoryParam this._season,
    @factoryParam this._seasonGrandPrixId,
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
      (
        List<DriverDetails> detailsOfAllDriversFromSeason,
        GrandPrixBet? gpBet,
      ) =>
          (
        detailsOfAllDriversFromSeason: detailsOfAllDriversFromSeason,
        gpBet: gpBet,
      ),
    ).listen(_manageListenedParams);
  }

  void onQualiStandingsChanged({
    required int standing,
    required String driverId,
  }) {
    final List<String?> updatedQualiStandings = [
      ...state.qualiStandingsBySeasonDriverIds,
    ];
    final int matchingValueIndex = updatedQualiStandings.indexOf(driverId);
    if (matchingValueIndex >= 0) {
      updatedQualiStandings[matchingValueIndex] = null;
    }
    updatedQualiStandings[standing - 1] = driverId;
    emit(state.copyWith(
      status: GrandPrixBetEditorStateStatus.completed,
      qualiStandingsBySeasonDriverIds: updatedQualiStandings,
    ));
  }

  void onRaceP1DriverChanged(String driverId) {
    emit(state.copyWith(
      status: GrandPrixBetEditorStateStatus.completed,
      raceForm: state.raceForm.copyWith(
        p1SeasonDriverId: driverId,
      ),
    ));
  }

  void onRaceP2DriverChanged(String driverId) {
    emit(state.copyWith(
      status: GrandPrixBetEditorStateStatus.completed,
      raceForm: state.raceForm.copyWith(
        p2SeasonDriverId: driverId,
      ),
    ));
  }

  void onRaceP3DriverChanged(String driverId) {
    emit(state.copyWith(
      status: GrandPrixBetEditorStateStatus.completed,
      raceForm: state.raceForm.copyWith(
        p3SeasonDriverId: driverId,
      ),
    ));
  }

  void onRaceP10DriverChanged(String driverId) {
    emit(state.copyWith(
      status: GrandPrixBetEditorStateStatus.completed,
      raceForm: state.raceForm.copyWith(
        p10SeasonDriverId: driverId,
      ),
    ));
  }

  void onRaceFastestLapDriverChanged(String driverId) {
    emit(state.copyWith(
      status: GrandPrixBetEditorStateStatus.completed,
      raceForm: state.raceForm.copyWith(
        fastestLapSeasonDriverId: driverId,
      ),
    ));
  }

  void onDnfDriverSelected(String driverId) {
    if (state.allDrivers == null) return;
    final DriverDetails? selectedDriver = state.allDrivers!.firstWhereOrNull(
      (DriverDetails driverDetails) => driverDetails.seasonDriverId == driverId,
    );
    if (selectedDriver == null ||
        state.raceForm.dnfDrivers.contains(selectedDriver)) {
      return;
    }
    final List<DriverDetails> updatedDnfDrivers = [
      ...state.raceForm.dnfDrivers,
    ];
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
      (DriverDetails driverDetails) => driverDetails.seasonDriverId == driverId,
    );
    if (indexOfDriverToRemove == -1) return;
    final List<DriverDetails> updatedDnfDrivers = [
      ...state.raceForm.dnfDrivers
    ];
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

  Stream<List<DriverDetails>> _getAllSortedDrivers() {
    return _getDetailsOfAllDriversFromSeasonUseCase(2024).map(
      (List<DriverDetails> detailsOfAllDriversFromSeason) {
        final sortedDetailsOfAllDriversFromSeason = [
          ...detailsOfAllDriversFromSeason
        ];
        sortedDetailsOfAllDriversFromSeason.sortByTeamAndSurname();
        return sortedDetailsOfAllDriversFromSeason;
      },
    );
  }

  Stream<GrandPrixBet?> _getBetForGrandPrix() {
    return _authRepository.loggedUserId$.whereNotNull().switchMap(
          (String loggedUserId) => _grandPrixBetRepository.getGrandPrixBet(
            playerId: loggedUserId,
            season: _season,
            seasonGrandPrixId: _seasonGrandPrixId,
          ),
        );
  }

  void _manageListenedParams(_ListenedParams listenedParams) {
    final GrandPrixBet? gpBet = listenedParams.gpBet;
    final List<DriverDetails> detailsOfAllDriversFromSeason =
        listenedParams.detailsOfAllDriversFromSeason;
    GrandPrixBetEditorState newState = state.copyWith(
      status: GrandPrixBetEditorStateStatus.completed,
      allDrivers: detailsOfAllDriversFromSeason,
    );
    if (gpBet == null) {
      emit(newState);
      return;
    }
    final List<DriverDetails> dnfDrivers = gpBet.dnfSeasonDriverIds
        .whereType<String>()
        .map(
          (String driverId) => detailsOfAllDriversFromSeason.firstWhere(
            (DriverDetails driver) => driver.seasonDriverId == driverId,
          ),
        )
        .toList();
    emit(newState.copyWith(
      originalGrandPrixBet: gpBet,
      qualiStandingsBySeasonDriverIds: gpBet.qualiStandingsBySeasonDriverIds,
      raceForm: state.raceForm.copyWith(
        p1SeasonDriverId: gpBet.p1SeasonDriverId,
        p2SeasonDriverId: gpBet.p2SeasonDriverId,
        p3SeasonDriverId: gpBet.p3SeasonDriverId,
        p10SeasonDriverId: gpBet.p10SeasonDriverId,
        fastestLapSeasonDriverId: gpBet.fastestLapSeasonDriverId,
        dnfDrivers: dnfDrivers,
        willBeSafetyCar: gpBet.willBeSafetyCar,
        willBeRedFlag: gpBet.willBeRedFlag,
      ),
    ));
  }

  Future<void> _addGrandPrixBet(String loggedUserId) async {
    await _grandPrixBetRepository.addGrandPrixBet(
      playerId: loggedUserId,
      season: _season,
      seasonGrandPrixId: _seasonGrandPrixId,
      qualiStandingsBySeasonDriverIds: state.qualiStandingsBySeasonDriverIds,
      p1SeasonDriverId: state.raceForm.p1SeasonDriverId,
      p2SeasonDriverId: state.raceForm.p2SeasonDriverId,
      p3SeasonDriverId: state.raceForm.p3SeasonDriverId,
      p10SeasonDriverId: state.raceForm.p10SeasonDriverId,
      fastestLapSeasonDriverId: state.raceForm.fastestLapSeasonDriverId,
      dnfSeasonDriverIds: state.raceForm.dnfDrivers
          .map((DriverDetails driver) => driver.seasonDriverId)
          .toList(),
      willBeSafetyCar: state.raceForm.willBeSafetyCar,
      willBeRedFlag: state.raceForm.willBeRedFlag,
    );
  }

  Future<void> _updateGrandPrixBet(String loggedUserId) async {
    await _grandPrixBetRepository.updateGrandPrixBet(
      playerId: loggedUserId,
      season: _season,
      seasonGrandPrixId: state.originalGrandPrixBet!.id,
      qualiStandingsBySeasonDriverIds: state.qualiStandingsBySeasonDriverIds,
      p1SeasonDriverId: state.raceForm.p1SeasonDriverId,
      p2SeasonDriverId: state.raceForm.p2SeasonDriverId,
      p3SeasonDriverId: state.raceForm.p3SeasonDriverId,
      p10SeasonDriverId: state.raceForm.p10SeasonDriverId,
      fastestLapSeasonDriverId: state.raceForm.fastestLapSeasonDriverId,
      dnfSeasonDriverIds: state.raceForm.dnfDrivers
          .map((DriverDetails driver) => driver.seasonDriverId)
          .toList(),
      willBeSafetyCar: state.raceForm.willBeSafetyCar,
      willBeRedFlag: state.raceForm.willBeRedFlag,
    );
  }
}

typedef _ListenedParams = ({
  List<DriverDetails> detailsOfAllDriversFromSeason,
  GrandPrixBet? gpBet,
});
