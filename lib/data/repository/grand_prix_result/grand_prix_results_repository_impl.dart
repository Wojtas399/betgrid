import 'package:collection/collection.dart';

import '../../../dependency_injection.dart';
import '../../../firebase/model/grand_prix_result_dto/grand_prix_results_dto.dart';
import '../../../firebase/service/firebase_grand_prix_results_service.dart';
import '../../../model/grand_prix_results.dart';
import '../../mapper/grand_prix_results_mapper.dart';
import '../repository.dart';
import 'grand_prix_results_repository.dart';

class GrandPrixResultsRepositoryImpl extends Repository<GrandPrixResults>
    implements GrandPrixResultsRepository {
  final FirebaseGrandPrixResultsService _dbGrandPrixResultsService;

  GrandPrixResultsRepositoryImpl({super.initialData})
      : _dbGrandPrixResultsService = getIt<FirebaseGrandPrixResultsService>();

  @override
  Stream<GrandPrixResults?> getResultForGrandPrix({
    required String grandPrixId,
  }) async* {
    await for (final grandPrixesResults in repositoryState$) {
      GrandPrixResults? matchingGpResults =
          grandPrixesResults?.firstWhereOrNull(
        (gpResults) => gpResults.grandPrixId == grandPrixId,
      );
      matchingGpResults ??= await _loadResultsForGrandPrixFromDb(grandPrixId);
      yield matchingGpResults;
    }
  }

  Future<GrandPrixResults?> _loadResultsForGrandPrixFromDb(
    String grandPrixId,
  ) async {
    final GrandPrixResultsDto? gpResultsDto = await _dbGrandPrixResultsService
        .loadResultsForGrandPrix(grandPrixId: grandPrixId);
    if (gpResultsDto == null) return null;
    final GrandPrixResults gpResults = mapGrandPrixResultsFromDto(gpResultsDto);
    addEntity(gpResults);
    return gpResults;
  }
}