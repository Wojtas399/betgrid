import 'package:betgrid/data/firebase/model/team_basic_info_dto.dart';
import 'package:betgrid/data/firebase/service/firebase_team_basic_info_service.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseTeamBasicInfoService extends Mock
    implements FirebaseTeamBasicInfoService {
  void mockFetchTeamBasicInfoById({
    TeamBasicInfoDto? expectedTeamBasicInfoDto,
  }) {
    when(
      () => fetchTeamBasicInfoById(any()),
    ).thenAnswer((_) => Future.value(expectedTeamBasicInfoDto));
  }
}
