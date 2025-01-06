import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../firebase_collection_refs.dart';
import '../model/grand_prix_bet_dto.dart';

@injectable
class FirebaseGrandPrixBetService {
  final FirebaseCollectionRefs _firebaseCollectionRefs;

  const FirebaseGrandPrixBetService(this._firebaseCollectionRefs);

  Future<GrandPrixBetDto?> fetchGrandPrixBetBySeasonGrandPrixId({
    required String playerId,
    required String seasonGrandPrixId,
  }) async {
    final snapshot = await _firebaseCollectionRefs
        .grandPrixesBets(playerId)
        .where('seasonGrandPrixId', isEqualTo: seasonGrandPrixId)
        .get();
    if (snapshot.docs.isEmpty) return null;
    return snapshot.docs.first.data();
  }

  Future<GrandPrixBetDto?> addGrandPrixBet({
    required String userId,
    required String seasonGrandPrixId,
    List<String?> qualiStandingsBySeasonDriverIds = const [],
    String? p1SeasonDriverId,
    String? p2SeasonDriverId,
    String? p3SeasonDriverId,
    String? p10SeasonDriverId,
    String? fastestLapSeasonDriverId,
    List<String> dnfSeasonDriverIds = const [],
    bool? willBeSafetyCar,
    bool? willBeRedFlag,
  }) async {
    final grandPrixBetDto = GrandPrixBetDto(
      seasonGrandPrixId: seasonGrandPrixId,
      qualiStandingsBySeasonDriverIds: qualiStandingsBySeasonDriverIds,
      p1SeasonDriverId: p1SeasonDriverId,
      p2SeasonDriverId: p2SeasonDriverId,
      p3SeasonDriverId: p3SeasonDriverId,
      p10SeasonDriverId: p10SeasonDriverId,
      fastestLapSeasonDriverId: fastestLapSeasonDriverId,
      dnfSeasonDriverIds: dnfSeasonDriverIds,
      willBeSafetyCar: willBeSafetyCar,
      willBeRedFlag: willBeRedFlag,
    );
    final docRef = await _firebaseCollectionRefs
        .grandPrixesBets(userId)
        .add(grandPrixBetDto);
    final snapshot = await docRef.get();
    return snapshot.data();
  }

  Future<GrandPrixBetDto?> updateGrandPrixBet({
    required String userId,
    required String grandPrixBetId,
    List<String?>? qualiStandingsBySeasonDriverIds,
    String? p1SeasonDriverId,
    String? p2SeasonDriverId,
    String? p3SeasonDriverId,
    String? p10SeasonDriverId,
    String? fastestLapSeasonDriverId,
    List<String>? dnfSeasonDriverIds,
    bool? willBeSafetyCar,
    bool? willBeRedFlag,
  }) async {
    final docRef =
        _firebaseCollectionRefs.grandPrixesBets(userId).doc(grandPrixBetId);
    DocumentSnapshot<GrandPrixBetDto> doc = await docRef.get();
    GrandPrixBetDto? data = doc.data();
    if (data == null) {
      throw '[FirebaseGrandPrixBetService] Cannot find doc data';
    }
    if (qualiStandingsBySeasonDriverIds != null) {
      data = data.copyWith(
        qualiStandingsBySeasonDriverIds: qualiStandingsBySeasonDriverIds,
      );
    }
    if (dnfSeasonDriverIds != null) {
      data = data.copyWith(dnfSeasonDriverIds: dnfSeasonDriverIds);
    }
    data = data.copyWith(
      p1SeasonDriverId: p1SeasonDriverId,
      p2SeasonDriverId: p2SeasonDriverId,
      p3SeasonDriverId: p3SeasonDriverId,
      p10SeasonDriverId: p10SeasonDriverId,
      fastestLapSeasonDriverId: fastestLapSeasonDriverId,
      willBeSafetyCar: willBeSafetyCar,
      willBeRedFlag: willBeRedFlag,
    );
    await docRef.set(data);
    doc = await docRef.get();
    return doc.data();
  }
}
