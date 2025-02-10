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
  final FirebaseSeasonGrandPrixService _fireSeasonGrandPrixService;
  final SeasonGrandPrixMapper _seasonGrandPrixMapper;

  SeasonGrandPrixRepositoryImpl(
    this._fireSeasonGrandPrixService,
    this._seasonGrandPrixMapper,
  );

  @override
  Stream<List<SeasonGrandPrix>> getAllFromSeason(int season) async* {
    await _fetchAllFromSeason(season);
    await for (final allSeasonGrandPrixes in repositoryState$) {
      yield allSeasonGrandPrixes
          .where((seasonGrandPrix) => seasonGrandPrix.season == season)
          .toList();
    }
  }

  @override
  Stream<SeasonGrandPrix?> getById({
    required int season,
    required String seasonGrandPrixId,
  }) async* {
    await for (final allSeasonGrandPrixes in repositoryState$) {
      SeasonGrandPrix? matchingSeasonGrandPrix =
          allSeasonGrandPrixes.firstWhereOrNull(
        (seasonGrandPrix) =>
            seasonGrandPrix.season == season &&
            seasonGrandPrix.id == seasonGrandPrixId,
      );
      matchingSeasonGrandPrix ??= await _fetchById(
        season: season,
        seasonGrandPrixId: seasonGrandPrixId,
      );
      yield matchingSeasonGrandPrix;
    }
  }

  Future<void> _fetchAllFromSeason(int season) async {
    final seasonGrandPrixDtos =
        await _fireSeasonGrandPrixService.fetchAllFromSeason(season);
    if (seasonGrandPrixDtos.isNotEmpty) {
      final seasonGrandPrixes =
          seasonGrandPrixDtos.map(_seasonGrandPrixMapper.mapFromDto);
      addOrUpdateEntities(seasonGrandPrixes);
    }
  }

  Future<SeasonGrandPrix?> _fetchById({
    required int season,
    required String seasonGrandPrixId,
  }) async {
    final seasonGrandPrixDto = await _fireSeasonGrandPrixService.fetchById(
      season: season,
      seasonGrandPrixId: seasonGrandPrixId,
    );
    if (seasonGrandPrixDto == null) return null;
    final seasonGrandPrix =
        _seasonGrandPrixMapper.mapFromDto(seasonGrandPrixDto);
    addEntity(seasonGrandPrix);
    return seasonGrandPrix;
  }
}
