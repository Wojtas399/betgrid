import 'package:injectable/injectable.dart';

import '../collections.dart';
import '../model/grand_prix_results_dto.dart';

@injectable
class FirebaseGrandPrixResultsService {
  final FirebaseCollections _firebaseCollections;

  const FirebaseGrandPrixResultsService(this._firebaseCollections);

  Future<GrandPrixResultsDto?> fetchResultsForGrandPrix({
    required String grandPrixId,
  }) async {
    final snapshot = await _firebaseCollections
        .grandPrixesResults()
        .where('grandPrixId', isEqualTo: grandPrixId)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) return null;
    return snapshot.docs.first.data();
  }
}
