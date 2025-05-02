import 'package:betgrid_shared/firebase/model/user_stats_points_for_driver_dto.dart';
import 'package:injectable/injectable.dart';

import '../../model/player_stats.dart';

@injectable
class PlayerStatsPointsForDriverMapper {
  PlayerStatsPointsForDriver mapFromDto(UserStatsPointsForDriverDto dto) {
    return PlayerStatsPointsForDriver(
      seasonDriverId: dto.seasonDriverId,
      points: dto.points,
    );
  }
}
