import 'package:betgrid/data/firebase/model/grand_prix_dto/grand_prix_dto.dart';

GrandPrixDto createGrandPrixDto({
  String id = '',
  int roundNumber = 1,
  String name = '',
  String countryAlpha2Code = '',
  DateTime? startDate,
  DateTime? endDate,
}) =>
    GrandPrixDto(
      id: id,
      roundNumber: roundNumber,
      name: name,
      countryAlpha2Code: countryAlpha2Code,
      startDate: startDate ?? DateTime(2024),
      endDate: endDate ?? DateTime(2024, 1, 2),
    );
