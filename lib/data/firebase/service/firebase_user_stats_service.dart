import 'package:injectable/injectable.dart';

import '../firebase_collection_refs.dart';
import '../model/user_stats_dto.dart';

@injectable
class FirebaseUserStatsService {
  final FirebaseCollectionRefs _firebaseCollectionRefs;

  const FirebaseUserStatsService(this._firebaseCollectionRefs);

  Future<UserStatsDto?> fetchUserStatsByUserIdAndSeason({
    required String userId,
    required int season,
  }) async {
    final snapshot = await _firebaseCollectionRefs
        .userStats(
          userId: userId,
          season: season,
        )
        .get();
    return snapshot.data();
  }
}
