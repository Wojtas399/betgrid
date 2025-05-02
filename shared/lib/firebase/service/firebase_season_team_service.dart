import '../firebase_collections_references.dart';
import '../model/season_team_dto.dart';

class FirebaseSeasonTeamService {
  final _firebaseCollectionsReferences = FirebaseCollectionsReferences();

  Future<Iterable<SeasonTeamDto>> fetchAllTeamsFromSeason(int season) async {
    final snapshot =
        await _firebaseCollectionsReferences.seasonTeams(season).get();
    return snapshot.docs.map((doc) => doc.data());
  }

  Future<SeasonTeamDto?> fetchById({
    required String id,
    required int season,
  }) async {
    final snapshot =
        await _firebaseCollectionsReferences.seasonTeams(season).doc(id).get();
    return snapshot.data();
  }

  Future<SeasonTeamDto?> add({
    required int season,
    required String shortName,
    required String fullName,
    required String teamChief,
    required String technicalChief,
    required String chassis,
    required String powerUnit,
    required String baseHexColor,
    required String logoImgName,
    required String carImgName,
  }) async {
    final dto = SeasonTeamDto(
      season: season,
      shortName: shortName,
      fullName: fullName,
      teamChief: teamChief,
      technicalChief: technicalChief,
      chassis: chassis,
      powerUnit: powerUnit,
      baseHexColor: baseHexColor,
      logoImgName: logoImgName,
      carImgName: carImgName,
    );
    final docRef =
        await _firebaseCollectionsReferences.seasonTeams(season).add(dto);
    final snapshot = await docRef.get();
    return snapshot.data();
  }

  Future<void> delete({
    required int season,
    required String seasonTeamId,
  }) async {
    await _firebaseCollectionsReferences
        .seasonTeams(season)
        .doc(seasonTeamId)
        .delete();
  }
}
