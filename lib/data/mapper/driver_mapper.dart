import '../../model/driver.dart';
import '../firebase/model/driver_dto/driver_dto.dart';
import 'team_mapper.dart';

Driver mapDriverFromDto(DriverDto driverDto) => Driver(
      id: driverDto.id,
      name: driverDto.name,
      surname: driverDto.surname,
      number: driverDto.number,
      team: mapTeamFromDto(driverDto.team),
    );
