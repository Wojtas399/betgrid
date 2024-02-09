import 'entity.dart';

class Driver extends Entity {
  final String name;
  final String surname;
  final Team team;

  const Driver({
    required super.id,
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
