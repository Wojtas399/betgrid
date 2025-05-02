import '../firebase_collections_references.dart';
import '../model/user_stats_dto.dart';

class FirebaseUserStatsService {
  final _firebaseCollectionsReferences = FirebaseCollectionsReferences();

  Future<UserStatsDto?> fetchForUser({
    required String userId,
    required int season,
  }) async {
    final snapshot = await _firebaseCollectionsReferences
        .userStats(
          userId: userId,
          season: season,
        )
        .get();
    return snapshot.data();
  }

  Future<UserStatsDto?> add({
    required UserStatsDto userStatsDto,
  }) async {
    final docRef = _firebaseCollectionsReferences.userStats(
      userId: userStatsDto.userId,
      season: userStatsDto.season,
    );
    await docRef.set(userStatsDto);
    final snapshot = await docRef.get();
    return snapshot.data();
  }
}
