import 'package:betgrid/data/firebase/collections.dart';
import 'package:injectable/injectable.dart';

import '../model/season_driver_dto.dart';

@injectable
class FirebaseSeasonDriverService {
  final FirebaseCollections _firebaseCollections;

  const FirebaseSeasonDriverService(this._firebaseCollections);

  Future<Iterable<SeasonDriverDto>> fetchAllDriversFromSeason(
    int season,
  ) async {
    final snapshot = await _firebaseCollections
        .seasonDrivers()
        .where('season', isEqualTo: season)
        .get();
    return snapshot.docs.map((doc) => doc.data());
  }
}
