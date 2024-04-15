import 'package:betgrid/model/grand_prix.dart';

GrandPrix createGrandPrix({
  String id = '',
  int roundNumber = 1,
  String name = '',
  String countryAlpha2Code = '',
  DateTime? startDate,
  DateTime? endDate,
}) =>
    GrandPrix(
      id: id,
      roundNumber: roundNumber,
      name: name,
      countryAlpha2Code: countryAlpha2Code,
      startDate: startDate ?? DateTime(2024),
      endDate: endDate ?? DateTime(2024, 1, 2),
    );
