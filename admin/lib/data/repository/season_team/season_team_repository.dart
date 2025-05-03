import '../../../model/season_team.dart';

abstract interface class SeasonTeamRepository {
  Stream<SeasonTeam?> getById({required String id, required int season});

  Stream<List<SeasonTeam>> getAllFromSeason(int season);

  Future<void> add({
    required int season,
    required String shortName,
    required String fullName,
    required String teamChief,
    required String technicalChief,
    required String chassis,
    required String powerUnit,
    required String baseHexColor,
    required String logoImgPath,
    required String carImgPath,
  });

  Future<void> delete({required int season, required String seasonTeamId});
}
