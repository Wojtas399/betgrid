import '../model/grand_prix_basic_info.dart';
import 'firebase/model/grand_prix_basic_info_dto.dart';

class GrandPrixBasicInfoMapper {
  GrandPrixBasicInfo mapFromDto(GrandPrixBasicInfoDto grandPrixBasicInfoDto) {
    return GrandPrixBasicInfo(
      id: grandPrixBasicInfoDto.id,
      name: grandPrixBasicInfoDto.name,
      countryAlpha2Code: grandPrixBasicInfoDto.countryAlpha2Code,
    );
  }
}
