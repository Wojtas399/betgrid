import '../../../model/team_basic_info.dart';

abstract interface class TeamBasicInfoRepository {
  Stream<TeamBasicInfo?> getTeamBasicInfoById(String id);
}
