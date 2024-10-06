import 'package:betgrid/data/mapper/driver_mapper.dart';
import 'package:betgrid/model/driver.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/driver_creator.dart';

class MockDriverMapper extends Mock implements DriverMapper {
  MockDriverMapper() {
    registerFallbackValue(
      const DriverCreator().createDto(),
    );
  }

  void mockMapFromDto({
    required Driver expectedDriver,
  }) {
    when(
      () => mapFromDto(any()),
    ).thenReturn(expectedDriver);
  }
}
