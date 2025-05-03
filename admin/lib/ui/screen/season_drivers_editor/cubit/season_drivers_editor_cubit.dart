import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/repository/driver_personal_data/driver_personal_data_repository.dart';
import '../../../../data/repository/season_driver/season_driver_repository.dart';
import '../../../../data/repository/season_team/season_team_repository.dart';
import '../../../../model/driver_personal_data.dart';
import '../../../../model/season_driver.dart';
import '../../../../model/season_team.dart';
import '../../../service/date_service.dart';
import 'season_drivers_editor_state.dart';

@injectable
class SeasonDriversEditorCubit extends Cubit<SeasonDriversEditorState> {
  final SeasonDriverRepository _seasonDriverRepository;
  final DriverPersonalDataRepository _driverPersonalDataRepository;
  final SeasonTeamRepository _seasonTeamRepository;
  final DateService _dateService;
  StreamSubscription? _listener;

  SeasonDriversEditorCubit(
    this._seasonDriverRepository,
    this._driverPersonalDataRepository,
    this._seasonTeamRepository,
    this._dateService,
  ) : super(const SeasonDriversEditorState());

  @override
  Future<void> close() {
    _listener?.cancel();
    return super.close();
  }

  void initializeDriversListener() {
    _listener = Rx.combineLatest2(
          _getDriversFromSeason(),
          _driverPersonalDataRepository.getAll(),
          (driversFromSeason, allDriversPersonalData) => (
            driversFromSeason: driversFromSeason,
            allDriversPersonalData: allDriversPersonalData,
          ),
        )
        .switchMap((_ListenedData data) {
          final areThereOtherDriversToAdd =
              _areThereOtherDriversNotAddedToSeason(data);

          return _getSeasonDriversDescriptions(data).map((
            List<SeasonDriverDescription> descriptions,
          ) {
            final sortedDriversDescriptions = [...descriptions]
              ..sortByTeamAndSurname();

            return (
              descriptionsOfAllDriversFromSeason: sortedDriversDescriptions,
              areThereOtherDriversToAdd: areThereOtherDriversToAdd,
            );
          });
        })
        .listen((data) {
          emit(
            state.copyWith(
              status: SeasonDriversEditorStateStatus.completed,
              driversInSeason: data.descriptionsOfAllDriversFromSeason,
              areThereOtherDriversToAdd: data.areThereOtherDriversToAdd,
            ),
          );
        });
  }

  void initializeSeason() {
    final int currentSeason = _dateService.getNow().year;
    emit(
      state.copyWith(
        currentSeason: currentSeason,
        selectedSeason: currentSeason,
      ),
    );
  }

  void onSeasonSelected(int season) {
    final int? currentSeason = state.currentSeason;
    assert(currentSeason != null);
    assert(season == currentSeason || season == currentSeason! + 1);
    emit(
      state.copyWith(
        status: SeasonDriversEditorStateStatus.changingSeason,
        selectedSeason: season,
      ),
    );
  }

  Future<void> deleteDriverFromSeason({required String seasonDriverId}) async {
    assert(seasonDriverId.isNotEmpty && state.selectedSeason != null);
    emit(
      state.copyWith(
        status: SeasonDriversEditorStateStatus.deletingDriverFromSeason,
      ),
    );
    await _seasonDriverRepository.delete(
      season: state.selectedSeason!,
      seasonDriverId: seasonDriverId,
    );
    emit(
      state.copyWith(
        status: SeasonDriversEditorStateStatus.driverDeletedFromSeason,
      ),
    );
  }

  Stream<List<SeasonDriver>> _getDriversFromSeason() {
    return stream
        .map((state) => state.selectedSeason)
        .whereType<int>()
        .distinct()
        .switchMap(
          (int season) => _seasonDriverRepository
              .getAllFromSeason(season)
              .shareReplay(maxSize: 1),
        );
  }

  Stream<List<SeasonDriverDescription>> _getSeasonDriversDescriptions(
    _ListenedData data,
  ) {
    if (data.driversFromSeason.isEmpty) return Stream.value([]);
    final driverDescriptions = data.driversFromSeason.map((seasonDriver) {
      final personalData = data.allDriversPersonalData.firstWhere(
        (driver) => driver.id == seasonDriver.driverId,
      );
      return _prepareDescriptionForSingleSeasonDriver(
        seasonDriver,
        personalData,
      ).shareReplay(maxSize: 1);
    });
    return Rx.combineLatest(
      driverDescriptions,
      (seasonDriversDescriptions) => seasonDriversDescriptions.toList(),
    );
  }

  bool _areThereOtherDriversNotAddedToSeason(_ListenedData data) {
    final idsOfDriversInSeason = data.driversFromSeason.map(
      (driver) => driver.driverId,
    );
    return data.allDriversPersonalData
        .where((driver) => !idsOfDriversInSeason.contains(driver.id))
        .isNotEmpty;
  }

  Stream<SeasonDriverDescription> _prepareDescriptionForSingleSeasonDriver(
    SeasonDriver seasonDriver,
    DriverPersonalData driverPersonalData,
  ) {
    return _seasonTeamRepository
        .getById(id: seasonDriver.teamId, season: state.selectedSeason!)
        .map(
          (SeasonTeam? seasonTeam) =>
              seasonTeam != null
                  ? SeasonDriverDescription(
                    seasonDriverId: seasonDriver.id,
                    driverId: driverPersonalData.id,
                    name: driverPersonalData.name,
                    surname: driverPersonalData.surname,
                    numberInSeason: seasonDriver.driverNumber,
                    teamNameInSeason: seasonTeam.shortName,
                  )
                  : null,
        )
        .whereType<SeasonDriverDescription>();
  }
}

typedef _ListenedData =
    ({
      List<SeasonDriver> driversFromSeason,
      List<DriverPersonalData> allDriversPersonalData,
    });

extension _ListOfDriverDescriptionsExtension on List<SeasonDriverDescription> {
  void sortByTeamAndSurname() {
    sort((d1, d2) {
      final teamComparison = d1.teamNameInSeason.compareTo(d2.teamNameInSeason);
      return teamComparison != 0
          ? teamComparison
          : d1.surname.compareTo(d2.surname);
    });
  }
}
