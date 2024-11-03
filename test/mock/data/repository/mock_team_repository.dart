import 'package:betgrid/data/repository/team/team_repository.dart';
import 'package:betgrid/model/team.dart';
import 'package:mocktail/mocktail.dart';

class MockTeamRepository extends Mock implements TeamRepository {
  void mockGetTeamById({
    Team? expectedTeam,
  }) {
    when(
      () => getTeamById(any()),
    ).thenAnswer((_) => Stream.value(expectedTeam));
  }
}
