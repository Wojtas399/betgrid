import 'package:betgrid_shared/firebase/model/team_basic_info_dto.dart';
import 'package:injectable/injectable.dart';

import '../../model/team_basic_info.dart';

@injectable
class TeamBasicInfoMapper {
  TeamBasicInfo mapFromDto(TeamBasicInfoDto dto) {
    return TeamBasicInfo(id: dto.id, name: dto.name, hexColor: dto.hexColor);
  }
}
