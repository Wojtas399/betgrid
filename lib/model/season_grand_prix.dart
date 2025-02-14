import 'entity.dart';

class SeasonGrandPrix extends Entity {
  final int season;
  final String grandPrixId;
  final int roundNumber;
  final DateTime startDate;
  final DateTime endDate;

  const SeasonGrandPrix({
    required super.id,
    required this.season,
    required this.grandPrixId,
    required this.roundNumber,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [
    id,
    season,
    grandPrixId,
    roundNumber,
    startDate,
    endDate,
  ];
}
