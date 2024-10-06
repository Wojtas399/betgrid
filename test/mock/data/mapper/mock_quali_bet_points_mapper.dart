import 'package:betgrid/data/mapper/quali_bet_points_mapper.dart';
import 'package:betgrid/model/grand_prix_bet_points.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/quali_bet_points_creator.dart';

class MockQualiBetPointsMapper extends Mock implements QualiBetPointsMapper {
  MockQualiBetPointsMapper() {
    registerFallbackValue(
      const QualiBetPointsCreator().createDto(),
    );
  }

  void mockMapFromDto({
    required QualiBetPoints expectedQualiBetPoints,
  }) {
    when(
      () => mapFromDto(any()),
    ).thenReturn(expectedQualiBetPoints);
  }
}
