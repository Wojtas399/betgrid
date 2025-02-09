import 'package:betgrid_shared/firebase/model/driver_personal_data_dto.dart';
import 'package:injectable/injectable.dart';

import '../../model/driver_personal_data.dart';

@injectable
class DriverPersonalDataMapper {
  DriverPersonalData mapFromDto(DriverPersonalDataDto driverPersonalDataDto) {
    return DriverPersonalData(
      id: driverPersonalDataDto.id,
      name: driverPersonalDataDto.name,
      surname: driverPersonalDataDto.surname,
    );
  }
}
