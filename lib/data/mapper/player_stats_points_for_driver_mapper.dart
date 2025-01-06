import 'package:injectable/injectable.dart';

import '../../model/player_stats.dart';
import '../firebase/model/player_stats_points_for_driver_dto.dart';

@injectable
class PlayerStatsPointsForDriverMapper {
  PlayerStatsPointsForDriver mapFromDto(PlayerStatsPointsForDriverDto dto) {
    return PlayerStatsPointsForDriver(
      seasonDriverId: dto.seasonDriverId,
      points: dto.points,
    );
  }
}
