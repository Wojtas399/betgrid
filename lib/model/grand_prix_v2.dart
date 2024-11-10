import 'package:equatable/equatable.dart';

class GrandPrixV2 extends Equatable {
  final String seasonGrandPrixId;
  final String name;
  final String countryAlpha2Code;
  final int roundNumber;
  final DateTime startDate;
  final DateTime endDate;

  const GrandPrixV2({
    required this.seasonGrandPrixId,
    required this.name,
    required this.countryAlpha2Code,
    required this.roundNumber,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [
        seasonGrandPrixId,
        name,
        countryAlpha2Code,
        roundNumber,
        startDate,
        endDate,
      ];
}
