import 'package:injectable/injectable.dart';

import '../collections.dart';
import '../model/grand_prix_results_dto.dart';

@injectable
class FirebaseGrandPrixResultsService {
  final FirebaseCollections _firebaseCollections;

  const FirebaseGrandPrixResultsService(this._firebaseCollections);

  Future<GrandPrixResultsDto?> fetchResultsForSeasonGrandPrix({
    required String seasonGrandPrixId,
  }) async {
    final snapshot = await _firebaseCollections
        .grandPrixesResults()
        .where('seasonGrandPrixId', isEqualTo: seasonGrandPrixId)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) return null;
    return snapshot.docs.first.data();
  }
}
