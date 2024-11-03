import 'package:betgrid/data/mapper/season_driver_mapper.dart';
import 'package:betgrid/model/season_driver.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/season_driver_creator.dart';

class MockSeasonDriverMapper extends Mock implements SeasonDriverMapper {
  MockSeasonDriverMapper() {
    registerFallbackValue(const SeasonDriverCreator().createDto());
  }

  void mockMapFromDto({
    required SeasonDriver expectedSeasonDriver,
  }) {
    when(
      () => mapFromDto(any()),
    ).thenReturn(expectedSeasonDriver);
  }
}
