import '../../../model/team.dart';

abstract interface class TeamRepository {
  Stream<Team?> getTeamById(String id);
}
