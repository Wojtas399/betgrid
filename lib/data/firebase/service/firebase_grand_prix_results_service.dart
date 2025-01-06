import 'package:injectable/injectable.dart';

import '../firebase_collection_refs.dart';
import '../model/grand_prix_results_dto.dart';

@injectable
class FirebaseGrandPrixResultsService {
  final FirebaseCollectionRefs _firebaseCollectionRefs;

  const FirebaseGrandPrixResultsService(this._firebaseCollectionRefs);

  Future<GrandPrixResultsDto?> fetchResultsForSeasonGrandPrix({
    required String seasonGrandPrixId,
  }) async {
    final snapshot = await _firebaseCollectionRefs
        .grandPrixesResults()
        .where('seasonGrandPrixId', isEqualTo: seasonGrandPrixId)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) return null;
    return snapshot.docs.first.data();
  }
}
