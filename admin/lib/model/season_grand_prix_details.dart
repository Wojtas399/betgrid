import 'package:equatable/equatable.dart';

class SeasonGrandPrixDetails extends Equatable {
  final String seasonGrandPrixId;
  final String grandPrixId;
  final String grandPrixName;
  final String countryAlpha2Code;
  final int roundNumber;
  final DateTime startDate;
  final DateTime endDate;

  const SeasonGrandPrixDetails({
    required this.seasonGrandPrixId,
    required this.grandPrixId,
    required this.grandPrixName,
    required this.countryAlpha2Code,
    required this.roundNumber,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [
    seasonGrandPrixId,
    grandPrixId,
    grandPrixName,
    countryAlpha2Code,
    roundNumber,
    startDate,
    endDate,
  ];
}
