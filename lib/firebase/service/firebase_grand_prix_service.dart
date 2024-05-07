import 'package:injectable/injectable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../collections.dart';
import '../model/grand_prix_dto/grand_prix_dto.dart';

part 'firebase_grand_prix_service.g.dart';

@injectable
class FirebaseGrandPrixService {
  Future<List<GrandPrixDto>> fetchAllGrandPrixes() async {
    final snapshot = await getGrandPrixesRef().get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<GrandPrixDto?> fetchGrandPrixById({
    required String grandPrixId,
  }) async {
    final snapshot = await getGrandPrixesRef().doc(grandPrixId).get();
    return snapshot.data();
  }
}

@riverpod
FirebaseGrandPrixService firebaseGrandPrixService(
  FirebaseGrandPrixServiceRef ref,
) =>
    FirebaseGrandPrixService();
