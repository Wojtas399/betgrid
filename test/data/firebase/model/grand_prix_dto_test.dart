import 'package:betgrid/firebase/model/grand_prix_dto/grand_prix_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String id = 'gp1';
  const String name = 'Test Grand Prix';
  final DateTime startDate = DateTime(2024);
  final DateTime endDate = DateTime(2024, 1, 3);
  final GrandPrixDto classModel = GrandPrixDto(
    id: id,
    name: name,
    startDate: startDate,
    endDate: endDate,
  );
  final Map<String, Object?> jsonModel = {
    'id': id,
    'name': name,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
  };

  test(
    'fromJson, '
    'should map json model to class model',
    () {
      final GrandPrixDto mappedModel = GrandPrixDto.fromJson(jsonModel);

      expect(mappedModel, classModel);
    },
  );

  test(
    'toJson, '
    'should map class model to json model',
    () {
      final Map<String, Object?> mappedModel = classModel.toJson();

      expect(mappedModel, jsonModel);
    },
  );
}
