import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../collections.dart';
import '../model/grand_prix_bet_dto.dart';

@injectable
class FirebaseGrandPrixBetService {
  final FirebaseCollections _firebaseCollections;

  const FirebaseGrandPrixBetService(this._firebaseCollections);

  Future<List<GrandPrixBetDto>> fetchAllGrandPrixBets({
    required String userId,
  }) async {
    final snapshot = await _firebaseCollections.grandPrixesBets(userId).get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<GrandPrixBetDto?> fetchGrandPrixBetByGrandPrixId({
    required String playerId,
    required String grandPrixId,
  }) async {
    final snapshot = await _firebaseCollections
        .grandPrixesBets(playerId)
        .where('grandPrixId', isEqualTo: grandPrixId)
        .get();
    if (snapshot.docs.isEmpty) return null;
    return snapshot.docs.first.data();
  }

  Future<GrandPrixBetDto?> addGrandPrixBet({
    required String userId,
    required String grandPrixId,
    List<String?> qualiStandingsByDriverIds = const [],
    String? p1DriverId,
    String? p2DriverId,
    String? p3DriverId,
    String? p10DriverId,
    String? fastestLapDriverId,
    List<String> dnfDriverIds = const [],
    bool? willBeSafetyCar,
    bool? willBeRedFlag,
  }) async {
    final grandPrixBetDto = GrandPrixBetDto(
      grandPrixId: grandPrixId,
      qualiStandingsByDriverIds: qualiStandingsByDriverIds,
      p1DriverId: p1DriverId,
      p2DriverId: p2DriverId,
      p3DriverId: p3DriverId,
      p10DriverId: p10DriverId,
      fastestLapDriverId: fastestLapDriverId,
      dnfDriverIds: dnfDriverIds,
      willBeSafetyCar: willBeSafetyCar,
      willBeRedFlag: willBeRedFlag,
    );
    final docRef =
        await _firebaseCollections.grandPrixesBets(userId).add(grandPrixBetDto);
    final snapshot = await docRef.get();
    return snapshot.data();
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
    List<String>? dnfDriverIds,
    bool? willBeSafetyCar,
    bool? willBeRedFlag,
  }) async {
    final docRef =
        _firebaseCollections.grandPrixesBets(userId).doc(grandPrixBetId);
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
