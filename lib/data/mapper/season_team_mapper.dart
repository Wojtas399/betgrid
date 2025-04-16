import 'package:betgrid_shared/firebase/model/season_team_dto.dart';
import 'package:injectable/injectable.dart';

import '../../model/season_team.dart';

@injectable
class SeasonTeamMapper {
  SeasonTeam mapFromDto(
    SeasonTeamDto dto,
    String logoImgUrl,
    String carImgUrl,
  ) {
    return SeasonTeam(
      id: dto.id,
      season: dto.season,
      shortName: dto.shortName,
      fullName: dto.fullName,
      teamChief: dto.teamChief,
      technicalChief: dto.technicalChief,
      chassis: dto.chassis,
      powerUnit: dto.powerUnit,
      baseHexColor: dto.baseHexColor,
      logoImgUrl: logoImgUrl,
      carImgUrl: carImgUrl,
    );
  }
}
