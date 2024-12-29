import 'package:betgrid/model/driver_details.dart';
import 'package:betgrid/use_case/get_details_for_all_drivers_from_season_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockGetDetailsForAllDriversFromSeasonUseCase extends Mock
    implements GetDetailsForAllDriversFromSeasonUseCase {
  void mock({
    required List<DriverDetails> expectedDetailsOfAllDriversFromSeason,
  }) {
    when(
      () => call(any()),
    ).thenAnswer((_) => Stream.value(expectedDetailsOfAllDriversFromSeason));
  }
}
