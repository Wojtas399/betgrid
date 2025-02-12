import 'package:betgrid/data/repository/team_basic_info/team_basic_info_repository.dart';
import 'package:betgrid/model/team_basic_info.dart';
import 'package:mocktail/mocktail.dart';

class MockTeamBasicInfoRepository extends Mock
    implements TeamBasicInfoRepository {
  void mockGetById({
    TeamBasicInfo? expectedTeamBasicInfo,
  }) {
    when(
      () => getById(any()),
    ).thenAnswer((_) => Stream.value(expectedTeamBasicInfo));
  }
}
