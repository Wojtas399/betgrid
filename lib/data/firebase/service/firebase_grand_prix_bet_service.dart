import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../collections.dart';
import '../model/grand_prix_bet_dto.dart';

@injectable
class FirebaseGrandPrixBetService {
  final FirebaseCollections _firebaseCollections;

  const FirebaseGrandPrixBetService(this._firebaseCollections);

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
      qualiStandingsBySeasonDriverIds: qualiStandingsByDriverIds,
      p1SeasonDriverId: p1DriverId,
      p2SeasonDriverId: p2DriverId,
      p3SeasonDriverId: p3DriverId,
      p10SeasonDriverId: p10DriverId,
      fastestLapSeasonDriverId: fastestLapDriverId,
      dnfSeasonDriverIds: dnfDriverIds,
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
        qualiStandingsBySeasonDriverIds: qualiStandingsByDriverIds,
      );
    }
    if (dnfDriverIds != null) {
      data = data.copyWith(dnfSeasonDriverIds: dnfDriverIds);
    }
    data = data.copyWith(
      p1SeasonDriverId: p1DriverId,
      p2SeasonDriverId: p2DriverId,
      p3SeasonDriverId: p3DriverId,
      p10SeasonDriverId: p10DriverId,
      fastestLapSeasonDriverId: fastestLapDriverId,
      willBeSafetyCar: willBeSafetyCar,
      willBeRedFlag: willBeRedFlag,
    );
    await docRef.set(data);
    doc = await docRef.get();
    return doc.data();
  }
}
