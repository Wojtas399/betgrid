import 'package:betgrid/data/repository/grand_prix_result/grand_prix_results_repository_impl.dart';
import 'package:betgrid/firebase/model/grand_prix_result_dto/grand_prix_results_dto.dart';
import 'package:betgrid/model/grand_prix_results.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/grand_prix_results_creator.dart';
import '../../../creator/grand_prix_results_dto_creator.dart';
import '../../../mock/firebase/mock_firebase_grand_prix_results_service.dart';

void main() {
  final dbGrandPrixResultService = MockFirebaseGrandPrixResultsService();

  test(
    'getResultsForGrandPrix, '
    'should load grand prix results from db, add it to repo state and emit it if '
    'it does not already exist in repo state, '
    'should only emit existing results if it exist in repo state',
    () async {
      const String grandPrixId = 'gp1';
      final GrandPrixResultsDto gpResultsDto = createGrandPrixResultsDto(
        id: 'r1',
        grandPrixId: grandPrixId,
      );
      final GrandPrixResults expectedGpResults = createGrandPrixResults(
        id: 'r1',
        grandPrixId: grandPrixId,
      );
      dbGrandPrixResultService.mockFetchResultsForGrandPrix(
        grandPrixResultDto: gpResultsDto,
      );
      final repositoryImpl = GrandPrixResultsRepositoryImpl(
        dbGrandPrixResultService,
      );

      final Stream<GrandPrixResults?> results1$ =
          repositoryImpl.getResultForGrandPrix(grandPrixId: grandPrixId);
      final Stream<GrandPrixResults?> results2$ =
          repositoryImpl.getResultForGrandPrix(grandPrixId: grandPrixId);

      expect(await results1$.first, expectedGpResults);
      expect(await results2$.first, expectedGpResults);
      expect(await repositoryImpl.repositoryState$.first, [expectedGpResults]);
      verify(
        () => dbGrandPrixResultService.fetchResultsForGrandPrix(
          grandPrixId: grandPrixId,
        ),
      ).called(1);
    },
  );
}
