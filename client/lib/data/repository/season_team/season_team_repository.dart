import '../../../model/season_team.dart';

abstract interface class SeasonTeamRepository {
  Stream<SeasonTeam?> getById({required String id, required int season});

  Stream<List<SeasonTeam>> getAllFromSeason(int season);
}
