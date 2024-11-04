import 'package:betgrid/model/driver.dart';
import 'package:betgrid/use_case/get_driver_based_on_season_driver_use_case.dart';
import 'package:mocktail/mocktail.dart';

import '../../creator/season_driver_creator.dart';

class MockGetDriverBasedOnSeasonDriverUseCase extends Mock
    implements GetDriverBasedOnSeasonDriverUseCase {
  MockGetDriverBasedOnSeasonDriverUseCase() {
    registerFallbackValue(
      const SeasonDriverCreator().createEntity(),
    );
  }

  void mock({
    Driver? expectedDriver,
  }) {
    when(
      () => call(any()),
    ).thenAnswer((_) => Stream.value(expectedDriver));
  }
}
