import 'package:betgrid/model/driver_details.dart';
import 'package:betgrid/use_case/get_details_of_all_drivers_from_season_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockGetDetailsOfAllDriversFromSeasonUseCase extends Mock
    implements GetDetailsOfAllDriversFromSeasonUseCase {
  void mock({
    required List<DriverDetails> expectedDetailsOfAllDriversFromSeason,
  }) {
    when(
      () => call(any()),
    ).thenAnswer((_) => Stream.value(expectedDetailsOfAllDriversFromSeason));
  }
}
