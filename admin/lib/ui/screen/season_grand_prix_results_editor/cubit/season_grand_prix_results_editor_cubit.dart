import 'dart:async';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/repository/driver_personal_data/driver_personal_data_repository.dart';
import '../../../../data/repository/grand_prix_basic_info/grand_prix_basic_info_repository.dart';
import '../../../../data/repository/season_driver/season_driver_repository.dart';
import '../../../../data/repository/season_grand_prix/season_grand_prix_repository.dart';
import '../../../../data/repository/season_grand_prix_results/season_grand_prix_results_repository.dart';
import '../../../../data/repository/season_team/season_team_repository.dart';
import '../../../../model/driver_personal_data.dart';
import '../../../../model/grand_prix_basic_info.dart';
import '../../../../model/season_driver.dart';
import '../../../../model/season_grand_prix.dart';
import '../../../../model/season_grand_prix_results.dart';
import '../../../../model/season_team.dart';
import 'season_grand_prix_results_editor_race_form.dart';
import 'season_grand_prix_results_editor_state.dart';

@injectable
class SeasonGrandPrixResultsEditorCubit
    extends Cubit<SeasonGrandPrixResultsEditorState> {
  final SeasonGrandPrixResultsRepository _seasonGrandPrixResultsRepository;
  final SeasonGrandPrixRepository _seasonGrandPrixRepository;
  final GrandPrixBasicInfoRepository _grandPrixBasicInfoRepository;
  final SeasonDriverRepository _seasonDriverRepository;
  final DriverPersonalDataRepository _driverPersonalDataRepository;
  final SeasonTeamRepository _seasonTeamRepository;
  final int _season;
  final String _seasonGrandPrixId;
  StreamSubscription<_ListenedParams>? _listener;

  SeasonGrandPrixResultsEditorCubit(
    this._seasonGrandPrixResultsRepository,
    this._seasonGrandPrixRepository,
    this._grandPrixBasicInfoRepository,
    this._seasonDriverRepository,
    this._driverPersonalDataRepository,
    this._seasonTeamRepository,
    @factoryParam this._season,
    @factoryParam this._seasonGrandPrixId,
  ) : super(const SeasonGrandPrixResultsEditorState.initial());

  @override
  Future<void> close() {
    _listener?.cancel();
    return super.close();
  }

  void initialize() {
    _listener ??= _getListenedParams().listen(_manageListenedParams);
  }

  void onQualiStandingsChanged({
    required int standing,
    required String driverId,
  }) {
    final List<String?> updatedQualiStandings = [
      ..._loadedState.qualiStandingsBySeasonDriverIds,
    ];
    final int matchingValueIndex = updatedQualiStandings.indexOf(driverId);
    if (matchingValueIndex >= 0) {
      updatedQualiStandings[matchingValueIndex] = null;
    }
    updatedQualiStandings[standing - 1] = driverId;
    emit(
      _loadedState.copyWith(
        qualiStandingsBySeasonDriverIds: updatedQualiStandings,
      ),
    );
  }

  void onRaceP1DriverChanged(String seasonDriverId) {
    emit(
      _loadedState.copyWith(
        raceForm: _loadedState.raceForm
            .removeFromPodiumOrP10IfExists(seasonDriverId)
            .copyWith(p1SeasonDriverId: seasonDriverId),
      ),
    );
  }

  void onRaceP2DriverChanged(String seasonDriverId) {
    emit(
      _loadedState.copyWith(
        raceForm: _loadedState.raceForm
            .removeFromPodiumOrP10IfExists(seasonDriverId)
            .copyWith(p2SeasonDriverId: seasonDriverId),
      ),
    );
  }

  void onRaceP3DriverChanged(String seasonDriverId) {
    emit(
      _loadedState.copyWith(
        raceForm: _loadedState.raceForm
            .removeFromPodiumOrP10IfExists(seasonDriverId)
            .copyWith(p3SeasonDriverId: seasonDriverId),
      ),
    );
  }

  void onRaceP10DriverChanged(String seasonDriverId) {
    emit(
      _loadedState.copyWith(
        raceForm: _loadedState.raceForm
            .removeFromPodiumOrP10IfExists(seasonDriverId)
            .copyWith(p10SeasonDriverId: seasonDriverId),
      ),
    );
  }

  void onRaceFastestLapDriverChanged(String driverId) {
    emit(
      _loadedState.copyWith(
        raceForm: _loadedState.raceForm.copyWith(
          fastestLapSeasonDriverId: driverId,
        ),
      ),
    );
  }

  void onDnfDriverSelected(String driverId) {
    if (_loadedState.allSeasonDrivers == null) return;

    final DriverDetails? selectedSeasonDriver = _loadedState.allSeasonDrivers!
        .firstWhereOrNull(
          (DriverDetails seasonDriverDetails) =>
              seasonDriverDetails.seasonDriverId == driverId,
        );
    final bool isAlreadyAddedToDnf = _loadedState.raceForm.dnfSeasonDrivers
        .contains(selectedSeasonDriver);

    if (selectedSeasonDriver == null || isAlreadyAddedToDnf) {
      return;
    }

    final List<DriverDetails> updatedDnfSeasonDrivers = [
      ..._loadedState.raceForm.dnfSeasonDrivers,
      selectedSeasonDriver,
    ];

    emit(
      _loadedState.copyWith(
        raceForm: _loadedState.raceForm.copyWith(
          dnfSeasonDrivers: updatedDnfSeasonDrivers,
        ),
      ),
    );
  }

  void onDnfDriverRemoved(String driverId) {
    if (_loadedState.allSeasonDrivers == null) return;

    final int indexOfSeasonDriverToRemove = _loadedState
        .raceForm
        .dnfSeasonDrivers
        .indexWhere(
          (DriverDetails driverDetails) =>
              driverDetails.seasonDriverId == driverId,
        );

    if (indexOfSeasonDriverToRemove == -1) return;

    final List<DriverDetails> updatedDnfSeasonDrivers = [
      ..._loadedState.raceForm.dnfSeasonDrivers,
    ]..removeAt(indexOfSeasonDriverToRemove);

    emit(
      _loadedState.copyWith(
        raceForm: _loadedState.raceForm.copyWith(
          dnfSeasonDrivers: updatedDnfSeasonDrivers,
        ),
      ),
    );
  }

  void onSafetyCarPredictionChanged(bool wasThereSafetyCar) {
    emit(
      _loadedState.copyWith(
        raceForm: _loadedState.raceForm.copyWith(
          wasThereSafetyCar: wasThereSafetyCar,
        ),
      ),
    );
  }

  void onRedFlagPredictionChanged(bool wasThereRedFlag) {
    emit(
      _loadedState.copyWith(
        raceForm: _loadedState.raceForm.copyWith(
          wasThereRedFlag: wasThereRedFlag,
        ),
      ),
    );
  }

  Future<void> submit() async {
    emit(
      _loadedState.copyWith(
        actionStatus: SeasonGrandPrixResultsEditorStateActionStatus.saving,
      ),
    );

    if (_loadedState.originalSeasonGrandPrixResults == null) {
      await _addSeasonGrandPrixResults();
    } else {
      await _updateSeasonGrandPrixResults();
    }

    emit(
      _loadedState.copyWith(
        actionStatus: SeasonGrandPrixResultsEditorStateActionStatus.saved,
      ),
    );
  }

  SeasonGrandPrixResultsEditorStateLoaded get _loadedState =>
      state as SeasonGrandPrixResultsEditorStateLoaded;

  Stream<_ListenedParams> _getListenedParams() {
    return Rx.combineLatest3(
      _getGrandPrixName(),
      _getDetailsOfAllDriversFromSeason(),
      _seasonGrandPrixResultsRepository.getBySeasonGrandPrixId(
        season: _season,
        seasonGrandPrixId: _seasonGrandPrixId,
      ),
      (
        String? grandPrixName,
        List<DriverDetails> detailsOfAllDriversFromSeason,
        SeasonGrandPrixResults? seasonGrandPrixResults,
      ) => _ListenedParams(
        grandPrixName: grandPrixName,
        detailsOfAllDriversFromSeason: detailsOfAllDriversFromSeason,
        seasonGrandPrixResults: seasonGrandPrixResults,
      ),
    );
  }

  void _manageListenedParams(_ListenedParams params) {
    final SeasonGrandPrixResults? seasonGpResults =
        params.seasonGrandPrixResults;
    final List<DriverDetails> sortedAllDrivers = [
      ...params.detailsOfAllDriversFromSeason,
    ]..sort(
      (DriverDetails d1, DriverDetails d2) =>
          d1.teamName != d2.teamName
              ? d1.teamName.compareTo(d2.teamName)
              : d1.surname.compareTo(d2.surname),
    );

    List<DriverDetails> dnfSeasonDrivers = [];
    if (seasonGpResults?.dnfSeasonDriverIds != null) {
      dnfSeasonDrivers =
          seasonGpResults!.dnfSeasonDriverIds!
              .map(
                (String seasonDriverId) =>
                    params.detailsOfAllDriversFromSeason.firstWhere(
                      (DriverDetails driverDetails) =>
                          driverDetails.seasonDriverId == seasonDriverId,
                    ),
              )
              .toList();
    }

    emit(
      state is SeasonGrandPrixResultsEditorStateLoaded
          ? _copyWithCurrentLoadedState(
            params.grandPrixName,
            sortedAllDrivers,
            seasonGpResults,
            dnfSeasonDrivers,
          )
          : _createNewLoadedState(
            params.grandPrixName,
            sortedAllDrivers,
            seasonGpResults,
            dnfSeasonDrivers,
          ),
    );
  }

  Future<void> _addSeasonGrandPrixResults() async {
    await _seasonGrandPrixResultsRepository.add(
      season: _season,
      seasonGrandPrixId: _seasonGrandPrixId,
      qualiStandingsBySeasonDriverIds:
          _loadedState.qualiStandingsBySeasonDriverIds,
      p1SeasonDriverId: _loadedState.raceForm.p1SeasonDriverId,
      p2SeasonDriverId: _loadedState.raceForm.p2SeasonDriverId,
      p3SeasonDriverId: _loadedState.raceForm.p3SeasonDriverId,
      p10SeasonDriverId: _loadedState.raceForm.p10SeasonDriverId,
      fastestLapSeasonDriverId: _loadedState.raceForm.fastestLapSeasonDriverId,
      dnfSeasonDriverIds:
          _loadedState.raceForm.dnfSeasonDrivers
              .map((DriverDetails driver) => driver.seasonDriverId)
              .toList(),
      wasThereSafetyCar: _loadedState.raceForm.wasThereSafetyCar,
      wasThereRedFlag: _loadedState.raceForm.wasThereRedFlag,
    );
  }

  Future<void> _updateSeasonGrandPrixResults() async {
    await _seasonGrandPrixResultsRepository.update(
      id: _loadedState.originalSeasonGrandPrixResults!.id,
      season: _season,
      qualiStandingsBySeasonDriverIds:
          _loadedState.qualiStandingsBySeasonDriverIds,
      p1SeasonDriverId: _loadedState.raceForm.p1SeasonDriverId,
      p2SeasonDriverId: _loadedState.raceForm.p2SeasonDriverId,
      p3SeasonDriverId: _loadedState.raceForm.p3SeasonDriverId,
      p10SeasonDriverId: _loadedState.raceForm.p10SeasonDriverId,
      fastestLapSeasonDriverId: _loadedState.raceForm.fastestLapSeasonDriverId,
      dnfSeasonDriverIds:
          _loadedState.raceForm.dnfSeasonDrivers
              .map((DriverDetails driver) => driver.seasonDriverId)
              .toList(),
      wasThereSafetyCar: _loadedState.raceForm.wasThereSafetyCar,
      wasThereRedFlag: _loadedState.raceForm.wasThereRedFlag,
    );
  }

  Stream<List<DriverDetails>> _getDetailsOfAllDriversFromSeason() {
    return _seasonDriverRepository.getAllFromSeason(_season).switchMap((
      List<SeasonDriver> seasonDrivers,
    ) {
      final Iterable<Stream<DriverDetails?>> streams = seasonDrivers.map(
        _getDetailsForSeasonDriver,
      );

      return Rx.combineLatest(
        streams,
        (List<DriverDetails?> driverDetails) =>
            driverDetails.whereType<DriverDetails>().toList(),
      );
    });
  }

  Stream<String?> _getGrandPrixName() {
    return _seasonGrandPrixRepository
        .getById(season: _season, id: _seasonGrandPrixId)
        .switchMap(
          (SeasonGrandPrix? seasonGrandPrix) =>
              seasonGrandPrix == null
                  ? Stream.value(null)
                  : _grandPrixBasicInfoRepository.getById(
                    seasonGrandPrix.grandPrixId,
                  ),
        )
        .map(
          (GrandPrixBasicInfo? grandPrixBasicInfo) => grandPrixBasicInfo?.name,
        )
        .distinct();
  }

  SeasonGrandPrixResultsEditorStateLoaded _copyWithCurrentLoadedState(
    String? grandPrixName,
    List<DriverDetails> sortedAllDrivers,
    SeasonGrandPrixResults? seasonGpResults,
    List<DriverDetails> dnfSeasonDrivers,
  ) {
    return _loadedState.copyWith(
      originalSeasonGrandPrixResults: seasonGpResults,
      grandPrixName: grandPrixName,
      allSeasonDrivers: sortedAllDrivers,
      qualiStandingsBySeasonDriverIds:
          seasonGpResults?.qualiStandingsBySeasonDriverIds ??
          _loadedState.qualiStandingsBySeasonDriverIds,
      raceForm: _loadedState.raceForm.copyWith(
        p1SeasonDriverId: seasonGpResults?.p1SeasonDriverId,
        p2SeasonDriverId: seasonGpResults?.p2SeasonDriverId,
        p3SeasonDriverId: seasonGpResults?.p3SeasonDriverId,
        p10SeasonDriverId: seasonGpResults?.p10SeasonDriverId,
        fastestLapSeasonDriverId: seasonGpResults?.fastestLapSeasonDriverId,
        dnfSeasonDrivers: dnfSeasonDrivers,
        wasThereSafetyCar: seasonGpResults?.wasThereSafetyCar,
        wasThereRedFlag: seasonGpResults?.wasThereRedFlag,
      ),
    );
  }

  SeasonGrandPrixResultsEditorState _createNewLoadedState(
    String? grandPrixName,
    List<DriverDetails> sortedAllDrivers,
    SeasonGrandPrixResults? seasonGpResults,
    List<DriverDetails> dnfSeasonDrivers,
  ) {
    return SeasonGrandPrixResultsEditorState.loaded(
      originalSeasonGrandPrixResults: seasonGpResults,
      grandPrixName: grandPrixName,
      allSeasonDrivers: sortedAllDrivers,
      qualiStandingsBySeasonDriverIds:
          seasonGpResults?.qualiStandingsBySeasonDriverIds ??
          List.filled(20, null),
      raceForm: SeasonGrandPrixResultsEditorRaceForm(
        p1SeasonDriverId: seasonGpResults?.p1SeasonDriverId,
        p2SeasonDriverId: seasonGpResults?.p2SeasonDriverId,
        p3SeasonDriverId: seasonGpResults?.p3SeasonDriverId,
        p10SeasonDriverId: seasonGpResults?.p10SeasonDriverId,
        fastestLapSeasonDriverId: seasonGpResults?.fastestLapSeasonDriverId,
        dnfSeasonDrivers: dnfSeasonDrivers,
        wasThereSafetyCar: seasonGpResults?.wasThereSafetyCar,
        wasThereRedFlag: seasonGpResults?.wasThereRedFlag,
      ),
    );
  }

  Stream<DriverDetails?> _getDetailsForSeasonDriver(SeasonDriver seasonDriver) {
    return Rx.combineLatest2(
      _driverPersonalDataRepository.getById(seasonDriver.driverId),
      _seasonTeamRepository.getById(id: seasonDriver.teamId, season: _season),
      (DriverPersonalData? driverPersonalData, SeasonTeam? team) =>
          driverPersonalData == null || team == null
              ? null
              : DriverDetails(
                seasonDriverId: seasonDriver.id,
                name: driverPersonalData.name,
                surname: driverPersonalData.surname,
                number: seasonDriver.driverNumber,
                teamName: team.shortName,
                teamHexColor: team.baseHexColor,
              ),
    ).distinct();
  }
}

class _ListenedParams extends Equatable {
  final String? grandPrixName;
  final List<DriverDetails> detailsOfAllDriversFromSeason;
  final SeasonGrandPrixResults? seasonGrandPrixResults;

  const _ListenedParams({
    required this.grandPrixName,
    required this.detailsOfAllDriversFromSeason,
    required this.seasonGrandPrixResults,
  });

  @override
  List<Object?> get props => [
    grandPrixName,
    detailsOfAllDriversFromSeason,
    seasonGrandPrixResults,
  ];
}
