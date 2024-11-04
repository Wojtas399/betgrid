import 'package:betgrid/data/mapper/driver_personal_data_mapper.dart';
import 'package:betgrid/model/driver_personal_data.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../creator/driver_personal_data_creator.dart';

void main() {
  final mapper = DriverPersonalDataMapper();

  test(
    'mapFromDto, '
    'should map DriverPersonalDataDto model to DriverPersonalData model',
    () {
      const String id = 'd1';
      const String name = 'Robert';
      const String surname = 'Kubica';
      const driverPersonalDataCreator = DriverPersonalDataCreator(
        id: id,
        name: name,
        surname: surname,
      );
      final driverPersonalDataDto = driverPersonalDataCreator.createDto();
      final expectedDriverPersonalData =
          driverPersonalDataCreator.createEntity();

      final DriverPersonalData driverPersonalData =
          mapper.mapFromDto(driverPersonalDataDto);

      expect(driverPersonalData, expectedDriverPersonalData);
    },
  );
}
