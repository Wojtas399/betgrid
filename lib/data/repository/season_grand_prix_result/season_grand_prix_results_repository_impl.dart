import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:mutex/mutex.dart';

import '../../../model/season_grand_prix_results.dart';
import '../../../ui/extensions/stream_extensions.dart';
import '../../firebase/model/grand_prix_results_dto.dart';
import '../../firebase/service/firebase_grand_prix_results_service.dart';
import '../../mapper/season_grand_prix_results_mapper.dart';
import '../repository.dart';
import 'season_grand_prix_results_repository.dart';

@LazySingleton(as: SeasonGrandPrixResultsRepository)
class SeasonGrandPrixResultsRepositoryImpl
    extends Repository<SeasonGrandPrixResults>
    implements SeasonGrandPrixResultsRepository {
  final FirebaseGrandPrixResultsService _fireGrandPrixResultsService;
  final SeasonGrandPrixResultsMapper _seasonGrandPrixResultsMapper;
  final _getResultsForSeasonGrandPrixMutex = Mutex();

  SeasonGrandPrixResultsRepositoryImpl(
    this._fireGrandPrixResultsService,
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
              idsOfGpsWithMissingResults,
            );
            existingGpResults.addAll(missingGpResults);
          }
          return existingGpResults;
        },
      ).distinctList();

  Future<SeasonGrandPrixResults?> _fetchResultsForSeasonGrandPrixFromDb(
    String seasonGrandPrixId,
  ) async {
    final GrandPrixResultsDto? gpResultsDto = await _fireGrandPrixResultsService
        .fetchResultsForSeasonGrandPrix(seasonGrandPrixId: seasonGrandPrixId);
    if (gpResultsDto == null) return null;
    final SeasonGrandPrixResults gpResults =
        _seasonGrandPrixResultsMapper.mapFromDto(gpResultsDto);
    addEntity(gpResults);
    return gpResults;
  }

  Future<List<SeasonGrandPrixResults>> _fetchResultsForSeasonGrandPrixesFromDb(
    Iterable<String> idsOfSeasonGrandPrixes,
  ) async {
    final List<SeasonGrandPrixResults> fetchedGpResults = [];
    for (final String seasonGrandPrixId in idsOfSeasonGrandPrixes) {
      final GrandPrixResultsDto? gpResultsDto =
          await _fireGrandPrixResultsService.fetchResultsForSeasonGrandPrix(
              seasonGrandPrixId: seasonGrandPrixId);
      if (gpResultsDto != null) {
        final SeasonGrandPrixResults gpResults =
            _seasonGrandPrixResultsMapper.mapFromDto(gpResultsDto);
        fetchedGpResults.add(gpResults);
      }
    }
    if (fetchedGpResults.isNotEmpty) addEntities(fetchedGpResults);
    return fetchedGpResults;
  }
}
