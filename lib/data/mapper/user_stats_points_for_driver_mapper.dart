import 'package:injectable/injectable.dart';

import '../../model/user_stats.dart';
import '../firebase/model/user_stats_points_for_driver_dto.dart';

@injectable
class UserStatsPointsForDriverMapper {
  UserStatsPointsForDriver mapFromDto(UserStatsPointsForDriverDto dto) {
    return UserStatsPointsForDriver(
      seasonDriverId: dto.seasonDriverId,
      points: dto.points,
    );
  }
}
