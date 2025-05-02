import '../firebase_collections_references.dart';
import '../model/season_grand_prix_dto.dart';

class FirebaseSeasonGrandPrixService {
  final _firebaseCollectionsReferences = FirebaseCollectionsReferences();

  Future<Iterable<SeasonGrandPrixDto>> fetchAllFromSeason(int season) async {
    final snapshot =
        await _firebaseCollectionsReferences.seasonGrandPrixes(season).get();
    return snapshot.docs.map((doc) => doc.data());
  }

  Future<SeasonGrandPrixDto?> fetchById({
    required int season,
    required String seasonGrandPrixId,
  }) async {
    final snapshot = await _firebaseCollectionsReferences
        .seasonGrandPrixes(season)
        .doc(seasonGrandPrixId)
        .get();
    return snapshot.data();
  }

  Future<SeasonGrandPrixDto?> add({
    required int season,
    required String grandPrixId,
    required int roundNumber,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final dto = SeasonGrandPrixDto(
      season: season,
      grandPrixId: grandPrixId,
      roundNumber: roundNumber,
      startDate: startDate,
      endDate: endDate,
    );
    final docRef =
        await _firebaseCollectionsReferences.seasonGrandPrixes(season).add(dto);
    final snapshot = await docRef.get();
    return snapshot.data();
  }

  Future<void> delete({
    required int season,
    required String seasonGrandPrixId,
  }) async {
    await _firebaseCollectionsReferences
        .seasonGrandPrixes(season)
        .doc(seasonGrandPrixId)
        .delete();
  }
}
