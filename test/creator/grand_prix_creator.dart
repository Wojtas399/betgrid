import 'package:betgrid/model/grand_prix.dart';

GrandPrix createGrandPrix({
  String id = '',
  String name = '',
  String countryAlpha2Code = '',
  DateTime? startDate,
  DateTime? endDate,
}) =>
    GrandPrix(
      id: id,
      name: name,
      countryAlpha2Code: countryAlpha2Code,
      startDate: startDate ?? DateTime(2024),
      endDate: endDate ?? DateTime(2024, 1, 2),
    );
