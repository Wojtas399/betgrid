import 'package:injectable/injectable.dart';

import '../../model/user_stats.dart';
import '../firebase/model/user_stats_points_for_gp_dto.dart';

@injectable
class UserStatsPointsForGpMapper {
  UserStatsPointsForGp mapFromDto(UserStatsPointsForGpDto dto) {
    return UserStatsPointsForGp(
      seasonGrandPrixId: dto.seasonGrandPrixId,
      points: dto.points,
    );
  }
}
