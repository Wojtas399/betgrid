import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../collections.dart';
import '../model/grand_prix_bet_dto/grand_prix_bet_dto.dart';

@injectable
class FirebaseGrandPrixBetService {
  Future<List<GrandPrixBetDto>> fetchAllGrandPrixBets({
    required String userId,
  }) async {
    final snapshot = await getGrandPrixBetsRef(userId).get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<GrandPrixBetDto?> fetchGrandPrixBetByGrandPrixId({
    required String playerId,
    required String grandPrixId,
  }) async {
    final snapshot = await getGrandPrixBetsRef(playerId)
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
    String? p1DriverId,
    String? p2DriverId,
    String? p3DriverId,
    String? p10DriverId,
    String? fastestLapDriverId,
    List<String?>? dnfDriverIds,
    bool? willBeSafetyCar,
    bool? willBeRedFlag,
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
    if (dnfDriverIds != null) {
      data = data.copyWith(dnfDriverIds: dnfDriverIds);
    }
    data = data.copyWith(
      p1DriverId: p1DriverId,
      p2DriverId: p2DriverId,
      p3DriverId: p3DriverId,
      p10DriverId: p10DriverId,
      fastestLapDriverId: fastestLapDriverId,
      willBeSafetyCar: willBeSafetyCar,
      willBeRedFlag: willBeRedFlag,
    );
    await docRef.set(data);
    doc = await docRef.get();
    return doc.data();
  }
}
