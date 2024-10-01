import 'package:betgrid/data/firebase/model/grand_prix_dto/grand_prix_dto.dart';
import 'package:betgrid/model/grand_prix.dart';

class GrandPrixCreator {
  final String id;
  final int season;
  final int roundNumber;
  final String name;
  final String countryAlpha2Code;
  late final DateTime startDate;
  late final DateTime endDate;

  GrandPrixCreator({
    this.id = '',
    this.season = 0,
    this.roundNumber = 0,
    this.name = '',
    this.countryAlpha2Code = '',
    DateTime? startDate,
    DateTime? endDate,
  }) {
    this.startDate = startDate ?? DateTime(2024);
    this.endDate = endDate ?? DateTime(2024, 1, 2);
  }

  GrandPrix createEntity() => GrandPrix(
        id: id,
        season: season,
        roundNumber: roundNumber,
        name: name,
        countryAlpha2Code: countryAlpha2Code,
        startDate: startDate,
        endDate: endDate,
      );

  GrandPrixDto createDto() => GrandPrixDto(
        id: id,
        season: season,
        roundNumber: roundNumber,
        name: name,
        countryAlpha2Code: countryAlpha2Code,
        startDate: startDate,
        endDate: endDate,
      );
}
