import 'package:injectable/injectable.dart';

import '../collections.dart';
import '../model/grand_prix_dto/grand_prix_dto.dart';

@injectable
class FirebaseGrandPrixService {
  Future<List<GrandPrixDto>> loadAllGrandPrixes() async {
    final snapshot = await getGrandPrixesRef().get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<GrandPrixDto?> loadGrandPrixById({
    required String grandPrixId,
  }) async {
    final snapshot = await getGrandPrixesRef().doc(grandPrixId).get();
    return snapshot.data();
  }
}
