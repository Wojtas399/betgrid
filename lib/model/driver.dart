import 'entity.dart';

class Driver extends Entity {
  final String name;
  final String surname;
  final int number;
  final Team team;

  const Driver({
    required super.id,
    required this.name,
    required this.surname,
    required this.number,
    required this.team,
  });

  @override
  List<Object?> get props => [id, name, surname, number, team];
}

enum Team {
  mercedes('86d1c0'),
  alpine('4891cc'),
  haasF1Team('b7babd'),
  redBullRacing('4570c0'),
  mcLaren('e6853b'),
  astonMartin('4e8a76'),
  rb('698ea7'),
  ferrari('e53740'),
  kickSauber('69e444'),
  williams('62bbd9');

  final String hexColor;

  const Team(this.hexColor);
}
