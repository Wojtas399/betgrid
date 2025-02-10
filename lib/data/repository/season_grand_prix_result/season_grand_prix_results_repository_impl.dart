import 'package:betgrid_shared/firebase/model/season_grand_prix_results_dto.dart';
import 'package:betgrid_shared/firebase/service/firebase_season_grand_prix_results_service.dart';
import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:mutex/mutex.dart';

import '../../../model/season_grand_prix_results.dart';
import '../../../ui/extensions/stream_extensions.dart';
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
  final _getResultsForSeasonGrandPrixMutex = Mutex();

  SeasonGrandPrixResultsRepositoryImpl(
    this._fireSeasonGrandPrixResultsService,
    this._seasonGrandPrixResultsMapper,
  );

  @override
  Stream<SeasonGrandPrixResults?> getResultsForSeasonGrandPrix({
    required int season,
    required String seasonGrandPrixId,
  }) async* {
    bool didRelease = false;
    await _getResultsForSeasonGrandPrixMutex.acquire();
    await for (final seasonGrandPrixResults in repositoryState$) {
      SeasonGrandPrixResults? matchingGpResults =
          seasonGrandPrixResults.firstWhereOrNull(
        (gpResults) => gpResults.seasonGrandPrixId == seasonGrandPrixId,
      );
      matchingGpResults ??= await _fetchResultsForSeasonGrandPrixFromDb(
        season,
        seasonGrandPrixId,
      );
      if (_getResultsForSeasonGrandPrixMutex.isLocked && !didRelease) {
        _getResultsForSeasonGrandPrixMutex.release();
        didRelease = true;
      }
      yield matchingGpResults;
    }
  }

  @override
  Stream<List<SeasonGrandPrixResults>> getResultsForSeasonGrandPrixes({
    required int season,
    required List<String> idsOfSeasonGrandPrixes,
  }) =>
      repositoryState$.asyncMap(
        (List<SeasonGrandPrixResults> seasonGrandPrixResults) async {
          final List<SeasonGrandPrixResults> existingGpResults = [
            ...seasonGrandPrixResults.where(
              (SeasonGrandPrixResults gpResults) =>
                  idsOfSeasonGrandPrixes.contains(
                gpResults.seasonGrandPrixId,
              ),
            ),
          ];
          final idsOfGpsWithExistingResults = existingGpResults.map(
            (SeasonGrandPrixResults gpResults) => gpResults.seasonGrandPrixId,
          );
          final idsOfGpsWithMissingResults = idsOfSeasonGrandPrixes.where(
            (String gpId) => !idsOfGpsWithExistingResults.contains(gpId),
          );
          if (idsOfGpsWithMissingResults.isNotEmpty) {
            final missingGpResults =
                await _fetchResultsForSeasonGrandPrixesFromDb(
              season,
              idsOfGpsWithMissingResults,
            );
            existingGpResults.addAll(missingGpResults);
          }
          return existingGpResults;
        },
      ).distinctList();

  Future<SeasonGrandPrixResults?> _fetchResultsForSeasonGrandPrixFromDb(
    int season,
    String seasonGrandPrixId,
  ) async {
    final SeasonGrandPrixResultsDto? resultsDto =
        await _fireSeasonGrandPrixResultsService.fetchResultsForSeasonGrandPrix(
      season: season,
      seasonGrandPrixId: seasonGrandPrixId,
    );
    if (resultsDto == null) return null;
    final SeasonGrandPrixResults results =
        _seasonGrandPrixResultsMapper.mapFromDto(resultsDto);
    addEntity(results);
    return results;
  }

  Future<List<SeasonGrandPrixResults>> _fetchResultsForSeasonGrandPrixesFromDb(
    int season,
    Iterable<String> idsOfSeasonGrandPrixes,
  ) async {
    final List<SeasonGrandPrixResults> fetchedGpResults = [];
    for (final String seasonGrandPrixId in idsOfSeasonGrandPrixes) {
      final SeasonGrandPrixResultsDto? resultsDto =
          await _fireSeasonGrandPrixResultsService
              .fetchResultsForSeasonGrandPrix(
        season: season,
        seasonGrandPrixId: seasonGrandPrixId,
      );
      if (resultsDto != null) {
        final SeasonGrandPrixResults results =
            _seasonGrandPrixResultsMapper.mapFromDto(resultsDto);
        fetchedGpResults.add(results);
      }
    }
    if (fetchedGpResults.isNotEmpty) addEntities(fetchedGpResults);
    return fetchedGpResults;
  }
}
