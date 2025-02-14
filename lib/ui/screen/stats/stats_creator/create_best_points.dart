import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/repository/auth/auth_repository.dart';
import '../../../../data/repository/driver_personal_data/driver_personal_data_repository.dart';
import '../../../../data/repository/grand_prix_basic_info/grand_prix_basic_info_repository.dart';
import '../../../../data/repository/player/player_repository.dart';
import '../../../../data/repository/player_stats/player_stats_repository.dart';
import '../../../../data/repository/season_driver/season_driver_repository.dart';
import '../../../../data/repository/season_grand_prix/season_grand_prix_repository.dart';
import '../../../../model/driver_personal_data.dart';
import '../../../../model/grand_prix_basic_info.dart';
import '../../../../model/player.dart';
import '../../../../model/player_stats.dart';
import '../../../../model/season_driver.dart';
import '../../../../model/season_grand_prix.dart';
import '../cubit/stats_state.dart';
import '../stats_model/best_points.dart';

@injectable
class CreateBestPoints {
  final AuthRepository _authRepository;
  final PlayerRepository _playerRepository;
  final PlayerStatsRepository _playerStatsRepository;
  final SeasonGrandPrixRepository _seasonGrandPrixRepository;
  final GrandPrixBasicInfoRepository _grandPrixBasicInfoRepository;
  final SeasonDriverRepository _seasonDriverRepository;
  final DriverPersonalDataRepository _driverPersonalDataRepository;

  const CreateBestPoints(
    this._authRepository,
    this._playerRepository,
    this._playerStatsRepository,
    this._seasonGrandPrixRepository,
    this._grandPrixBasicInfoRepository,
    this._seasonDriverRepository,
    this._driverPersonalDataRepository,
  );

  Stream<BestPoints?> call({
    required StatsType statsType,
    required int season,
  }) {
    return switch (statsType) {
      StatsType.grouped => _createGroupedBestPoints(season),
      StatsType.individual => _createIndividualBestPoints(season),
    };
  }

  Stream<BestPoints?> _createGroupedBestPoints(int season) {
    return _playerRepository
        .getAll()
        .switchMap(
          (List<Player> allPlayers) => _getStatsForPlayers(allPlayers, season),
        )
        .switchMap((List<_PlayerWithStats>? playersWithStats) {
          if (playersWithStats == null || playersWithStats.isEmpty) {
            return Stream.value(null);
          }

          final bestGp = _selectBestGp(playersWithStats);
          final bestQuali = _selectBestQuali(playersWithStats);
          final bestRace = _selectBestRace(playersWithStats);
          final bestDriver = _selectBestDriver(playersWithStats);

          return _getGpAndDriverDetails(
            season,
            bestGp?.seasonGpPointsData.seasonGrandPrixId,
            bestQuali?.seasonGpPointsData.seasonGrandPrixId,
            bestRace?.seasonGpPointsData.seasonGrandPrixId,
            bestDriver?.seasonDriverPointsData.seasonDriverId,
          ).map(
            (_GpAndDriverDetails gpAndDriverDetails) => BestPoints(
              bestGpPoints:
                  bestGp != null
                      ? BestPointsForGp(
                        points: bestGp.seasonGpPointsData.points,
                        playerName: bestGp.player.username,
                        grandPrixName: gpAndDriverDetails.bestGp?.name,
                      )
                      : null,
              bestQualiPoints:
                  bestQuali != null
                      ? BestPointsForGp(
                        points: bestQuali.seasonGpPointsData.points,
                        playerName: bestQuali.player.username,
                        grandPrixName: gpAndDriverDetails.bestQualiGp?.name,
                      )
                      : null,
              bestRacePoints:
                  bestRace != null
                      ? BestPointsForGp(
                        points: bestRace.seasonGpPointsData.points,
                        playerName: bestRace.player.username,
                        grandPrixName: gpAndDriverDetails.bestRaceGp?.name,
                      )
                      : null,
              bestDriverPoints:
                  bestDriver != null
                      ? BestPointsForDriver(
                        points: bestDriver.seasonDriverPointsData.points,
                        playerName: bestDriver.player.username,
                        driverName: gpAndDriverDetails.bestDriver?.name,
                        driverSurname: gpAndDriverDetails.bestDriver?.surname,
                      )
                      : null,
            ),
          );
        });
  }

  Stream<BestPoints?> _createIndividualBestPoints(int season) {
    return _authRepository.loggedUserId$
        .whereNotNull()
        .switchMap(
          (String loggedUserId) => _getStatsForLoggedUser(loggedUserId, season),
        )
        .switchMap((_PlayerWithStats? data) {
          final String? loggedUserName = data?.player.username;
          final PlayerStats? stats = data?.stats;
          final PlayerStatsPointsForGp? bestGp = stats?.bestGpPoints;
          final PlayerStatsPointsForGp? bestQuali = stats?.bestQualiPoints;
          final PlayerStatsPointsForGp? bestRace = stats?.bestRacePoints;
          final PlayerStatsPointsForDriver? bestDriver =
              stats?.bestDriverPoints;

          return loggedUserName == null || stats == null
              ? Stream.value(null)
              : _getGpAndDriverDetails(
                season,
                bestGp?.seasonGrandPrixId,
                bestQuali?.seasonGrandPrixId,
                bestRace?.seasonGrandPrixId,
                bestDriver?.seasonDriverId,
              ).map(
                (_GpAndDriverDetails gpAndDriverDetails) => BestPoints(
                  bestGpPoints:
                      bestGp != null
                          ? BestPointsForGp(
                            points: bestGp.points,
                            playerName: loggedUserName,
                            grandPrixName: gpAndDriverDetails.bestGp?.name,
                          )
                          : null,
                  bestQualiPoints:
                      bestQuali != null
                          ? BestPointsForGp(
                            points: bestQuali.points,
                            playerName: loggedUserName,
                            grandPrixName: gpAndDriverDetails.bestQualiGp?.name,
                          )
                          : null,
                  bestRacePoints:
                      bestRace != null
                          ? BestPointsForGp(
                            points: bestRace.points,
                            playerName: loggedUserName,
                            grandPrixName: gpAndDriverDetails.bestRaceGp?.name,
                          )
                          : null,
                  bestDriverPoints:
                      bestDriver != null
                          ? BestPointsForDriver(
                            points: bestDriver.points,
                            playerName: loggedUserName,
                            driverName: gpAndDriverDetails.bestDriver?.name,
                            driverSurname:
                                gpAndDriverDetails.bestDriver?.surname,
                          )
                          : null,
                ),
              );
        });
  }

  Stream<List<_PlayerWithStats>> _getStatsForPlayers(
    List<Player> players,
    int season,
  ) {
    final streams = players.map(
      (Player player) => _getStatsForSinglePlayer(player, season),
    );

    return Rx.combineLatest(
      streams,
      (List<_PlayerWithStats?> playerWithStats) =>
          playerWithStats.whereType<_PlayerWithStats>().toList(),
    );
  }

  Stream<_PlayerWithStats?> _getStatsForLoggedUser(
    String loggedUserId,
    int season,
  ) {
    return Rx.combineLatest2(
      _playerRepository.getById(loggedUserId),
      _playerStatsRepository.getByPlayerIdAndSeason(
        playerId: loggedUserId,
        season: season,
      ),
      (Player? player, PlayerStats? stats) =>
          player != null && stats != null
              ? (player: player, stats: stats)
              : null,
    );
  }

  _PlayerWithStatsGpData? _selectBestGp(
    List<_PlayerWithStats> playersWithStats,
  ) {
    final sortedByGpPoints = [...playersWithStats]..sortDescendingByGpPoints();
    final _PlayerWithStats playerWithBestGp = sortedByGpPoints.first;
    final PlayerStatsPointsForGp? bestGpPoints =
        playerWithBestGp.stats.bestGpPoints;

    return bestGpPoints != null
        ? (player: playerWithBestGp.player, seasonGpPointsData: bestGpPoints)
        : null;
  }

  _PlayerWithStatsGpData? _selectBestQuali(
    List<_PlayerWithStats> playerWithStats,
  ) {
    final sortedByQualiPoints = [...playerWithStats]
      ..sortDescendingByQualiPoints();
    final _PlayerWithStats playerWithBestQuali = sortedByQualiPoints.first;
    final PlayerStatsPointsForGp? bestQualiPoints =
        playerWithBestQuali.stats.bestQualiPoints;

    return bestQualiPoints != null
        ? (
          player: playerWithBestQuali.player,
          seasonGpPointsData: bestQualiPoints,
        )
        : null;
  }

  _PlayerWithStatsGpData? _selectBestRace(
    List<_PlayerWithStats> playerWithStats,
  ) {
    final sortedByRacePoints = [...playerWithStats]
      ..sortDescendingByRacePoints();
    final _PlayerWithStats bestRace = sortedByRacePoints.first;
    final PlayerStatsPointsForGp? bestRacePoints =
        bestRace.stats.bestRacePoints;

    return bestRacePoints != null
        ? (player: bestRace.player, seasonGpPointsData: bestRacePoints)
        : null;
  }

  _PlayerWithStatsDriverData? _selectBestDriver(
    List<_PlayerWithStats> playerWithStats,
  ) {
    final sortedByDriverPoints = [...playerWithStats]
      ..sortDescendingByDriverPoints();
    final _PlayerWithStats bestDriver = sortedByDriverPoints.first;
    final PlayerStatsPointsForDriver? bestDriverPoints =
        bestDriver.stats.bestDriverPoints;

    return bestDriverPoints != null
        ? (player: bestDriver.player, seasonDriverPointsData: bestDriverPoints)
        : null;
  }

  Stream<_GpAndDriverDetails> _getGpAndDriverDetails(
    int season,
    String? bestSeasonGpId,
    String? bestQualiSeasonGpId,
    String? bestRaceSeasonGpId,
    String? bestSeasonDriverId,
  ) {
    return Rx.combineLatest4(
      bestSeasonGpId != null
          ? _getGpBasicInfo(season, bestSeasonGpId)
          : Stream.value(null),
      bestQualiSeasonGpId != null
          ? _getGpBasicInfo(season, bestQualiSeasonGpId)
          : Stream.value(null),
      bestRaceSeasonGpId != null
          ? _getGpBasicInfo(season, bestRaceSeasonGpId)
          : Stream.value(null),
      bestSeasonDriverId != null
          ? _getDriverPersonalData(season, bestSeasonDriverId)
          : Stream.value(null),
      (
        GrandPrixBasicInfo? bestGp,
        GrandPrixBasicInfo? bestQualiGp,
        GrandPrixBasicInfo? bestRaceGp,
        DriverPersonalData? bestDriver,
      ) => (
        bestGp: bestGp,
        bestQualiGp: bestQualiGp,
        bestRaceGp: bestRaceGp,
        bestDriver: bestDriver,
      ),
    );
  }

  Stream<_PlayerWithStats?> _getStatsForSinglePlayer(
    Player player,
    int season,
  ) {
    return _playerStatsRepository
        .getByPlayerIdAndSeason(playerId: player.id, season: season)
        .map(
          (PlayerStats? stats) =>
              stats != null ? (player: player, stats: stats) : null,
        );
  }

  Stream<GrandPrixBasicInfo?> _getGpBasicInfo(int season, String seasonGpId) {
    return _seasonGrandPrixRepository
        .getById(season: season, seasonGrandPrixId: seasonGpId)
        .switchMap(
          (SeasonGrandPrix? seasonGrandPrix) =>
              seasonGrandPrix != null
                  ? _grandPrixBasicInfoRepository.getGrandPrixBasicInfoById(
                    seasonGrandPrix.grandPrixId,
                  )
                  : Stream.value(null),
        );
  }

  Stream<DriverPersonalData?> _getDriverPersonalData(
    int season,
    String seasonDriverId,
  ) {
    return _seasonDriverRepository
        .getById(season: season, seasonDriverId: seasonDriverId)
        .switchMap(
          (SeasonDriver? seasonDriver) =>
              seasonDriver != null
                  ? _driverPersonalDataRepository.getDriverPersonalDataById(
                    seasonDriver.driverId,
                  )
                  : Stream.value(null),
        );
  }
}

typedef _PlayerWithStats = ({Player player, PlayerStats stats});

typedef _PlayerWithStatsGpData =
    ({Player player, PlayerStatsPointsForGp seasonGpPointsData});

typedef _PlayerWithStatsDriverData =
    ({Player player, PlayerStatsPointsForDriver seasonDriverPointsData});

typedef _GpAndDriverDetails =
    ({
      GrandPrixBasicInfo? bestGp,
      GrandPrixBasicInfo? bestQualiGp,
      GrandPrixBasicInfo? bestRaceGp,
      DriverPersonalData? bestDriver,
    });

extension _PlayerWithStatsX on List<_PlayerWithStats> {
  void sortDescendingByGpPoints() {
    sort((_PlayerWithStats a, _PlayerWithStats b) {
      final aPoints = a.stats.bestGpPoints?.points ?? 0;
      final bPoints = b.stats.bestGpPoints?.points ?? 0;

      return bPoints.compareTo(aPoints);
    });
  }

  void sortDescendingByQualiPoints() {
    sort((_PlayerWithStats a, _PlayerWithStats b) {
      final aPoints = a.stats.bestQualiPoints?.points ?? 0;
      final bPoints = b.stats.bestQualiPoints?.points ?? 0;

      return bPoints.compareTo(aPoints);
    });
  }

  void sortDescendingByRacePoints() {
    sort((_PlayerWithStats a, _PlayerWithStats b) {
      final aPoints = a.stats.bestRacePoints?.points ?? 0;
      final bPoints = b.stats.bestRacePoints?.points ?? 0;

      return bPoints.compareTo(aPoints);
    });
  }

  void sortDescendingByDriverPoints() {
    sort((_PlayerWithStats a, _PlayerWithStats b) {
      final aPoints = a.stats.bestDriverPoints?.points ?? 0;
      final bPoints = b.stats.bestDriverPoints?.points ?? 0;

      return bPoints.compareTo(aPoints);
    });
  }
}
