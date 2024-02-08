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
      const String name = 'Monaco GP';
      final DateTime startDate = DateTime(2024, 1, 1);
      final DateTime endDate = DateTime(2024, 1, 3);
      final gpDto = GrandPrixDto(
        id: id,
        name: name,
        startDate: startDate,
        endDate: endDate,
      );
      final gp = GrandPrix(
        id: id,
        name: name,
        startDate: startDate,
        endDate: endDate,
      );

      final GrandPrix mappedGp = mapGrandPrixFromDto(gpDto);

      expect(mappedGp, gp);
    },
  );
}
