import 'package:injectable/injectable.dart';

import '../firebase_collection_refs.dart';
import '../model/season_grand_prix_dto.dart';

@injectable
class FirebaseSeasonGrandPrixService {
  final FirebaseCollectionRefs _firebaseCollectionRefs;

  const FirebaseSeasonGrandPrixService(this._firebaseCollectionRefs);

  Future<List<SeasonGrandPrixDto>> fetchAllSeasonGrandPrixesFromSeason(
    int season,
  ) async {
    final snapshot = await _firebaseCollectionRefs
        .seasonGrandPrixes()
        .where('season', isEqualTo: season)
        .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<SeasonGrandPrixDto?> fetchSeasonGrandPrixById(String id) async {
    final snapshot =
        await _firebaseCollectionRefs.seasonGrandPrixes().doc(id).get();
    return snapshot.data();
  }
}
