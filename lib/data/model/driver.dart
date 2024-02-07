import 'package:equatable/equatable.dart';

class Driver extends Equatable {
  final String id;
  final String name;
  final String surname;
  final Team team;

  const Driver({
    required this.id,
    required this.name,
    required this.surname,
    required this.team,
  });

  @override
  List<Object?> get props => [id, name, surname, team];
}

enum Team {
  mercedes,
  alpine,
  haasF1Team,
  redBullRacing,
  mcLaren,
  astonMartin,
  rb,
  ferrari,
  kickSauber,
  williams,
}
