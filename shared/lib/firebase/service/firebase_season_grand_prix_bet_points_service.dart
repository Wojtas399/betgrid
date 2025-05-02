import '../firebase_collections_references.dart';
import '../model/season_grand_prix_bet_points_dto.dart';

class FirebaseSeasonGrandPrixBetPointsService {
  final _firebaseCollectionsReferences = FirebaseCollectionsReferences();

  Future<SeasonGrandPrixBetPointsDto?> fetchBySeasonGrandPrixId({
    required String userId,
    required int season,
    required String seasonGrandPrixId,
  }) async {
    final snapshot = await _firebaseCollectionsReferences
        .seasonGrandPrixesBetPoints(
          userId: userId,
          season: season,
        )
        .where(
          SeasonGrandPrixBetPointsFields.seasonGrandPrixId,
          isEqualTo: seasonGrandPrixId,
        )
        .limit(1)
        .get();
    return snapshot.docs.isEmpty ? null : snapshot.docs.first.data();
  }
}
