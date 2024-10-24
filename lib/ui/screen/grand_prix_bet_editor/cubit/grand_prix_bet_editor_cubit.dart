import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/repository/driver/driver_repository.dart';
import '../../../../model/driver.dart';
import 'grand_prix_bet_editor_state.dart';

@injectable
class GrandPrixBetEditorCubit extends Cubit<GrandPrixBetEditorState> {
  final DriverRepository _driverRepository;

  GrandPrixBetEditorCubit(
    this._driverRepository,
  ) : super(const GrandPrixBetEditorState());

  Future<void> initialize() async {
    final List<Driver> allDrivers =
        await _driverRepository.getAllDrivers().first;
    allDrivers.sort(
      (d1, d2) => d1.team.name.compareTo(d2.team.name) != 0
          ? d1.team.name.compareTo(d2.team.name)
          : d1.surname.compareTo(d2.surname),
    );
    emit(state.copyWith(
      status: GrandPrixBetEditorStateStatus.completed,
      allDrivers: allDrivers,
    ));
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

  void onRaceP1Changed({
    required String driverId,
  }) {
    emit(state.copyWith(
      status: GrandPrixBetEditorStateStatus.completed,
      raceForm: state.raceForm.copyWith(
        p1DriverId: driverId,
      ),
    ));
  }

  void onRaceP2Changed({
    required String driverId,
  }) {
    emit(state.copyWith(
      status: GrandPrixBetEditorStateStatus.completed,
      raceForm: state.raceForm.copyWith(
        p2DriverId: driverId,
      ),
    ));
  }

  void onRaceP3Changed({
    required String driverId,
  }) {
    emit(state.copyWith(
      status: GrandPrixBetEditorStateStatus.completed,
      raceForm: state.raceForm.copyWith(
        p3DriverId: driverId,
      ),
    ));
  }

  void onRaceP10Changed({
    required String driverId,
  }) {
    emit(state.copyWith(
      status: GrandPrixBetEditorStateStatus.completed,
      raceForm: state.raceForm.copyWith(
        p10DriverId: driverId,
      ),
    ));
  }

  void onRaceFastestLapChanged({
    required String driverId,
  }) {
    emit(state.copyWith(
      status: GrandPrixBetEditorStateStatus.completed,
      raceForm: state.raceForm.copyWith(
        fastestLapDriverId: driverId,
      ),
    ));
  }

  void onDnfDriverAdded({
    required String driverId,
  }) {
    if (state.raceForm.dnfDriverIds.contains(driverId)) return;
    final List<String> updatedDnfDrivers = [...state.raceForm.dnfDriverIds];
    updatedDnfDrivers.add(driverId);
    emit(state.copyWith(
      status: GrandPrixBetEditorStateStatus.completed,
      raceForm: state.raceForm.copyWith(
        dnfDriverIds: updatedDnfDrivers,
      ),
    ));
  }

  void onDnfDriverRemoved({
    required String driverId,
  }) {
    if (!state.raceForm.dnfDriverIds.contains(driverId)) return;
    final List<String> updatedDnfDrivers = [...state.raceForm.dnfDriverIds];
    updatedDnfDrivers.removeWhere((String id) => id == driverId);
    emit(state.copyWith(
      status: GrandPrixBetEditorStateStatus.completed,
      raceForm: state.raceForm.copyWith(
        dnfDriverIds: updatedDnfDrivers,
      ),
    ));
  }

  void onSafetyCarChanged({
    required bool willBeSafetyCar,
  }) {
    emit(state.copyWith(
      status: GrandPrixBetEditorStateStatus.completed,
      raceForm: state.raceForm.copyWith(
        willBeSafetyCar: willBeSafetyCar,
      ),
    ));
  }

  void onRedFlagChanged({
    required bool willBeRedFlag,
  }) {
    emit(state.copyWith(
      status: GrandPrixBetEditorStateStatus.completed,
      raceForm: state.raceForm.copyWith(
        willBeRedFlag: willBeRedFlag,
      ),
    ));
  }
}
