import 'package:betgrid_shared/firebase/model/season_grand_prix_results_dto.dart';
import 'package:betgrid_shared/firebase/service/firebase_season_grand_prix_results_service.dart';
import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:mutex/mutex.dart';

import '../../../model/season_grand_prix_results.dart';
import '../../mapper/season_grand_prix_results_mapper.dart';
import '../repository.dart';
import 'season_grand_prix_results_repository.dart';

@LazySingleton(as: SeasonGrandPrixResultsRepository)
class SeasonGrandPrixResultsRepositoryImpl
    extends Repository<SeasonGrandPrixResults>
    implements SeasonGrandPrixResultsRepository {
  final FirebaseSeasonGrandPrixResultsService
  _fireSeasonGrandPrixResultsService;
  final SeasonGrandPrixResultsMapper _seasonGrandPrixResultsMapper;
  final _getForSeasonGrandPrixMutex = Mutex();

  SeasonGrandPrixResultsRepositoryImpl(
    this._fireSeasonGrandPrixResultsService,
    this._seasonGrandPrixResultsMapper,
  );

  @override
  Stream<SeasonGrandPrixResults?> getForSeasonGrandPrix({
    required int season,
    required String seasonGrandPrixId,
  }) async* {
    bool didRelease = false;
    await _getForSeasonGrandPrixMutex.acquire();
    await for (final seasonGrandPrixResults in repositoryState$) {
      SeasonGrandPrixResults? matchingGpResults = seasonGrandPrixResults
          .firstWhereOrNull(
            (gpResults) => gpResults.seasonGrandPrixId == seasonGrandPrixId,
          );
      matchingGpResults ??= await _fetchForSeasonGrandPrix(
        season,
        seasonGrandPrixId,
      );
      if (_getForSeasonGrandPrixMutex.isLocked && !didRelease) {
        _getForSeasonGrandPrixMutex.release();
        didRelease = true;
      }
      yield matchingGpResults;
    }
  }

  Future<SeasonGrandPrixResults?> _fetchForSeasonGrandPrix(
    int season,
    String seasonGrandPrixId,
  ) async {
    final SeasonGrandPrixResultsDto? resultsDto =
        await _fireSeasonGrandPrixResultsService.fetchBySeasonGrandPrixId(
          season: season,
          seasonGrandPrixId: seasonGrandPrixId,
        );
    if (resultsDto == null) return null;
    final SeasonGrandPrixResults results = _seasonGrandPrixResultsMapper
        .mapFromDto(resultsDto);
    addEntity(results);
    return results;
  }
}
