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
    'results for given grand prix exists in repo state, '
    'should emit existing results',
    () {
      const String grandPrixId = 'gp1';
      final GrandPrixResults expectedGrandPrixResults =
          createGrandPrixResults(id: 'r1', grandPrixId: grandPrixId);
      final List<GrandPrixResults> existingResults = [
        createGrandPrixResults(id: 'r2', grandPrixId: 'gp2'),
        createGrandPrixResults(id: 'r3', grandPrixId: 'gp3'),
        expectedGrandPrixResults,
      ];
      final repositoryImpl = GrandPrixResultsRepositoryImpl(
        firebaseGrandPrixResultsService: dbGrandPrixResultService,
        initialData: existingResults,
      );

      final Stream<GrandPrixResults?> results$ =
          repositoryImpl.getResultForGrandPrix(grandPrixId: grandPrixId);

      expect(results$, emits(expectedGrandPrixResults));
    },
  );

  test(
    'getResultsForGrandPrix, '
    'results for given grand prix does not exist in repo state, '
    'should load grand prix results from db, add it to repo and emit it',
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
      final List<GrandPrixResults> existingResults = [
        createGrandPrixResults(id: 'r2', grandPrixId: 'gp2'),
        createGrandPrixResults(id: 'r3', grandPrixId: 'gp3'),
      ];
      dbGrandPrixResultService.mockLoadResultsForGrandPrix(
        grandPrixResultDto: gpResultsDto,
      );
      final repositoryImpl = GrandPrixResultsRepositoryImpl(
        firebaseGrandPrixResultsService: dbGrandPrixResultService,
        initialData: existingResults,
      );

      final Stream<GrandPrixResults?> results$ =
          repositoryImpl.getResultForGrandPrix(grandPrixId: grandPrixId);

      expect(await results$.first, expectedGpResults);
      expect(
        repositoryImpl.repositoryState$,
        emits([...existingResults, expectedGpResults]),
      );
      verify(
        () => dbGrandPrixResultService.loadResultsForGrandPrix(
          grandPrixId: grandPrixId,
        ),
      ).called(1);
    },
  );
}
