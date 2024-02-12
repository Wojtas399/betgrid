import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../collections.dart';
import '../model/grand_prix_bet/grand_prix_bet_dto.dart';

@injectable
class FirebaseGrandPrixBetService {
  Future<List<GrandPrixBetDto>> loadAllGrandPrixBets({
    required String userId,
  }) async {
    final snapshot = await getGrandPrixBetsRef(userId).get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<GrandPrixBetDto?> loadGrandPrixBetByGrandPrixId({
    required String userId,
    required String grandPrixId,
  }) async {
    final snapshot = await getGrandPrixBetsRef(userId)
        .where('grandPrixId', isEqualTo: grandPrixId)
        .get();
    if (snapshot.docs.isEmpty) return null;
    return snapshot.docs.first.data();
  }

  Future<void> addGrandPrixBet({
    required String userId,
    required GrandPrixBetDto grandPrixBetDto,
  }) async {
    await getGrandPrixBetsRef(userId).add(grandPrixBetDto);
  }

  Future<GrandPrixBetDto?> updateGrandPrixBet({
    required String userId,
    required String grandPrixBetId,
    List<String?>? qualiStandingsByDriverIds,
  }) async {
    final docRef = getGrandPrixBetsRef(userId).doc(grandPrixBetId);
    DocumentSnapshot<GrandPrixBetDto> doc = await docRef.get();
    GrandPrixBetDto? data = doc.data();
    if (data == null) {
      throw '[FirebaseGrandPrixBetService] Cannot find doc data';
    }
    if (qualiStandingsByDriverIds != null) {
      data = data.copyWith(
        qualiStandingsByDriverIds: qualiStandingsByDriverIds,
      );
    }
    await docRef.set(data);
    doc = await docRef.get();
    return doc.data();
  }
}
