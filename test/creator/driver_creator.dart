import 'package:betgrid/model/driver.dart';

class DriverCreator {
  final String id;
  final String name;
  final String surname;
  final int number;
  final DriverCreatorTeam team;

  const DriverCreator({
    this.id = '',
    this.name = '',
    this.surname = '',
    this.number = 0,
    this.team = DriverCreatorTeam.mercedes,
  });

  Driver createEntity() => Driver(
        id: id,
        name: name,
        surname: surname,
        number: number,
        team: _entityTeam,
      );

  Team get _entityTeam => switch (team) {
        DriverCreatorTeam.mercedes => Team.mercedes,
        DriverCreatorTeam.alpine => Team.alpine,
        DriverCreatorTeam.haasF1Team => Team.haasF1Team,
        DriverCreatorTeam.redBullRacing => Team.redBullRacing,
        DriverCreatorTeam.mcLaren => Team.mcLaren,
        DriverCreatorTeam.astonMartin => Team.astonMartin,
        DriverCreatorTeam.rb => Team.rb,
        DriverCreatorTeam.ferrari => Team.ferrari,
        DriverCreatorTeam.kickSauber => Team.kickSauber,
        DriverCreatorTeam.williams => Team.williams,
      };
}

enum DriverCreatorTeam {
  mercedes,
  alpine,
  haasF1Team,
  redBullRacing,
  mcLaren,
  astonMartin,
  rb,
  ferrari,
  kickSauber,
  williams;
}
