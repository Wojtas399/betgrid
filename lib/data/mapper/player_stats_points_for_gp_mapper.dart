import 'package:injectable/injectable.dart';

import '../../model/player_stats.dart';
import '../firebase/model/player_stats_points_for_gp_dto.dart';

@injectable
class PlayerStatsPointsForGpMapper {
  PlayerStatsPointsForGp mapFromDto(PlayerStatsPointsForGpDto dto) {
    return PlayerStatsPointsForGp(
      seasonGrandPrixId: dto.seasonGrandPrixId,
      points: dto.points,
    );
  }
}
