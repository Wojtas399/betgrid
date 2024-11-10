import 'package:injectable/injectable.dart';

import '../collections.dart';
import '../model/season_driver_dto.dart';

@injectable
class FirebaseSeasonDriverService {
  final FirebaseCollections _firebaseCollections;

  const FirebaseSeasonDriverService(this._firebaseCollections);

  Future<Iterable<SeasonDriverDto>> fetchAllSeasonDriversFromSeason(
    int season,
  ) async {
    final snapshot = await _firebaseCollections
        .seasonDrivers()
        .where('season', isEqualTo: season)
        .get();
    return snapshot.docs.map((doc) => doc.data());
  }

  Future<SeasonDriverDto?> fetchSeasonDriverById(String id) async {
    final snapshot = await _firebaseCollections.seasonDrivers().doc(id).get();
    return snapshot.data();
  }
}
