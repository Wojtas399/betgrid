import 'package:betgrid/data/mapper/grand_prix_results_mapper.dart';
import 'package:betgrid/model/grand_prix_results.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/grand_prix_results_creator.dart';

class MockGrandPrixResultsMapper extends Mock
    implements GrandPrixResultsMapper {
  MockGrandPrixResultsMapper() {
    registerFallbackValue(GrandPrixResultsCreator().createDto());
  }

  void mockMapFromDto({
    required GrandPrixResults expectedGrandPrixResults,
  }) {
    when(
      () => mapFromDto(any()),
    ).thenReturn(expectedGrandPrixResults);
  }
}
