import 'package:betgrid/data/firebase/model/team_dto.dart';
import 'package:betgrid/data/firebase/service/firebase_team_service.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseTeamService extends Mock implements FirebaseTeamService {
  void mockFetchTeamById({
    TeamDto? expectedTeamDto,
  }) {
    when(
      () => fetchTeamById(any()),
    ).thenAnswer((_) => Future.value(expectedTeamDto));
  }
}
