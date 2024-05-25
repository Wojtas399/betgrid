import 'package:betgrid/data/repository/grand_prix_result/grand_prix_results_repository_impl.dart';
import 'package:betgrid/firebase/model/grand_prix_result_dto/grand_prix_results_dto.dart';
import 'package:betgrid/model/grand_prix_results.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/grand_prix_results_creator.dart';
import '../../../creator/grand_prix_results_dto_creator.dart';
import '../../../mock/firebase/mock_firebase_grand_prix_results_service.dart';

void main() {
  final dbGrandPrixResultsService = MockFirebaseGrandPrixResultsService();
  late GrandPrixResultsRepositoryImpl repositoryImpl;

  setUp(() {
    repositoryImpl = GrandPrixResultsRepositoryImpl(dbGrandPrixResultsService);
  });

  tearDown(() {
    reset(dbGrandPrixResultsService);
  });

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
      dbGrandPrixResultsService.mockFetchResultsForGrandPrix(
        grandPrixResultDto: gpResultsDto,
      );
      final repositoryImpl = GrandPrixResultsRepositoryImpl(
        dbGrandPrixResultsService,
      );

      final Stream<GrandPrixResults?> results1$ =
          repositoryImpl.getGrandPrixResultsForGrandPrix(
        grandPrixId: grandPrixId,
      );
      final Stream<GrandPrixResults?> results2$ =
          repositoryImpl.getGrandPrixResultsForGrandPrix(
        grandPrixId: grandPrixId,
      );

      expect(await results1$.first, expectedGpResults);
      expect(await results2$.first, expectedGpResults);
      expect(await repositoryImpl.repositoryState$.first, [expectedGpResults]);
      verify(
        () => dbGrandPrixResultsService.fetchResultsForGrandPrix(
          grandPrixId: grandPrixId,
        ),
      ).called(1);
    },
  );

  test(
    'getResultsForGrandPrixes, '
    'should emit gp results which already exists in repo state and should fetch '
    'gp results which do not exist in repo state',
    () async {
      final GrandPrixResultsDto gp1ResultsDto = createGrandPrixResultsDto(
        id: 'gpr1',
        grandPrixId: 'gp1',
      );
      final GrandPrixResultsDto gp2ResultsDto = createGrandPrixResultsDto(
        id: 'gpr2',
        grandPrixId: 'gp2',
      );
      final GrandPrixResultsDto gp3ResultsDto = createGrandPrixResultsDto(
        id: 'gpr3',
        grandPrixId: 'gp3',
      );
      final List<GrandPrixResults> expectedGpResults1 = [
        createGrandPrixResults(
          id: 'gpr1',
          grandPrixId: 'gp1',
        ),
        createGrandPrixResults(
          id: 'gpr2',
          grandPrixId: 'gp2',
        ),
      ];
      final List<GrandPrixResults> expectedGpResults2 = [
        createGrandPrixResults(
          id: 'gpr1',
          grandPrixId: 'gp1',
        ),
        createGrandPrixResults(
          id: 'gpr2',
          grandPrixId: 'gp2',
        ),
        createGrandPrixResults(
          id: 'gpr3',
          grandPrixId: 'gp3',
        ),
      ];
      when(
        () => dbGrandPrixResultsService.fetchResultsForGrandPrix(
          grandPrixId: 'gp1',
        ),
      ).thenAnswer((_) => Future.value(gp1ResultsDto));
      when(
        () => dbGrandPrixResultsService.fetchResultsForGrandPrix(
          grandPrixId: 'gp2',
        ),
      ).thenAnswer((_) => Future.value(gp2ResultsDto));
      when(
        () => dbGrandPrixResultsService.fetchResultsForGrandPrix(
          grandPrixId: 'gp3',
        ),
      ).thenAnswer((_) => Future.value(gp3ResultsDto));

      final Stream<List<GrandPrixResults>> gpResults1$ =
          repositoryImpl.getGrandPrixResultsForGrandPrixes(
        idsOfGrandPrixes: ['gp1', 'gp2'],
      );
      final Stream<List<GrandPrixResults>> gpResults2$ =
          repositoryImpl.getGrandPrixResultsForGrandPrixes(
        idsOfGrandPrixes: ['gp1', 'gp2', 'gp3'],
      );

      expect(await gpResults1$.first, expectedGpResults1);
      expect(await gpResults2$.first, expectedGpResults2);
      expect(await repositoryImpl.repositoryState$.first, expectedGpResults2);
      verify(
        () => dbGrandPrixResultsService.fetchResultsForGrandPrix(
          grandPrixId: 'gp1',
        ),
      ).called(1);
      verify(
        () => dbGrandPrixResultsService.fetchResultsForGrandPrix(
          grandPrixId: 'gp2',
        ),
      ).called(1);
      verify(
        () => dbGrandPrixResultsService.fetchResultsForGrandPrix(
          grandPrixId: 'gp3',
        ),
      ).called(1);
    },
  );
}
