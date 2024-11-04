import 'package:betgrid/model/driver.dart';
import 'package:betgrid/use_case/get_all_drivers_from_season_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAllDriversFromSeasonUseCase extends Mock
    implements GetAllDriversFromSeasonUseCase {
  void mock({
    required List<Driver> expectedAllDrivers,
  }) {
    when(
      () => call(any()),
    ).thenAnswer((_) => Stream.value(expectedAllDrivers));
  }
}
