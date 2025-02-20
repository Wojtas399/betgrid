import 'package:betgrid_shared/firebase/model/user_stats_points_for_gp_dto.dart';
import 'package:injectable/injectable.dart';

import '../../model/player_stats.dart';

@injectable
class PlayerStatsPointsForGpMapper {
  PlayerStatsPointsForGp mapFromDto(UserStatsPointsForGpDto dto) {
    return PlayerStatsPointsForGp(
      seasonGrandPrixId: dto.seasonGrandPrixId,
      points: dto.points,
    );
  }
}
