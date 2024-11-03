import 'package:betgrid/data/mapper/new_team_mapper.dart';
import 'package:betgrid/model/team.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../creator/team_creator.dart';

void main() {
  final mapper = NewTeamMapper();

  test(
    'mapFromDto, '
    'should map TeamDto model to Team model',
    () {
      const String id = 't1';
      const String name = 'mercedes';
      const String hexColor = '#FFFFFF';
      const teamCreator = TeamCreator(
        id: id,
        name: name,
        hexColor: hexColor,
      );
      final teamDto = teamCreator.createDto();
      final expectedTeam = teamCreator.createEntity();

      final Team team = mapper.mapFromDto(teamDto);

      expect(team, expectedTeam);
    },
  );
}
