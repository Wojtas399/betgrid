import 'package:injectable/injectable.dart';

import '../firebase_collection_refs.dart';
import '../model/grand_prix_bet_points_dto.dart';

@injectable
class FirebaseGrandPrixBetPointsService {
  final FirebaseCollectionRefs _firebaseCollectionRefs;

  const FirebaseGrandPrixBetPointsService(this._firebaseCollectionRefs);

  Future<GrandPrixBetPointsDto?>
      fetchGrandPrixBetPointsByPlayerIdAndSeasonGrandPrixId({
    required String playerId,
    required String seasonGrandPrixId,
  }) async {
    final snapshot = await _firebaseCollectionRefs
        .grandPrixesBetPoints(playerId)
        .where('seasonGrandPrixId', isEqualTo: seasonGrandPrixId)
        .limit(1)
        .get();
    return snapshot.docs.isEmpty ? null : snapshot.docs.first.data();
  }
}
