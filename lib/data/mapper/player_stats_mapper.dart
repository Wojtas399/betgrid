import 'package:injectable/injectable.dart';

import '../../model/player_stats.dart';
import '../firebase/model/player_stats_dto.dart';
import 'player_stats_points_for_driver_mapper.dart';
import 'player_stats_points_for_gp_mapper.dart';

@injectable
class PlayerStatsMapper {
  final PlayerStatsPointsForGpMapper _playerStatsPointsForGpMapper;
  final PlayerStatsPointsForDriverMapper _playerStatsPointsForDriverMapper;

  const PlayerStatsMapper(
    this._playerStatsPointsForGpMapper,
    this._playerStatsPointsForDriverMapper,
  );

  PlayerStats mapFromDto(PlayerStatsDto dto) {
    return PlayerStats(
      id: dto.id,
      playerId: dto.playerId,
      season: dto.season,
      bestGpPoints: _playerStatsPointsForGpMapper.mapFromDto(dto.bestGpPoints),
      bestQualiPoints: _playerStatsPointsForGpMapper.mapFromDto(
        dto.bestQualiPoints,
      ),
      bestRacePoints: _playerStatsPointsForGpMapper.mapFromDto(
        dto.bestRacePoints,
      ),
      pointsForDrivers: dto.pointsForDrivers
          .map(_playerStatsPointsForDriverMapper.mapFromDto)
          .toList(),
    );
  }
}
