import 'package:betgrid/model/driver_details.dart';
import 'package:betgrid/use_case/get_details_for_season_driver_use_case.dart';
import 'package:mocktail/mocktail.dart';

import '../../creator/season_driver_creator.dart';

class MockGetDetailsForSeasonDriverUseCase extends Mock
    implements GetDetailsForSeasonDriverUseCase {
  MockGetDetailsForSeasonDriverUseCase() {
    registerFallbackValue(const SeasonDriverCreator().create());
  }

  void mock({DriverDetails? expectedDriverDetails}) {
    when(
      () => call(any()),
    ).thenAnswer((_) => Stream.value(expectedDriverDetails));
  }
}
