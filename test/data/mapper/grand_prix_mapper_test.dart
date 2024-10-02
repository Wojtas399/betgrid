import 'package:betgrid/data/firebase/model/grand_prix_dto/grand_prix_dto.dart';
import 'package:betgrid/data/mapper/grand_prix_mapper.dart';
import 'package:betgrid/model/grand_prix.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final mapper = GrandPrixMapper();

  test(
    'mapFromDto, '
    'should map GrandPrixDto model to GrandPrix model',
    () {
      const String id = 'gp1';
      const int season = 2024;
      const int roundNumber = 3;
      const String name = 'Monaco GP';
      const String countryAlpha2Code = 'PL';
      final DateTime startDate = DateTime(2024, 1, 1);
      final DateTime endDate = DateTime(2024, 1, 3);
      final gpDto = GrandPrixDto(
        id: id,
        season: season,
        roundNumber: roundNumber,
        name: name,
        countryAlpha2Code: countryAlpha2Code,
        startDate: startDate,
        endDate: endDate,
      );
      final gp = GrandPrix(
        id: id,
        season: season,
        roundNumber: roundNumber,
        name: name,
        countryAlpha2Code: countryAlpha2Code,
        startDate: startDate,
        endDate: endDate,
      );

      final GrandPrix mappedGp = mapper.mapFromDto(gpDto);

      expect(mappedGp, gp);
    },
  );
}
