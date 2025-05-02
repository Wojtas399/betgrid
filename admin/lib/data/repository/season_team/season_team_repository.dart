import '../../../model/season_team.dart';

abstract interface class SeasonTeamRepository {
  Stream<List<SeasonTeam>> getAllFromSeason(int season);

  Future<void> add({required int season, required String teamId});

  Future<void> delete({required int season, required String seasonTeamId});
}
