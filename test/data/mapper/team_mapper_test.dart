import 'package:betgrid/data/firebase/model/driver_dto.dart';
import 'package:betgrid/data/mapper/team_mapper.dart';
import 'package:betgrid/model/driver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final mapper = TeamMapper();

  test(
    'mapFromDto, '
    'TeamDto.mercedes should be mapped to Team.mercedes',
    () {
      const TeamDto teamDto = TeamDto.mercedes;
      const Team expectedTeam = Team.mercedes;

      final Team team = mapper.mapFromDto(teamDto);

      expect(team, expectedTeam);
    },
  );

  test(
    'mapFromDto, '
    'TeamDto.alpine should be mapped to Team.alpine',
    () {
      const TeamDto teamDto = TeamDto.alpine;
      const Team expectedTeam = Team.alpine;

      final Team team = mapper.mapFromDto(teamDto);

      expect(team, expectedTeam);
    },
  );

  test(
    'mapFromDto, '
    'TeamDto.haasF1Team should be mapped to Team.haasF1Team',
    () {
      const TeamDto teamDto = TeamDto.haasF1Team;
      const Team expectedTeam = Team.haasF1Team;

      final Team team = mapper.mapFromDto(teamDto);

      expect(team, expectedTeam);
    },
  );

  test(
    'mapFromDto, '
    'TeamDto.redBullRacing should be mapped to Team.redBullRacing',
    () {
      const TeamDto teamDto = TeamDto.redBullRacing;
      const Team expectedTeam = Team.redBullRacing;

      final Team team = mapper.mapFromDto(teamDto);

      expect(team, expectedTeam);
    },
  );

  test(
    'mapFromDto, '
    'TeamDto.redBullRacing should be mapped to Team.redBullRacing',
    () {
      const TeamDto teamDto = TeamDto.redBullRacing;
      const Team expectedTeam = Team.redBullRacing;

      final Team team = mapper.mapFromDto(teamDto);

      expect(team, expectedTeam);
    },
  );

  test(
    'mapFromDto, '
    'TeamDto.mcLaren should be mapped to Team.mcLaren',
    () {
      const TeamDto teamDto = TeamDto.mcLaren;
      const Team expectedTeam = Team.mcLaren;

      final Team team = mapper.mapFromDto(teamDto);

      expect(team, expectedTeam);
    },
  );

  test(
    'mapFromDto, '
    'TeamDto.astonMartin should be mapped to Team.astonMartin',
    () {
      const TeamDto teamDto = TeamDto.astonMartin;
      const Team expectedTeam = Team.astonMartin;

      final Team team = mapper.mapFromDto(teamDto);

      expect(team, expectedTeam);
    },
  );

  test(
    'mapFromDto, '
    'TeamDto.rb should be mapped to Team.rb',
    () {
      const TeamDto teamDto = TeamDto.rb;
      const Team expectedTeam = Team.rb;

      final Team team = mapper.mapFromDto(teamDto);

      expect(team, expectedTeam);
    },
  );

  test(
    'mapFromDto, '
    'TeamDto.ferrari should be mapped to Team.ferrari',
    () {
      const TeamDto teamDto = TeamDto.ferrari;
      const Team expectedTeam = Team.ferrari;

      final Team team = mapper.mapFromDto(teamDto);

      expect(team, expectedTeam);
    },
  );

  test(
    'mapFromDto, '
    'TeamDto.kickSauber should be mapped to Team.kickSauber',
    () {
      const TeamDto teamDto = TeamDto.kickSauber;
      const Team expectedTeam = Team.kickSauber;

      final Team team = mapper.mapFromDto(teamDto);

      expect(team, expectedTeam);
    },
  );

  test(
    'mapFromDto, '
    'TeamDto.williams should be mapped to Team.williams',
    () {
      const TeamDto teamDto = TeamDto.williams;
      const Team expectedTeam = Team.williams;

      final Team team = mapper.mapFromDto(teamDto);

      expect(team, expectedTeam);
    },
  );
}
