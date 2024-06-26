import 'entity.dart';

class GrandPrix extends Entity {
  final int roundNumber;
  final String name;
  final String countryAlpha2Code;
  final DateTime startDate;
  final DateTime endDate;

  const GrandPrix({
    required super.id,
    required this.roundNumber,
    required this.name,
    required this.countryAlpha2Code,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [
        id,
        roundNumber,
        name,
        countryAlpha2Code,
        startDate,
        endDate,
      ];
}
