import 'package:injectable/injectable.dart';

import '../../model/user_stats.dart';
import '../firebase/model/user_stats_dto.dart';
import 'user_stats_points_for_driver_mapper.dart';
import 'user_stats_points_for_gp_mapper.dart';

@injectable
class UserStatsMapper {
  final UserStatsPointsForGpMapper _userStatsPointsForGpMapper;
  final UserStatsPointsForDriverMapper _userStatsPointsForDriverMapper;

  const UserStatsMapper(
    this._userStatsPointsForGpMapper,
    this._userStatsPointsForDriverMapper,
  );

  UserStats mapFromDto(UserStatsDto dto) {
    return UserStats(
      id: dto.id,
      userId: dto.userId,
      season: dto.season,
      bestGpPoints: _userStatsPointsForGpMapper.mapFromDto(dto.bestGpPoints),
      bestQualiPoints: _userStatsPointsForGpMapper.mapFromDto(
        dto.bestQualiPoints,
      ),
      bestRacePoints: _userStatsPointsForGpMapper.mapFromDto(
        dto.bestRacePoints,
      ),
      pointsForDrivers: dto.pointsForDrivers
          .map(_userStatsPointsForDriverMapper.mapFromDto)
          .toList(),
    );
  }
}
