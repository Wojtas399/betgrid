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
}
