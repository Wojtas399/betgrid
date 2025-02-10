import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/repository/auth/auth_repository.dart';
import '../../../../data/repository/player_stats/player_stats_repository.dart';
import '../../../../data/repository/season_driver/season_driver_repository.dart';
import '../../../../model/driver_details.dart';
import '../../../../model/player_stats.dart';
import '../../../../model/season_driver.dart';
import '../../../../use_case/get_details_for_season_driver_use_case.dart';
import '../stats_model/points_for_driver.dart';

@injectable
class CreateLoggedUserPointsForDriversStats {
  final AuthRepository _authRepository;
  final PlayerStatsRepository _playerStatsRepository;
  final SeasonDriverRepository _seasonDriverRepository;
  final GetDetailsForSeasonDriverUseCase _getDetailsForSeasonDriverUseCase;

  const CreateLoggedUserPointsForDriversStats(
    this._authRepository,
    this._playerStatsRepository,
    this._seasonDriverRepository,
    this._getDetailsForSeasonDriverUseCase,
  );

  Stream<List<PointsForDriver>?> call({
    required int season,
  }) {
    return _authRepository.loggedUserId$
        .switchMap(
      (String? loggedUserId) => loggedUserId != null
          ? _getPointsForDriversFromStats(loggedUserId, season)
          : Stream.value(null),
    )
        .switchMap(
      (List<PlayerStatsPointsForDriver>? pointsForDriversFromStats) {
        if (pointsForDriversFromStats == null ||
            pointsForDriversFromStats.isEmpty) {
          return Stream.value(null);
        }

        final Iterable<Stream<PointsForDriver?>>
            pointsWithDriverDetailsStreams = pointsForDriversFromStats.map(
          (PlayerStatsPointsForDriver pointsForSingleDriver) {
            return _getDetailsForSeasonDriver(
              season,
              pointsForSingleDriver.seasonDriverId,
            ).map(
              (DriverDetails? driverDetails) => PointsForDriver(
                driverDetails: driverDetails!,
                points: pointsForSingleDriver.points,
              ),
            );
          },
        );

        return Rx.combineLatest(
          pointsWithDriverDetailsStreams,
          (List<PointsForDriver?> pointsForDrivers) =>
              pointsForDrivers.whereType<PointsForDriver>().toList(),
        );
      },
    ).map(_sortPointsForDriversInDescendingOrder);
  }

  Stream<List<PlayerStatsPointsForDriver>?> _getPointsForDriversFromStats(
    String loggedUserId,
    int season,
  ) {
    return _playerStatsRepository
        .getStatsByPlayerIdAndSeason(
          playerId: loggedUserId,
          season: season,
        )
        .map((PlayerStats? stats) => stats?.pointsForDrivers);
  }

  Stream<DriverDetails?> _getDetailsForSeasonDriver(
    int season,
    String seasonDriverId,
  ) {
    return _seasonDriverRepository
        .getById(
          season: season,
          seasonDriverId: seasonDriverId,
        )
        .switchMap(
          (SeasonDriver? seasonDriver) =>
              _getDetailsForSeasonDriverUseCase(seasonDriver!),
        );
  }

  List<PointsForDriver>? _sortPointsForDriversInDescendingOrder(
    List<PointsForDriver>? pointsForDrivers,
  ) {
    if (pointsForDrivers == null) return null;
    return [...pointsForDrivers]..sort(
        (a, b) => b.points.compareTo(a.points),
      );
  }
}
