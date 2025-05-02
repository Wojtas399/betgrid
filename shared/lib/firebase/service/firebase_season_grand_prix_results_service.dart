import '../firebase_collections_references.dart';
import '../model/season_grand_prix_results_dto.dart';

class FirebaseSeasonGrandPrixResultsService {
  final _firebaseCollectionReferences = FirebaseCollectionsReferences();

  Future<SeasonGrandPrixResultsDto?> fetchBySeasonGrandPrixId({
    required int season,
    required String seasonGrandPrixId,
  }) async {
    final snapshot = await _firebaseCollectionReferences
        .seasonGrandPrixesResults(season)
        .where(
          SeasonGrandPrixResultsFields.seasonGrandPrixId,
          isEqualTo: seasonGrandPrixId,
        )
        .limit(1)
        .get();
    return snapshot.docs.isEmpty ? null : snapshot.docs.first.data();
  }

  Future<SeasonGrandPrixResultsDto?> add({
    required int season,
    required String seasonGrandPrixId,
    List<String?>? qualiStandingsBySeasonDriverIds,
    String? p1SeasonDriverId,
    String? p2SeasonDriverId,
    String? p3SeasonDriverId,
    String? p10SeasonDriverId,
    String? fastestLapSeasonDriverId,
    List<String>? dnfSeasonDriverIds,
    bool? wasThereSafetyCar,
    bool? wasThereRedFlag,
  }) async {
    final dto = SeasonGrandPrixResultsDto(
      season: season,
      seasonGrandPrixId: seasonGrandPrixId,
      qualiStandingsBySeasonDriverIds: qualiStandingsBySeasonDriverIds,
      p1SeasonDriverId: p1SeasonDriverId,
      p2SeasonDriverId: p2SeasonDriverId,
      p3SeasonDriverId: p3SeasonDriverId,
      p10SeasonDriverId: p10SeasonDriverId,
      fastestLapSeasonDriverId: fastestLapSeasonDriverId,
      dnfSeasonDriverIds: dnfSeasonDriverIds,
      wasThereSafetyCar: wasThereSafetyCar,
      wasThereRedFlag: wasThereRedFlag,
    );
    final docRef = await _firebaseCollectionReferences
        .seasonGrandPrixesResults(season)
        .add(dto);
    final snapshot = await docRef.get();
    return snapshot.data();
  }

  Future<SeasonGrandPrixResultsDto?> update({
    required String id,
    required int season,
    List<String?>? qualiStandingsBySeasonDriverIds,
    String? p1SeasonDriverId,
    String? p2SeasonDriverId,
    String? p3SeasonDriverId,
    String? p10SeasonDriverId,
    String? fastestLapSeasonDriverId,
    List<String>? dnfSeasonDriverIds,
    bool? wasThereSafetyCar,
    bool? wasThereRedFlag,
  }) async {
    final docRef =
        _firebaseCollectionReferences.seasonGrandPrixesResults(season).doc(id);
    await docRef.update({
      if (qualiStandingsBySeasonDriverIds != null)
        SeasonGrandPrixResultsFields.qualiStandingsBySeasonDriverIds:
            qualiStandingsBySeasonDriverIds,
      if (p1SeasonDriverId != null)
        SeasonGrandPrixResultsFields.p1SeasonDriverId: p1SeasonDriverId,
      if (p2SeasonDriverId != null)
        SeasonGrandPrixResultsFields.p2SeasonDriverId: p2SeasonDriverId,
      if (p3SeasonDriverId != null)
        SeasonGrandPrixResultsFields.p3SeasonDriverId: p3SeasonDriverId,
      if (p10SeasonDriverId != null)
        SeasonGrandPrixResultsFields.p10SeasonDriverId: p10SeasonDriverId,
      if (fastestLapSeasonDriverId != null)
        SeasonGrandPrixResultsFields.fastestLapSeasonDriverId:
            fastestLapSeasonDriverId,
      if (dnfSeasonDriverIds != null)
        SeasonGrandPrixResultsFields.dnfSeasonDriverIds: dnfSeasonDriverIds,
      if (wasThereSafetyCar != null)
        SeasonGrandPrixResultsFields.wasThereSafetyCar: wasThereSafetyCar,
      if (wasThereRedFlag != null)
        SeasonGrandPrixResultsFields.wasThereRedFlag: wasThereRedFlag,
    });
    final snapshot = await docRef.get();
    return snapshot.data();
  }
}
