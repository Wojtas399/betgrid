import 'package:betgrid/data/mapper/new_team_mapper.dart';
import 'package:betgrid/model/team.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/team_creator.dart';

class MockNewTeamMapper extends Mock implements NewTeamMapper {
  MockNewTeamMapper() {
    registerFallbackValue(
      const TeamCreator().createDto(),
    );
  }

  void mockMapFromDto({
    required Team expectedTeam,
  }) {
    when(
      () => mapFromDto(any()),
    ).thenReturn(expectedTeam);
  }
}
