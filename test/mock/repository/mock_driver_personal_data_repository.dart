import 'package:betgrid/data/repository/driver_personal_data/driver_personal_data_repository.dart';
import 'package:betgrid/model/driver_personal_data.dart';
import 'package:mocktail/mocktail.dart';

class MockDriverPersonalDataRepository extends Mock
    implements DriverPersonalDataRepository {
  void mockGetDriverPersonalDataById({
    DriverPersonalData? expectedDriverPersonalData,
  }) {
    when(
      () => getDriverPersonalDataById(any()),
    ).thenAnswer((_) => Stream.value(expectedDriverPersonalData));
  }
}
