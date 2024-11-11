import 'package:betgrid/data/mapper/season_grand_prix_mapper.dart';
import 'package:betgrid/model/season_grand_prix.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/season_grand_prix_creator.dart';

class MockSeasonGrandPrixMapper extends Mock implements SeasonGrandPrixMapper {
  MockSeasonGrandPrixMapper() {
    registerFallbackValue(
      SeasonGrandPrixCreator().createDto(),
    );
  }

  void mockMapFromDto({
    required SeasonGrandPrix expectedSeasonGrandPrix,
  }) {
    when(
      () => mapFromDto(any()),
    ).thenReturn(expectedSeasonGrandPrix);
  }
}
