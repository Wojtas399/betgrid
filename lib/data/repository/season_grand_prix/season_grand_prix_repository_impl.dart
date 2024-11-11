import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';

import '../../../model/season_grand_prix.dart';
import '../../firebase/service/firebase_season_grand_prix_service.dart';
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
  Stream<List<SeasonGrandPrix>> getAllSeasonGrandPrixesFromSeason(
    int season,
  ) async* {
    await _fetchAllSeasonGrandPrixesFromSeason(season);
    await for (final allSeasonGrandPrixes in repositoryState$) {
      yield allSeasonGrandPrixes
          .where((seasonGrandPrix) => seasonGrandPrix.season == season)
          .toList();
    }
  }

  @override
  Stream<SeasonGrandPrix?> getSeasonGrandPrixById(String id) async* {
    await for (final allSeasonGrandPrixes in repositoryState$) {
      SeasonGrandPrix? matchingSeasonGrandPrix =
          allSeasonGrandPrixes.firstWhereOrNull(
        (seasonGrandPrix) => seasonGrandPrix.id == id,
      );
      matchingSeasonGrandPrix ??= await _fetchSeasonGrandPrixById(id);
      yield matchingSeasonGrandPrix;
    }
  }

  Future<void> _fetchAllSeasonGrandPrixesFromSeason(int season) async {
    final seasonGrandPrixDtos = await _firebaseSeasonGrandPrixService
        .fetchAllSeasonGrandPrixesFromSeason(season);
    if (seasonGrandPrixDtos.isNotEmpty) {
      final seasonGrandPrixes =
          seasonGrandPrixDtos.map(_seasonGrandPrixMapper.mapFromDto);
      addOrUpdateEntities(seasonGrandPrixes);
    }
  }

  Future<SeasonGrandPrix?> _fetchSeasonGrandPrixById(String id) async {
    final seasonGrandPrixDto =
        await _firebaseSeasonGrandPrixService.fetchSeasonGrandPrixById(id);
    if (seasonGrandPrixDto == null) return null;
    final seasonGrandPrix =
        _seasonGrandPrixMapper.mapFromDto(seasonGrandPrixDto);
    addEntity(seasonGrandPrix);
    return seasonGrandPrix;
  }
}
