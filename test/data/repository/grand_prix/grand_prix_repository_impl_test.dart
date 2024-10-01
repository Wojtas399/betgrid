import 'package:betgrid/data/firebase/model/grand_prix_dto/grand_prix_dto.dart';
import 'package:betgrid/data/repository/grand_prix/grand_prix_repository_impl.dart';
import 'package:betgrid/model/grand_prix.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/grand_prix_creator.dart';
import '../../../mock/firebase/mock_firebase_grand_prix_service.dart';

void main() {
  final dbGrandPrixService = MockFirebaseGrandPrixService();
  late GrandPrixRepositoryImpl repositoryImpl;

  setUp(() {
    repositoryImpl = GrandPrixRepositoryImpl(dbGrandPrixService);
  });

  tearDown(() {
    reset(dbGrandPrixService);
  });

  test(
    'loadAllGrandPrixes, '
    'repository state is empty, '
    'should load grand prixes from db, add them to repo state and emit them if '
    'repo state is empty, '
    'should only emit all grand prixes if repo state is not empty',
    () async {
      final List<GrandPrixCreator> grandPrixCreators = [
        GrandPrixCreator(
          id: 'gp1',
          name: 'Grand Prix 1',
        ),
        GrandPrixCreator(
          id: 'gp2',
          name: 'Grand Prix 2',
        ),
        GrandPrixCreator(
          id: 'gp3',
          name: 'Grand Prix 3',
        ),
      ];
      final List<GrandPrixDto> grandPrixDtos =
          grandPrixCreators.map((creator) => creator.createDto()).toList();
      final List<GrandPrix> expectedGrandPrixes =
          grandPrixCreators.map((creator) => creator.createEntity()).toList();
      dbGrandPrixService.mockFetchAllGrandPrixes(
        grandPrixDtos: grandPrixDtos,
      );

      final Stream<List<GrandPrix>?> grandPrixes1$ =
          repositoryImpl.getAllGrandPrixes();
      final Stream<List<GrandPrix>?> grandPrixes2$ =
          repositoryImpl.getAllGrandPrixes();

      expect(await grandPrixes1$.first, expectedGrandPrixes);
      expect(await grandPrixes2$.first, expectedGrandPrixes);
      expect(await repositoryImpl.repositoryState$.first, expectedGrandPrixes);
      verify(dbGrandPrixService.fetchAllGrandPrixes).called(1);
    },
  );

  test(
    'getGrandPrixById, '
    'grand prix exists in repository state, '
    'should only emit grand prix if it exists in repo state, '
    'should load grand prix from db, add it to repo state and emit it if it '
    'does not exist in repo state',
    () async {
      const String grandPrixId = 'gp2';
      final GrandPrixCreator grandPrixCreator = GrandPrixCreator(
        id: grandPrixId,
        name: 'Grand Prix 2',
      );
      final GrandPrixDto grandPrixDto = grandPrixCreator.createDto();
      final GrandPrix expectedGrandPrix = grandPrixCreator.createEntity();
      dbGrandPrixService.mockFetchGrandPrixById(grandPrixDto);

      final Stream<GrandPrix?> grandPrix1$ = repositoryImpl.getGrandPrixById(
        grandPrixId: grandPrixId,
      );
      final Stream<GrandPrix?> grandPrix2$ = repositoryImpl.getGrandPrixById(
        grandPrixId: grandPrixId,
      );

      expect(await grandPrix1$.first, expectedGrandPrix);
      expect(await grandPrix2$.first, expectedGrandPrix);
      expect(await repositoryImpl.repositoryState$.first, [expectedGrandPrix]);
      verify(
        () => dbGrandPrixService.fetchGrandPrixById(grandPrixId: grandPrixId),
      ).called(1);
    },
  );
}
