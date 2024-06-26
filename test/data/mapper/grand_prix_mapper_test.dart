import 'package:betgrid/data/mapper/grand_prix_mapper.dart';
import 'package:betgrid/firebase/model/grand_prix_dto/grand_prix_dto.dart';
import 'package:betgrid/model/grand_prix.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'mapGrandPrixFromDto, '
    'should map GrandPrixDto model to GrandPrix model',
    () {
      const String id = 'gp1';
      const int roundNumber = 3;
      const String name = 'Monaco GP';
      const String countryAlpha2Code = 'PL';
      final DateTime startDate = DateTime(2024, 1, 1);
      final DateTime endDate = DateTime(2024, 1, 3);
      final gpDto = GrandPrixDto(
        id: id,
        roundNumber: roundNumber,
        name: name,
        countryAlpha2Code: countryAlpha2Code,
        startDate: startDate,
        endDate: endDate,
      );
      final gp = GrandPrix(
        id: id,
        roundNumber: roundNumber,
        name: name,
        countryAlpha2Code: countryAlpha2Code,
        startDate: startDate,
        endDate: endDate,
      );

      final GrandPrix mappedGp = mapGrandPrixFromDto(gpDto);

      expect(mappedGp, gp);
    },
  );
}
