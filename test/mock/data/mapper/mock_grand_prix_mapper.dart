import 'package:betgrid/data/mapper/grand_prix_mapper.dart';
import 'package:betgrid/model/grand_prix.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/grand_prix_creator.dart';

class MockGrandPrixMapper extends Mock implements GrandPrixMapper {
  MockGrandPrixMapper() {
    registerFallbackValue(GrandPrixCreator().createDto());
  }

  void mockMapFromDto({
    required GrandPrix expectedGrandPrix,
  }) {
    when(
      () => mapFromDto(any()),
    ).thenReturn(expectedGrandPrix);
  }
}
