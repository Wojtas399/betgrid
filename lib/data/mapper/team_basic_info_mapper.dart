import 'package:injectable/injectable.dart';

import '../../model/team_basic_info.dart';
import '../firebase/model/team_basic_info_dto.dart';

@injectable
class TeamBasicInfoMapper {
  TeamBasicInfo mapFromDto(TeamBasicInfoDto teamBasicInfoDto) {
    return TeamBasicInfo(
      id: teamBasicInfoDto.id,
      name: teamBasicInfoDto.name,
      hexColor: teamBasicInfoDto.hexColor,
    );
  }
}
