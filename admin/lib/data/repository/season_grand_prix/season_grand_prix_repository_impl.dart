import 'package:betgrid_shared/firebase/model/season_grand_prix_dto.dart';
import 'package:betgrid_shared/firebase/service/firebase_season_grand_prix_service.dart';
import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';

import '../../../model/season_grand_prix.dart';
import '../../mapper/season_grand_prix_mapper.dart';
import '../repository.dart';
import 'season_grand_prix_repository.dart';

@LazySingleton(as: SeasonGrandPrixRepository)
class SeasonGrandPrixRepositoryImpl extends Repository<SeasonGrandPrix>
    implements SeasonGrandPrixRepository {
  final FirebaseSeasonGrandPrixService _firebaseSeasonGrandPrixService;
  final SeasonGrandPrixMapper _seasonGrandPrixMapper;

  SeasonGrandPrixRepositoryImpl(
    this._firebaseSeasonGrandPrixService,
    this._seasonGrandPrixMapper,
  );

  @override
  Stream<Iterable<SeasonGrandPrix>> getAllFromSeason(int season) async* {
    await _fetchAllFromSeason(season);
    await for (final allGrandPrixes in repositoryState$) {
      yield allGrandPrixes.where((grandPrix) => grandPrix.season == season);
    }
  }

  @override
  Stream<SeasonGrandPrix?> getById({
    required int season,
    required String id,
  }) async* {
    await for (final entities in repositoryState$) {
      SeasonGrandPrix? matchingEntity = entities.firstWhereOrNull(
        (entity) => entity.season == season && entity.id == id,
      );
      matchingEntity ??= await _fetchById(season, id);

      yield matchingEntity;
    }
  }

  @override
  Future<void> add({
    required int season,
    required String grandPrixId,
    required int roundNumber,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final SeasonGrandPrixDto? addedSeasonGrandPrixDto =
        await _firebaseSeasonGrandPrixService.add(
          season: season,
          grandPrixId: grandPrixId,
          roundNumber: roundNumber,
          startDate: startDate,
          endDate: endDate,
        );

    if (addedSeasonGrandPrixDto != null) {
      final SeasonGrandPrix addedSeasonGrandPrix = _seasonGrandPrixMapper
          .mapFromDto(addedSeasonGrandPrixDto);

      addEntity(addedSeasonGrandPrix);
    }
  }

  @override
  Future<void> delete({
    required int season,
    required String seasonGrandPrixId,
  }) async {
    await _firebaseSeasonGrandPrixService.delete(
      season: season,
      seasonGrandPrixId: seasonGrandPrixId,
    );

    deleteEntity(seasonGrandPrixId);
  }

  Future<void> _fetchAllFromSeason(int season) async {
    final Iterable<SeasonGrandPrixDto> dtos =
        await _firebaseSeasonGrandPrixService.fetchAllFromSeason(season);

    if (dtos.isNotEmpty) {
      final Iterable<SeasonGrandPrix> entities = dtos.map(
        _seasonGrandPrixMapper.mapFromDto,
      );

      addOrUpdateEntities(entities);
    }
  }

  Future<SeasonGrandPrix?> _fetchById(int season, String id) async {
    final SeasonGrandPrixDto? dto = await _firebaseSeasonGrandPrixService
        .fetchById(season: season, seasonGrandPrixId: id);

    if (dto == null) return null;

    final SeasonGrandPrix entity = _seasonGrandPrixMapper.mapFromDto(dto);

    addEntity(entity);

    return entity;
  }
}
