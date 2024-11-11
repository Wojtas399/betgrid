import 'package:betgrid/model/grand_prix_v2.dart';

class GrandPrixV2Creator {
  final String seasonGrandPrixId;
  final String name;
  final String countryAlpha2Code;
  final int roundNumber;
  late final DateTime startDate;
  late final DateTime endDate;

  GrandPrixV2Creator({
    this.seasonGrandPrixId = '',
    this.name = '',
    this.countryAlpha2Code = '',
    this.roundNumber = 0,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    this.startDate = startDate ?? DateTime(2024);
    this.endDate = endDate ?? DateTime(2024, 1, 2);
  }

  GrandPrixV2 create() {
    return GrandPrixV2(
      seasonGrandPrixId: seasonGrandPrixId,
      name: name,
      countryAlpha2Code: countryAlpha2Code,
      roundNumber: roundNumber,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
