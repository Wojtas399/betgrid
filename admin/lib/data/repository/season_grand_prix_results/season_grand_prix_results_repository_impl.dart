import 'package:betgrid_shared/firebase/model/season_grand_prix_results_dto.dart';
import 'package:betgrid_shared/firebase/service/firebase_season_grand_prix_results_service.dart';
import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';

import '../../../model/season_grand_prix_results.dart';
import '../../mapper/season_grand_prix_results_mapper.dart';
import '../repository.dart';
import 'season_grand_prix_results_repository.dart';

@Singleton(as: SeasonGrandPrixResultsRepository)
class SeasonGrandPrixResultsRepositoryImpl
    extends Repository<SeasonGrandPrixResults>
    implements SeasonGrandPrixResultsRepository {
  final FirebaseSeasonGrandPrixResultsService
  _fireSeasonGrandPrixResultsService;
  final SeasonGrandPrixResultsMapper _seasonGrandPrixResultsMapper;

  SeasonGrandPrixResultsRepositoryImpl(
    this._fireSeasonGrandPrixResultsService,
    this._seasonGrandPrixResultsMapper,
  );

  @override
  Stream<SeasonGrandPrixResults?> getBySeasonGrandPrixId({
    required int season,
    required String seasonGrandPrixId,
  }) async* {
    await for (final entities in repositoryState$) {
      SeasonGrandPrixResults? matchingEntity = entities.firstWhereOrNull(
        (entity) =>
            entity.season == season &&
            entity.seasonGrandPrixId == seasonGrandPrixId,
      );
      matchingEntity ??= await _fetchBySeasonGrandPrixId(
        season,
        seasonGrandPrixId,
      );
      yield matchingEntity;
    }
  }

  @override
  Future<void> add({
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
    final SeasonGrandPrixResultsDto? addedDto =
        await _fireSeasonGrandPrixResultsService.add(
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

    if (addedDto != null) {
      final SeasonGrandPrixResults entity = _seasonGrandPrixResultsMapper
          .mapFromDto(addedDto);
      addEntity(entity);
    }
  }

  @override
  Future<void> update({
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
    final SeasonGrandPrixResultsDto? updatedDto =
        await _fireSeasonGrandPrixResultsService.update(
          id: id,
          season: season,
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

    if (updatedDto != null) {
      final SeasonGrandPrixResults entity = _seasonGrandPrixResultsMapper
          .mapFromDto(updatedDto);
      updateEntity(entity);
    }
  }

  Future<SeasonGrandPrixResults?> _fetchBySeasonGrandPrixId(
    int season,
    String seasonGrandPrixId,
  ) async {
    final SeasonGrandPrixResultsDto? dto =
        await _fireSeasonGrandPrixResultsService.fetchBySeasonGrandPrixId(
          season: season,
          seasonGrandPrixId: seasonGrandPrixId,
        );

    if (dto == null) return null;

    final SeasonGrandPrixResults entity = _seasonGrandPrixResultsMapper
        .mapFromDto(dto);

    addEntity(entity);

    return entity;
  }
}
