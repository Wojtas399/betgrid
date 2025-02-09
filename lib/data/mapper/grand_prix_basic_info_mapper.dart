import 'package:betgrid_shared/firebase/model/grand_prix_basic_info_dto.dart';
import 'package:injectable/injectable.dart';

import '../../model/grand_prix_basic_info.dart';

@injectable
class GrandPrixBasicInfoMapper {
  GrandPrixBasicInfo mapFromDto(GrandPrixBasicInfoDto grandPrixBasicInfoDto) {
    return GrandPrixBasicInfo(
      id: grandPrixBasicInfoDto.id,
      name: grandPrixBasicInfoDto.name,
      countryAlpha2Code: grandPrixBasicInfoDto.countryAlpha2Code,
    );
  }
}
