import 'package:betgrid/data/mapper/season_grand_prix_mapper.dart';
import 'package:betgrid/model/season_grand_prix.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../creator/season_grand_prix_creator.dart';

void main() {
  final mapper = SeasonGrandPrixMapper();

  test(
    'mapFromDto, '
    'should map SeasonGrandPrixDto model to SeasonGrandPrix model',
    () {
      const String id = 'sd1';
      const int season = 2024;
      const String grandPrixId = 'gp1';
      const int roundNumber = 11;
      final DateTime startDate = DateTime(2024);
      final DateTime endDate = DateTime(2024, 1, 2);
      final seasonGrandPrixCreator = SeasonGrandPrixCreator(
        id: id,
        season: season,
        grandPrixId: grandPrixId,
        roundNumber: roundNumber,
        startDate: startDate,
        endDate: endDate,
      );
      final seasonGrandPrixDto = seasonGrandPrixCreator.createDto();
      final expectedSeasonGrandPrix = seasonGrandPrixCreator.createEntity();

      final SeasonGrandPrix seasonGrandPrix =
          mapper.mapFromDto(seasonGrandPrixDto);

      expect(seasonGrandPrix, expectedSeasonGrandPrix);
    },
  );
}
