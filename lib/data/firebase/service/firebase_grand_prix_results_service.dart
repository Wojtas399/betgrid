import 'package:injectable/injectable.dart';

import '../collections.dart';
import '../model/grand_prix_result_dto/grand_prix_results_dto.dart';

@injectable
class FirebaseGrandPrixResultsService {
  Future<GrandPrixResultsDto?> fetchResultsForGrandPrix({
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
