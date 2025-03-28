import 'package:equatable/equatable.dart';

class DriverDetails extends Equatable {
  final String seasonDriverId;
  final String name;
  final String surname;
  final int number;
  final String teamName;
  final String teamHexColor;

  const DriverDetails({
    required this.seasonDriverId,
    required this.name,
    required this.surname,
    required this.number,
    required this.teamName,
    required this.teamHexColor,
  });

  @override
  List<Object?> get props => [
    seasonDriverId,
    name,
    surname,
    number,
    teamName,
    teamHexColor,
  ];
}
