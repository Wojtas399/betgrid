import 'package:betgrid/data/mapper/grand_prix_bet_points_mapper.dart';
import 'package:betgrid/model/grand_prix_bet_points.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/grand_prix_bet_points_creator.dart';

class MockGrandPrixBetPointsMapper extends Mock
    implements GrandPrixBetPointsMapper {
  MockGrandPrixBetPointsMapper() {
    registerFallbackValue(GrandPrixBetPointsCreator().createDto());
  }

  void mockMapFromDto({
    required GrandPrixBetPoints expectedGrandPrixBetPoints,
  }) {
    when(
      () => mapFromDto(any()),
    ).thenReturn(expectedGrandPrixBetPoints);
  }
}
