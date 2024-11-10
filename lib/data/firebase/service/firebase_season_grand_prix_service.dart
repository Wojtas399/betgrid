import 'package:injectable/injectable.dart';

import '../collections.dart';
import '../model/season_grand_prix_dto.dart';

@injectable
class FirebaseSeasonGrandPrixService {
  final FirebaseCollections _firebaseCollections;

  const FirebaseSeasonGrandPrixService(this._firebaseCollections);

  Future<List<SeasonGrandPrixDto>> fetchAllSeasonGrandPrixesFromSeason(
    int season,
  ) async {
    final snapshot = await _firebaseCollections
        .seasonGrandPrixes()
        .where('season', isEqualTo: season)
        .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
