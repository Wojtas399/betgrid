import 'package:injectable/injectable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../collections.dart';
import '../model/grand_prix_result_dto/grand_prix_results_dto.dart';

part 'firebase_grand_prix_results_service.g.dart';

class FirebaseGrandPrixResultsService {
  Future<GrandPrixResultsDto?> loadResultsForGrandPrix({
    required String grandPrixId,
  }) async {
    final snapshot = await getGrandPrixResultsRef()
        .where('grandPrixId', isEqualTo: grandPrixId)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) return null;
    return snapshot.docs.first.data();
  }
}

@riverpod
FirebaseGrandPrixResultsService firebaseGrandPrixResultsService(
  FirebaseGrandPrixResultsServiceRef ref,
) =>
    FirebaseGrandPrixResultsService();
