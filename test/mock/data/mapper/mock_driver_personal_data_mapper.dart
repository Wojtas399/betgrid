import 'package:betgrid/data/mapper/driver_personal_data_mapper.dart';
import 'package:betgrid/model/driver_personal_data.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/driver_personal_data_creator.dart';

class MockDriverPersonalDataMapper extends Mock
    implements DriverPersonalDataMapper {
  MockDriverPersonalDataMapper() {
    registerFallbackValue(
      const DriverPersonalDataCreator().createDto(),
    );
  }

  void mockMapFromDto({
    required DriverPersonalData expectedDriverPersonalData,
  }) {
    when(
      () => mapFromDto(any()),
    ).thenReturn(expectedDriverPersonalData);
  }
}
