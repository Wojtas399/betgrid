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
import 'season_team_details_state.dart';

@injectable
class SeasonTeamDetailsCubit extends Cubit<SeasonTeamDetailsState> {
  final SeasonTeamRepository _seasonTeamRepository;
  final SeasonDriverRepository _seasonDriverRepository;
  final DriverPersonalDataRepository _driverPersonalDataRepository;
  StreamSubscription<SeasonTeamDetailsState>? _subscription;

  SeasonTeamDetailsCubit(
    this._seasonTeamRepository,
    this._seasonDriverRepository,
    this._driverPersonalDataRepository,
  ) : super(const SeasonTeamDetailsState.initial());

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  Future<void> initialize({
    required int season,
    required String seasonTeamId,
  }) async {
    _subscription ??= Rx.combineLatest2(
      _seasonTeamRepository.getById(id: seasonTeamId, season: season),
      _getDrivers(season, seasonTeamId),
      (SeasonTeam? seasonTeam, List<SeasonTeamDetailsDriverInfo> drivers) {
        if (seasonTeam == null) {
          throw Exception('[SeasonTeamDetailsCubit] Season team not found');
        }

        return SeasonTeamDetailsState.loaded(
          team: seasonTeam,
          drivers: drivers,
        );
      },
    ).listen(emit);
  }

  Stream<List<SeasonTeamDetailsDriverInfo>> _getDrivers(
    int season,
    String seasonTeamId,
  ) {
    return _seasonDriverRepository
        .getBySeasonTeamId(season: season, seasonTeamId: seasonTeamId)
        .switchMap((List<SeasonDriver> seasonDrivers) {
          final streams =
              seasonDrivers.map(_getDetailsAboutSeasonDriver).toList();

          return Rx.combineLatest(
            streams,
            (List<SeasonTeamDetailsDriverInfo> infos) => infos,
          );
        });
  }

  Stream<SeasonTeamDetailsDriverInfo> _getDetailsAboutSeasonDriver(
    SeasonDriver seasonDriver,
  ) {
    return _driverPersonalDataRepository.getById(seasonDriver.driverId).map((
      DriverPersonalData? driverPersonalData,
    ) {
      if (driverPersonalData == null) {
        throw Exception(
          '[SeasonTeamDetailsCubit] Driver personal data not found',
        );
      }

      return SeasonTeamDetailsDriverInfo(
        name: driverPersonalData.name,
        surname: driverPersonalData.surname,
        number: seasonDriver.driverNumber,
      );
    });
  }
}
