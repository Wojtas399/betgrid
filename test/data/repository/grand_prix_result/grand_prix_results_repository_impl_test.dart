import 'package:betgrid/data/repository/grand_prix_result/grand_prix_results_repository_impl.dart';
import 'package:betgrid/model/grand_prix_results.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/grand_prix_results_creator.dart';
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
      final GrandPrixResultsCreator grandPrixResultsCreator =
          GrandPrixResultsCreator(
        id: 'r1',
        grandPrixId: grandPrixId,
      );
      final GrandPrixResults expectedGpResults =
          grandPrixResultsCreator.createEntity();
      dbGrandPrixResultsService.mockFetchResultsForGrandPrix(
        grandPrixResultDto: grandPrixResultsCreator.createDto(),
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
      const String gp1Id = 'gp1';
      const String gp2Id = 'gp2';
      const String gp3Id = 'gp3';
      final GrandPrixResultsCreator gp1ResultsCreator = GrandPrixResultsCreator(
        id: 'gpr1',
        grandPrixId: gp1Id,
      );
      final GrandPrixResultsCreator gp2ResultsCreator = GrandPrixResultsCreator(
        id: 'gpr2',
        grandPrixId: gp2Id,
      );
      final GrandPrixResultsCreator gp3ResultsCreator = GrandPrixResultsCreator(
        id: 'gpr3',
        grandPrixId: gp3Id,
      );
      final List<GrandPrixResults> expectedGpResults1 = [
        gp1ResultsCreator.createEntity(),
        gp2ResultsCreator.createEntity(),
      ];
      final List<GrandPrixResults> expectedGpResults2 = [
        gp1ResultsCreator.createEntity(),
        gp2ResultsCreator.createEntity(),
        gp3ResultsCreator.createEntity(),
      ];
      when(
        () => dbGrandPrixResultsService.fetchResultsForGrandPrix(
          grandPrixId: gp1Id,
        ),
      ).thenAnswer((_) => Future.value(gp1ResultsCreator.createDto()));
      when(
        () => dbGrandPrixResultsService.fetchResultsForGrandPrix(
          grandPrixId: gp2Id,
        ),
      ).thenAnswer((_) => Future.value(gp2ResultsCreator.createDto()));
      when(
        () => dbGrandPrixResultsService.fetchResultsForGrandPrix(
          grandPrixId: gp3Id,
        ),
      ).thenAnswer((_) => Future.value(gp3ResultsCreator.createDto()));

      final Stream<List<GrandPrixResults>> gpResults1$ =
          repositoryImpl.getGrandPrixResultsForGrandPrixes(
        idsOfGrandPrixes: [gp1Id, gp2Id],
      );
      final Stream<List<GrandPrixResults>> gpResults2$ =
          repositoryImpl.getGrandPrixResultsForGrandPrixes(
        idsOfGrandPrixes: [gp1Id, gp2Id, gp3Id],
      );

      expect(await gpResults1$.first, expectedGpResults1);
      expect(await gpResults2$.first, expectedGpResults2);
      expect(await repositoryImpl.repositoryState$.first, expectedGpResults2);
      verify(
        () => dbGrandPrixResultsService.fetchResultsForGrandPrix(
          grandPrixId: gp1Id,
        ),
      ).called(1);
      verify(
        () => dbGrandPrixResultsService.fetchResultsForGrandPrix(
          grandPrixId: gp2Id,
        ),
      ).called(1);
      verify(
        () => dbGrandPrixResultsService.fetchResultsForGrandPrix(
          grandPrixId: gp3Id,
        ),
      ).called(1);
    },
  );
}
