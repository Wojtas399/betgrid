import 'entity.dart';

class Driver extends Entity {
  final String name;
  final String surname;
  final int number;
  final Team team;
  final int season;

  const Driver({
    required super.id,
    required this.name,
    required this.surname,
    required this.number,
    required this.team,
    required this.season,
  });

  @override
  List<Object?> get props => [id, name, surname, number, team, season];
}

enum Team {
  mercedes(0xFF86d1c0),
  alpine(0xFF4891cc),
  haasF1Team(0xFFb7babd),
  redBullRacing(0xFF4570c0),
  mcLaren(0xFFe6853b),
  astonMartin(0xFF4e8a76),
  rb(0xFF698ea7),
  ferrari(0xFFe53740),
  kickSauber(0xFF69e444),
  williams(0xFF62bbd9);

  final int hexColor;

  const Team(this.hexColor);
}
