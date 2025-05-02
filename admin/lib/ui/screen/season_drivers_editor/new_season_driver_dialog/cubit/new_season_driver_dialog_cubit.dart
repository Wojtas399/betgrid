import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../data/repository/driver_personal_data/driver_personal_data_repository.dart';
import '../../../../../data/repository/season_driver/season_driver_repository.dart';
import '../../../../../data/repository/season_team/season_team_repository.dart';
import '../../../../../data/repository/team_basic_info/team_basic_info_repository.dart';
import '../../../../../model/driver_personal_data.dart';
import '../../../../../model/season_driver.dart';
import '../../../../../model/team_basic_info.dart';
import 'new_season_driver_dialog_state.dart';

@injectable
class NewSeasonDriverDialogCubit extends Cubit<NewSeasonDriverDialogState> {
  final SeasonDriverRepository _seasonDriverRepository;
  final SeasonTeamRepository _seasonTeamRepository;
  final DriverPersonalDataRepository _driverPersonalDataRepository;
  final TeamBasicInfoRepository _teamBasicInfoRepository;
  final int _season;
  StreamSubscription? _listener;

  NewSeasonDriverDialogCubit(
    this._seasonDriverRepository,
    this._seasonTeamRepository,
    this._driverPersonalDataRepository,
    this._teamBasicInfoRepository,
    @factoryParam this._season,
  ) : super(const NewSeasonDriverDialogState());

  @override
  Future<void> close() {
    _listener?.cancel();
    return super.close();
  }

  void initialize() {
    _listener = _getListenedParams().listen((params) {
      emit(
        state.copyWith(
          status: NewSeasonDriverDialogStateStatus.completed,
          driversToSelect: params.driversToSelect,
          teamsToSelect: params.teamsToSelect,
        ),
      );
    });
  }

  void onDriverSelected(String driverId) {
    assert(driverId.isNotEmpty);
    emit(
      state.copyWith(
        status: NewSeasonDriverDialogStateStatus.completed,
        selectedDriverId: driverId,
      ),
    );
  }

  void onDriverNumberChanged(int number) {
    assert(number >= 0);
    emit(
      state.copyWith(
        status: NewSeasonDriverDialogStateStatus.completed,
        driverNumber: number,
      ),
    );
  }

  void onTeamSelected(String teamId) {
    assert(teamId.isNotEmpty);
    emit(
      state.copyWith(
        status: NewSeasonDriverDialogStateStatus.completed,
        selectedTeamId: teamId,
      ),
    );
  }

  Future<void> submit() async {
    final String? selectedDriverId = state.selectedDriverId;
    final int? driverNumber = state.driverNumber;
    final String? selectedTeamId = state.selectedTeamId;
    assert(selectedDriverId != null && selectedDriverId.isNotEmpty == true);
    assert(driverNumber != null && driverNumber >= 0);
    assert(selectedTeamId != null && selectedTeamId.isNotEmpty == true);
    emit(
      state.copyWith(
        status: NewSeasonDriverDialogStateStatus.addingDriverToSeason,
      ),
    );
    await _seasonDriverRepository.add(
      season: _season,
      driverId: selectedDriverId!,
      driverNumber: driverNumber!,
      teamId: selectedTeamId!,
    );
    emit(
      state.copyWith(
        status: NewSeasonDriverDialogStateStatus.driverAddedToSeason,
        selectedDriverId: null,
        driverNumber: null,
        selectedTeamId: null,
      ),
    );
  }

  Stream<_ListenedParams> _getListenedParams() {
    return Rx.combineLatest2(
      _getDriversToSelect(),
      _getTeamsToSelect(),
      (
        List<DriverPersonalData> driversToSelect,
        List<TeamBasicInfo> teamsToSelect,
      ) => (driversToSelect: driversToSelect, teamsToSelect: teamsToSelect),
    );
  }

  Stream<List<DriverPersonalData>> _getDriversToSelect() {
    return Rx.combineLatest2(
      _seasonDriverRepository.getAllFromSeason(_season),
      _driverPersonalDataRepository.getAll(),
      (
        List<SeasonDriver> driversFromSeason,
        List<DriverPersonalData> allDriversPersonalData,
      ) {
        final idsOfDriversInSeason = driversFromSeason.map(
          (seasonDriver) => seasonDriver.driverId,
        );
        return allDriversPersonalData
            .where(
              (driverPersonalData) =>
                  !idsOfDriversInSeason.contains(driverPersonalData.id),
            )
            .toList();
      },
    );
  }

  Stream<List<TeamBasicInfo>> _getTeamsToSelect() {
    return _seasonTeamRepository
        .getAllFromSeason(_season)
        .switchMap(
          (seasonTeams) => Rx.combineLatest(
            seasonTeams.map(
              (seasonTeam) =>
                  _teamBasicInfoRepository.getById(seasonTeam.teamId),
            ),
            (teamStreams) => teamStreams.whereType<TeamBasicInfo>().toList(),
          ),
        );
  }
}

typedef _ListenedParams =
    ({
      List<DriverPersonalData> driversToSelect,
      List<TeamBasicInfo> teamsToSelect,
    });
