import 'package:betgrid/data/firebase/model/grand_prix_results_dto.dart';
import 'package:betgrid/data/repository/grand_prix_result/grand_prix_results_repository_impl.dart';
import 'package:betgrid/model/grand_prix_results.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../creator/grand_prix_results_creator.dart';
import '../../mock/data/mapper/mock_grand_prix_results_mapper.dart';
import '../../mock/firebase/mock_firebase_grand_prix_results_service.dart';

void main() {
  final dbGrandPrixResultsService = MockFirebaseGrandPrixResultsService();
  final grandPrixResultsMapper = MockGrandPrixResultsMapper();
  late GrandPrixResultsRepositoryImpl repositoryImpl;

  setUp(() {
    repositoryImpl = GrandPrixResultsRepositoryImpl(
      dbGrandPrixResultsService,
      grandPrixResultsMapper,
    );
  });

  tearDown(() {
    reset(dbGrandPrixResultsService);
    reset(grandPrixResultsMapper);
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
      grandPrixResultsMapper.mockMapFromDto(
        expectedGrandPrixResults: expectedGpResults,
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
      final List<GrandPrixResultsCreator> gpResultsCreators = [
        GrandPrixResultsCreator(
          id: 'gpr1',
          grandPrixId: gp1Id,
        ),
        GrandPrixResultsCreator(
          id: 'gpr2',
          grandPrixId: gp2Id,
        ),
        GrandPrixResultsCreator(
          id: 'gpr3',
          grandPrixId: gp3Id,
        ),
      ];
      final List<GrandPrixResultsDto> gpResultsDtos =
          gpResultsCreators.map((creator) => creator.createDto()).toList();
      final List<GrandPrixResults> gpResults =
          gpResultsCreators.map((creator) => creator.createEntity()).toList();
      final List<GrandPrixResults> expectedGpResults1 = [
        gpResults.first,
        gpResults[1],
      ];
      final List<GrandPrixResults> expectedGpResults2 = gpResults;
      when(
        () => dbGrandPrixResultsService.fetchResultsForGrandPrix(
          grandPrixId: gp1Id,
        ),
      ).thenAnswer((_) => Future.value(gpResultsDtos.first));
      when(
        () => dbGrandPrixResultsService.fetchResultsForGrandPrix(
          grandPrixId: gp2Id,
        ),
      ).thenAnswer((_) => Future.value(gpResultsDtos[1]));
      when(
        () => dbGrandPrixResultsService.fetchResultsForGrandPrix(
          grandPrixId: gp3Id,
        ),
      ).thenAnswer((_) => Future.value(gpResultsDtos.last));
      when(
        () => grandPrixResultsMapper.mapFromDto(gpResultsDtos.first),
      ).thenReturn(gpResults.first);
      when(
        () => grandPrixResultsMapper.mapFromDto(gpResultsDtos[1]),
      ).thenReturn(gpResults[1]);
      when(
        () => grandPrixResultsMapper.mapFromDto(gpResultsDtos.last),
      ).thenReturn(gpResults.last);

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
