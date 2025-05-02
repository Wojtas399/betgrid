import 'package:betgrid_shared/firebase/model/season_team_dto.dart';
import 'package:injectable/injectable.dart';

import '../../model/season_team.dart';

@injectable
class SeasonTeamMapper {
  SeasonTeam mapFromDto(SeasonTeamDto dto) {
    return SeasonTeam(id: dto.id, season: dto.season, teamId: dto.teamId);
  }
}
