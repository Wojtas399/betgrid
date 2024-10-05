import 'package:injectable/injectable.dart';

import '../collections.dart';
import '../model/grand_prix_dto.dart';

@injectable
class FirebaseGrandPrixService {
  final FirebaseCollections _firebaseCollections;

  const FirebaseGrandPrixService(this._firebaseCollections);

  Future<List<GrandPrixDto>> fetchAllGrandPrixesFromSeason(int season) async {
    final snapshot = await _firebaseCollections
        .grandPrixes()
        .where('season', isEqualTo: season)
        .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<GrandPrixDto?> fetchGrandPrixById({
    required String grandPrixId,
  }) async {
    final snapshot =
        await _firebaseCollections.grandPrixes().doc(grandPrixId).get();
    return snapshot.data();
  }
}
