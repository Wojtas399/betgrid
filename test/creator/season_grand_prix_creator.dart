import 'package:betgrid/data/firebase/model/season_grand_prix_dto.dart';

class SeasonGrandPrixCreator {
  final String id;
  final int season;
  final String grandPrixId;
  final int roundNumber;
  late final DateTime startDate;
  late final DateTime endDate;

  SeasonGrandPrixCreator({
    this.id = '',
    this.season = 0,
    this.grandPrixId = '',
    this.roundNumber = 0,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    this.startDate = startDate ?? DateTime(2024);
    this.endDate = endDate ?? DateTime(2024);
  }

  SeasonGrandPrixDto createDto() {
    return SeasonGrandPrixDto(
      id: id,
      season: season,
      grandPrixId: grandPrixId,
      roundNumber: roundNumber,
      startDate: startDate,
      endDate: endDate,
    );
  }

  Map<String, Object?> createJson() {
    return {
      'season': season,
      'grandPrixId': grandPrixId,
      'roundNumber': roundNumber,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }
}
