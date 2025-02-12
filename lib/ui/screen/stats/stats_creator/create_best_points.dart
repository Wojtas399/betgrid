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
        .switchMap(
      (List<_PlayerWithStats>? playerWithStats) {
        if (playerWithStats == null || playerWithStats.isEmpty) {
          return Stream.value(null);
        }
        final bestGp = _selectBestGp(playerWithStats);
        final bestQuali = _selectBestQuali(playerWithStats);
        final bestRace = _selectBestRace(playerWithStats);
        final bestDriver = _selectBestDriver(playerWithStats);
        return _getStatsGpAndDriverDetails(
          season,
          bestGp.stats.bestGpPoints.seasonGrandPrixId,
          bestQuali.stats.bestQualiPoints.seasonGrandPrixId,
          bestRace.stats.bestRacePoints.seasonGrandPrixId,
          bestDriver.stats.bestDriverPoints.seasonDriverId,
        ).map(
          (statsGpAndDriverDetails) => BestPoints(
            bestGpPoints: BestPointsForGp(
              points: bestGp.stats.bestGpPoints.points,
              playerName: bestGp.player.username,
              grandPrixName: statsGpAndDriverDetails.bestGp?.name,
            ),
            bestQualiPoints: BestPointsForGp(
              points: bestQuali.stats.bestQualiPoints.points,
              playerName: bestQuali.player.username,
              grandPrixName: statsGpAndDriverDetails.bestQualiGp?.name,
            ),
            bestRacePoints: BestPointsForGp(
              points: bestRace.stats.bestRacePoints.points,
              playerName: bestRace.player.username,
              grandPrixName: statsGpAndDriverDetails.bestRaceGp?.name,
            ),
            bestDriverPoints: BestPointsForDriver(
              points: bestDriver.stats.bestDriverPoints.points,
              playerName: bestDriver.player.username,
              driverName: statsGpAndDriverDetails.bestDriver?.name,
              driverSurname: statsGpAndDriverDetails.bestDriver?.surname,
            ),
          ),
        );
      },
    );
  }

  Stream<BestPoints?> _createIndividualBestPoints(int season) {
    return _authRepository.loggedUserId$
        .whereNotNull()
        .switchMap(
          (String loggedUserId) => _getStatsForLoggedUser(loggedUserId, season),
        )
        .switchMap(
      (_PlayerWithStats? data) {
        final String? loggedUserName = data?.player.username;
        final PlayerStats? stats = data?.stats;
        return loggedUserName == null || stats == null
            ? Stream.value(null)
            : _getStatsGpAndDriverDetails(
                season,
                stats.bestGpPoints.seasonGrandPrixId,
                stats.bestQualiPoints.seasonGrandPrixId,
                stats.bestRacePoints.seasonGrandPrixId,
                stats.bestDriverPoints.seasonDriverId,
              ).map(
                (statsGpAndDriverDetails) => BestPoints(
                  bestGpPoints: BestPointsForGp(
                    points: stats.bestGpPoints.points,
                    playerName: loggedUserName,
                    grandPrixName: statsGpAndDriverDetails.bestGp?.name,
                  ),
                  bestQualiPoints: BestPointsForGp(
                    points: stats.bestQualiPoints.points,
                    playerName: loggedUserName,
                    grandPrixName: statsGpAndDriverDetails.bestQualiGp?.name,
                  ),
                  bestRacePoints: BestPointsForGp(
                    points: stats.bestRacePoints.points,
                    playerName: loggedUserName,
                    grandPrixName: statsGpAndDriverDetails.bestRaceGp?.name,
                  ),
                  bestDriverPoints: BestPointsForDriver(
                    points: stats.bestDriverPoints.points,
                    playerName: loggedUserName,
                    driverName: statsGpAndDriverDetails.bestDriver?.name,
                    driverSurname: statsGpAndDriverDetails.bestDriver?.surname,
                  ),
                ),
              );
      },
    );
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
      _playerStatsRepository.getStatsByPlayerIdAndSeason(
        playerId: loggedUserId,
        season: season,
      ),
      (Player? player, PlayerStats? stats) => player != null && stats != null
          ? (player: player, stats: stats)
          : null,
    );
  }

  _PlayerWithStats _selectBestGp(List<_PlayerWithStats> playerWithStats) {
    final sortedByGpPoints = [...playerWithStats];
    sortedByGpPoints.sortDescendingByGpPoints();
    return sortedByGpPoints.first;
  }

  _PlayerWithStats _selectBestQuali(List<_PlayerWithStats> playerWithStats) {
    final sortedByQualiPoints = [...playerWithStats];
    sortedByQualiPoints.sortDescendingByQualiPoints();
    return sortedByQualiPoints.first;
  }

  _PlayerWithStats _selectBestRace(List<_PlayerWithStats> playerWithStats) {
    final sortedByRacePoints = [...playerWithStats];
    sortedByRacePoints.sortDescendingByRacePoints();
    return sortedByRacePoints.first;
  }

  _PlayerWithStats _selectBestDriver(List<_PlayerWithStats> playerWithStats) {
    final sortedByDriverPoints = [...playerWithStats];
    sortedByDriverPoints.sortDescendingByDriverPoints();
    return sortedByDriverPoints.first;
  }

  Stream<_StatsGpAndDriverDetails> _getStatsGpAndDriverDetails(
    int season,
    String bestSeasonGpId,
    String bestQualiSeasonGpId,
    String bestRaceSeasonGpId,
    String bestSeasonDriverId,
  ) {
    return Rx.combineLatest4(
      _getGpBasicInfo(season, bestSeasonGpId),
      _getGpBasicInfo(season, bestQualiSeasonGpId),
      _getGpBasicInfo(season, bestRaceSeasonGpId),
      _getDriverPersonalData(season, bestSeasonDriverId),
      (
        GrandPrixBasicInfo? bestGp,
        GrandPrixBasicInfo? bestQualiGp,
        GrandPrixBasicInfo? bestRaceGp,
        DriverPersonalData? bestDriver,
      ) =>
          (
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
        .getStatsByPlayerIdAndSeason(playerId: player.id, season: season)
        .map(
          (PlayerStats? stats) => stats != null
              ? (
                  player: player,
                  stats: stats,
                )
              : null,
        );
  }

  Stream<GrandPrixBasicInfo?> _getGpBasicInfo(int season, String seasonGpId) {
    return _seasonGrandPrixRepository
        .getById(
          season: season,
          seasonGrandPrixId: seasonGpId,
        )
        .switchMap(
          (SeasonGrandPrix? seasonGrandPrix) => seasonGrandPrix != null
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
        .getById(
          season: season,
          seasonDriverId: seasonDriverId,
        )
        .switchMap(
          (SeasonDriver? seasonDriver) => seasonDriver != null
              ? _driverPersonalDataRepository.getDriverPersonalDataById(
                  seasonDriver.driverId,
                )
              : Stream.value(null),
        );
  }
}

typedef _PlayerWithStats = ({Player player, PlayerStats stats});

typedef _StatsGpAndDriverDetails = ({
  GrandPrixBasicInfo? bestGp,
  GrandPrixBasicInfo? bestQualiGp,
  GrandPrixBasicInfo? bestRaceGp,
  DriverPersonalData? bestDriver,
});

extension _PlayerWithStatsX on List<_PlayerWithStats> {
  void sortDescendingByGpPoints() {
    sort(
      (a, b) => b.stats.bestGpPoints.points.compareTo(
        a.stats.bestGpPoints.points,
      ),
    );
  }

  void sortDescendingByQualiPoints() {
    sort(
      (a, b) => b.stats.bestQualiPoints.points.compareTo(
        a.stats.bestQualiPoints.points,
      ),
    );
  }

  void sortDescendingByRacePoints() {
    sort(
      (a, b) => b.stats.bestRacePoints.points.compareTo(
        a.stats.bestRacePoints.points,
      ),
    );
  }

  void sortDescendingByDriverPoints() {
    sort(
      (a, b) => b.stats.bestDriverPoints.points.compareTo(
        a.stats.bestDriverPoints.points,
      ),
    );
  }
}
