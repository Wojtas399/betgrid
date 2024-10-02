import 'package:injectable/injectable.dart';

import '../../model/driver.dart';
import '../firebase/model/driver_dto/driver_dto.dart';
import 'team_mapper.dart';

@injectable
class DriverMapper {
  final TeamMapper _teamMapper;

  const DriverMapper(this._teamMapper);

  Driver mapFromDto(DriverDto driverDto) => Driver(
        id: driverDto.id,
        name: driverDto.name,
        surname: driverDto.surname,
        number: driverDto.number,
        team: _teamMapper.mapFromDto(driverDto.team),
      );
}
