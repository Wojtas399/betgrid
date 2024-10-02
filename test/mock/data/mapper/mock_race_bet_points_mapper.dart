import 'package:betgrid/data/mapper/race_bet_points_mapper.dart';
import 'package:betgrid/model/grand_prix_bet_points.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/race_bet_points_creator.dart';

class MockRaceBetPointsMapper extends Mock implements RaceBetPointsMapper {
  MockRaceBetPointsMapper() {
    registerFallbackValue(RaceBetPointsCreator().createDto());
  }

  void mockMapFromDto({
    required RaceBetPoints expectedRaceBetPoints,
  }) {
    when(
      () => mapFromDto(any()),
    ).thenReturn(expectedRaceBetPoints);
  }
}
