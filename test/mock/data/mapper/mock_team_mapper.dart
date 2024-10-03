import 'package:betgrid/data/firebase/model/driver_dto.dart';
import 'package:betgrid/data/mapper/team_mapper.dart';
import 'package:betgrid/model/driver.dart';
import 'package:mocktail/mocktail.dart';

class MockTeamMapper extends Mock implements TeamMapper {
  MockTeamMapper() {
    registerFallbackValue(TeamDto.mercedes);
  }

  void mockMapFromDto({
    required Team expectedTeam,
  }) {
    when(
      () => mapFromDto(any()),
    ).thenReturn(expectedTeam);
  }
}
