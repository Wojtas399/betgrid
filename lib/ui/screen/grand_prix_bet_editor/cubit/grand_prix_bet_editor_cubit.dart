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
  GrandPrixBet? _grandPrixBet;

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
    final List<Driver> sortedAllDrivers = await _loadSortedAllDrivers();
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
    if (selectedDriver == null) return;
    final List<Driver> updatedDnfDrivers = [...state.raceForm.dnfDrivers];
    if (updatedDnfDrivers.contains(selectedDriver)) {
      updatedDnfDrivers.remove(selectedDriver);
    } else {
      updatedDnfDrivers.add(selectedDriver);
    }
    updatedDnfDrivers.sortByTeamAndSurname();
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
    //TODO: Implement submit method
    print(state);
  }

  Future<List<Driver>> _loadSortedAllDrivers() async {
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
    _grandPrixBet = bet;
    List<Driver> dnfDrivers = state.raceForm.dnfDrivers;
    if (bet != null) {
      dnfDrivers = bet.dnfDriverIds
          .whereNotNull()
          .map(
            (String driverId) => allDrivers.firstWhere(
              (Driver driver) => driver.id == driverId,
            ),
          )
          .toList();
    }
    emit(state.copyWith(
      status: GrandPrixBetEditorStateStatus.completed,
      allDrivers: allDrivers,
      qualiStandingsByDriverIds:
          bet?.qualiStandingsByDriverIds ?? state.qualiStandingsByDriverIds,
      raceForm: state.raceForm.copyWith(
        p1DriverId: bet?.p1DriverId,
        p2DriverId: bet?.p2DriverId,
        p3DriverId: bet?.p3DriverId,
        p10DriverId: bet?.p10DriverId,
        fastestLapDriverId: bet?.fastestLapDriverId,
        dnfDrivers: dnfDrivers,
        willBeSafetyCar: bet?.willBeSafetyCar,
        willBeRedFlag: bet?.willBeRedFlag,
      ),
    ));
  }
}
