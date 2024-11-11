import 'package:injectable/injectable.dart';

import '../collections.dart';
import '../model/grand_prix_bet_points_dto.dart';

@injectable
class FirebaseGrandPrixBetPointsService {
  final FirebaseCollections _firebaseCollections;

  const FirebaseGrandPrixBetPointsService(this._firebaseCollections);

  Future<GrandPrixBetPointsDto?>
      fetchGrandPrixBetPointsByPlayerIdAndSeasonGrandPrixId({
    required String playerId,
    required String seasonGrandPrixId,
  }) async {
    final snapshot = await _firebaseCollections
        .grandPrixesBetPoints(playerId)
        .where('seasonGrandPrixId', isEqualTo: seasonGrandPrixId)
        .limit(1)
        .get();
    return snapshot.docs.isEmpty ? null : snapshot.docs.first.data();
  }
}
