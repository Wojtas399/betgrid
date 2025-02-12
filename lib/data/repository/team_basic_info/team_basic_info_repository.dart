import '../../../model/team_basic_info.dart';

abstract interface class TeamBasicInfoRepository {
  Stream<TeamBasicInfo?> getById(String id);
}
