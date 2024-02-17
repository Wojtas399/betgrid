import 'package:betgrid/data/mapper/driver_mapper.dart';
import 'package:betgrid/firebase/model/driver_dto/driver_dto.dart';
import 'package:betgrid/model/driver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'mapDriverFromDto, '
    'should map DriverDto model to Driver model',
    () {
      const String id = 'd1';
      const String name = 'Robert';
      const String surname = 'Kubica';
      const int number = 1;
      const Team team = Team.ferrari;
      const TeamDto teamDto = TeamDto.ferrari;
      const driverDto = DriverDto(
        id: id,
        name: name,
        surname: surname,
        number: number,
        team: teamDto,
      );
      const expectedDriver = Driver(
        id: id,
        name: name,
        surname: surname,
        number: number,
        team: team,
      );

      final Driver driver = mapDriverFromDto(driverDto);

      expect(driver, expectedDriver);
    },
  );
}
