import 'package:injectable/injectable.dart';

import '../../model/team.dart';
import '../firebase/model/team_dto.dart';

@injectable
class TeamMapper {
  Team mapFromDto(TeamDto teamDto) {
    return Team(
      id: teamDto.id,
      name: teamDto.name,
      hexColor: teamDto.hexColor,
    );
  }
}
