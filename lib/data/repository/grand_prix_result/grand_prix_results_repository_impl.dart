import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:mutex/mutex.dart';

import '../../../model/grand_prix_results.dart';
import '../../../ui/extensions/stream_extensions.dart';
import '../../firebase/model/grand_prix_results_dto.dart';
import '../../firebase/service/firebase_grand_prix_results_service.dart';
import '../../mapper/grand_prix_results_mapper.dart';
import '../repository.dart';
import 'grand_prix_results_repository.dart';

@LazySingleton(as: GrandPrixResultsRepository)
class GrandPrixResultsRepositoryImpl extends Repository<GrandPrixResults>
    implements GrandPrixResultsRepository {
  final FirebaseGrandPrixResultsService _dbGrandPrixResultsService;
  final GrandPrixResultsMapper _grandPrixResultsMapper;
  final _getGrandPrixResultsForGrandPrixMutex = Mutex();

  GrandPrixResultsRepositoryImpl(
    this._dbGrandPrixResultsService,
    this._grandPrixResultsMapper,
  );

  @override
  Stream<GrandPrixResults?> getGrandPrixResultsForGrandPrix({
    required String grandPrixId,
  }) async* {
    bool didRelease = false;
    await _getGrandPrixResultsForGrandPrixMutex.acquire();
    await for (final grandPrixesResults in repositoryState$) {
      GrandPrixResults? matchingGpResults = grandPrixesResults.firstWhereOrNull(
        (gpResults) => gpResults.seasonGrandPrixId == grandPrixId,
      );
      matchingGpResults ??= await _fetchResultsForGrandPrixFromDb(grandPrixId);
      if (_getGrandPrixResultsForGrandPrixMutex.isLocked && !didRelease) {
        _getGrandPrixResultsForGrandPrixMutex.release();
        didRelease = true;
      }
      yield matchingGpResults;
    }
  }

  @override
  Stream<List<GrandPrixResults>> getGrandPrixResultsForGrandPrixes({
    required List<String> idsOfGrandPrixes,
  }) =>
      repositoryState$.asyncMap(
        (List<GrandPrixResults> grandPrixResults) async {
          final List<GrandPrixResults> existingGpResults = [
            ...grandPrixResults.where(
              (GrandPrixResults gpResults) => idsOfGrandPrixes.contains(
                gpResults.seasonGrandPrixId,
              ),
            ),
          ];
          final idsOfGpsWithExistingResults = existingGpResults.map(
            (GrandPrixResults gpResults) => gpResults.seasonGrandPrixId,
          );
          final idsOfGpsWithMissingResults = idsOfGrandPrixes.where(
            (String gpId) => !idsOfGpsWithExistingResults.contains(gpId),
          );
          if (idsOfGpsWithMissingResults.isNotEmpty) {
            final missingGpResults = await _fetchResultsForGrandPrixesFromDb(
              idsOfGpsWithMissingResults,
            );
            existingGpResults.addAll(missingGpResults);
          }
          return existingGpResults;
        },
      ).distinctList();

  Future<GrandPrixResults?> _fetchResultsForGrandPrixFromDb(
    String grandPrixId,
  ) async {
    final GrandPrixResultsDto? gpResultsDto = await _dbGrandPrixResultsService
        .fetchResultsForGrandPrix(grandPrixId: grandPrixId);
    if (gpResultsDto == null) return null;
    final GrandPrixResults gpResults =
        _grandPrixResultsMapper.mapFromDto(gpResultsDto);
    addEntity(gpResults);
    return gpResults;
  }

  Future<List<GrandPrixResults>> _fetchResultsForGrandPrixesFromDb(
    Iterable<String> idsOfGrandPrixes,
  ) async {
    final List<GrandPrixResults> fetchedGpResults = [];
    for (final String gpId in idsOfGrandPrixes) {
      final GrandPrixResultsDto? gpResultsDto = await _dbGrandPrixResultsService
          .fetchResultsForGrandPrix(grandPrixId: gpId);
      if (gpResultsDto != null) {
        final GrandPrixResults gpResults =
            _grandPrixResultsMapper.mapFromDto(gpResultsDto);
        fetchedGpResults.add(gpResults);
      }
    }
    if (fetchedGpResults.isNotEmpty) addEntities(fetchedGpResults);
    return fetchedGpResults;
  }
}
