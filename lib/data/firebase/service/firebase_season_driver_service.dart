import 'package:injectable/injectable.dart';

import '../firebase_collection_refs.dart';
import '../model/season_driver_dto.dart';

@injectable
class FirebaseSeasonDriverService {
  final FirebaseCollectionRefs _firebaseCollectionRefs;

  const FirebaseSeasonDriverService(this._firebaseCollectionRefs);

  Future<Iterable<SeasonDriverDto>> fetchAllSeasonDriversFromSeason(
    int season,
  ) async {
    final snapshot = await _firebaseCollectionRefs
        .seasonDrivers()
        .where('season', isEqualTo: season)
        .get();
    return snapshot.docs.map((doc) => doc.data());
  }

  Future<SeasonDriverDto?> fetchSeasonDriverById(String id) async {
    final snapshot =
        await _firebaseCollectionRefs.seasonDrivers().doc(id).get();
    return snapshot.data();
  }
}
