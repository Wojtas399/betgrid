import '../firebase_collections_references.dart';
import '../model/season_driver_dto.dart';

class FirebaseSeasonDriverService {
  final _firebaseCollectionsReferences = FirebaseCollectionsReferences();

  Future<List<SeasonDriverDto>> fetchAllFromSeason(int season) async {
    final snapshot =
        await _firebaseCollectionsReferences.seasonDrivers(season).get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<SeasonDriverDto?> fetchById({
    required int season,
    required String seasonDriverId,
  }) async {
    final snapshot = await _firebaseCollectionsReferences
        .seasonDrivers(season)
        .doc(seasonDriverId)
        .get();
    return snapshot.data();
  }

  Future<List<SeasonDriverDto>> fetchBySeasonTeamId({
    required int season,
    required String seasonTeamId,
  }) async {
    final snapshot = await _firebaseCollectionsReferences
        .seasonDrivers(season)
        .where(SeasonDriverFields.seasonTeamId, isEqualTo: seasonTeamId)
        .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<SeasonDriverDto?> add({
    required int season,
    required String driverId,
    required int driverNumber,
    required String seasonTeamId,
  }) async {
    final dto = SeasonDriverDto(
      season: season,
      driverId: driverId,
      driverNumber: driverNumber,
      seasonTeamId: seasonTeamId,
    );
    final docRef =
        await _firebaseCollectionsReferences.seasonDrivers(season).add(dto);
    final snapshot = await docRef.get();
    return snapshot.data();
  }

  Future<void> delete({
    required int season,
    required String seasonDriverId,
  }) async {
    await _firebaseCollectionsReferences
        .seasonDrivers(season)
        .doc(seasonDriverId)
        .delete();
  }
}
