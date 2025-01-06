import 'package:injectable/injectable.dart';

import '../firebase_collection_refs.dart';
import '../model/player_stats_dto.dart';

@injectable
class FirebasePlayerStatsService {
  final FirebaseCollectionRefs _firebaseCollectionRefs;

  const FirebasePlayerStatsService(this._firebaseCollectionRefs);

  Future<PlayerStatsDto?> fetchPlayerStatsByPlayerIdAndSeason({
    required String playerId,
    required int season,
  }) async {
    final snapshot = await _firebaseCollectionRefs
        .playerStats(
          playerId: playerId,
          season: season,
        )
        .get();
    return snapshot.data();
  }
}
