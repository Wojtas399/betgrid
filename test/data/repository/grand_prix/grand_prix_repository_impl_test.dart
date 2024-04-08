import 'package:betgrid/data/repository/grand_prix/grand_prix_repository_impl.dart';
import 'package:betgrid/firebase/model/grand_prix_dto/grand_prix_dto.dart';
import 'package:betgrid/model/grand_prix.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/grand_prix_creator.dart';
import '../../../creator/grand_prix_dto_creator.dart';
import '../../../mock/firebase/mock_firebase_grand_prix_service.dart';

void main() {
  final dbGrandPrixService = MockFirebaseGrandPrixService();
  late GrandPrixRepositoryImpl repositoryImpl;

  setUp(() {
    repositoryImpl = GrandPrixRepositoryImpl(
      firebaseGrandPrixService: dbGrandPrixService,
    );
  });

  tearDown(() {
    reset(dbGrandPrixService);
  });

  test(
    'loadAllGrandPrixes, '
    'repository state is empty, '
    'should load grand prixes from db, add them to repo and emit them',
    () async {
      final List<GrandPrixDto> grandPrixDtos = [
        createGrandPrixDto(
          id: 'gp1',
          name: 'Grand Prix 1',
        ),
        createGrandPrixDto(
          id: 'gp2',
          name: 'Grand Prix 2',
        ),
        createGrandPrixDto(
          id: 'gp3',
          name: 'Grand Prix 3',
        ),
      ];
      final List<GrandPrix> expectedGrandPrixes = [
        createGrandPrix(
          id: 'gp1',
          name: 'Grand Prix 1',
        ),
        createGrandPrix(
          id: 'gp2',
          name: 'Grand Prix 2',
        ),
        createGrandPrix(
          id: 'gp3',
          name: 'Grand Prix 3',
        ),
      ];
      dbGrandPrixService.mockLoadAllGrandPrixes(
        grandPrixDtos: grandPrixDtos,
      );

      final Stream<List<GrandPrix>?> grandPrixes$ =
          repositoryImpl.getAllGrandPrixes();

      expect(await grandPrixes$.first, expectedGrandPrixes);
      expect(repositoryImpl.repositoryState$, emits(expectedGrandPrixes));
      verify(dbGrandPrixService.loadAllGrandPrixes).called(1);
    },
  );

  test(
    'loadAllGrandPrixes, '
    'repository state contains grand prixes, '
    'should only emit all grand prixes from repository state',
    () async {
      final List<GrandPrix> expectedGrandPrixes = [
        createGrandPrix(
          id: 'gp1',
          name: 'Grand Prix 1',
        ),
        createGrandPrix(
          id: 'gp2',
          name: 'Grand Prix 2',
        ),
        createGrandPrix(
          id: 'gp3',
          name: 'Grand Prix 3',
        ),
      ];
      repositoryImpl = GrandPrixRepositoryImpl(
        firebaseGrandPrixService: dbGrandPrixService,
        initialData: expectedGrandPrixes,
      );

      final Stream<List<GrandPrix>?> grandPrixes$ =
          repositoryImpl.getAllGrandPrixes();

      expect(await grandPrixes$.first, expectedGrandPrixes);
      verifyNever(dbGrandPrixService.loadAllGrandPrixes);
    },
  );

  test(
    'getGrandPrixById, '
    'grand prix exists in repository state, '
    'should emit grand prix from repository state',
    () async {
      const String grandPrixId = 'gp2';
      final List<GrandPrix> existingGrandPrixes = [
        createGrandPrix(
          id: 'gp1',
          name: 'Grand Prix 1',
        ),
        createGrandPrix(
          id: grandPrixId,
          name: 'Grand Prix 2',
        ),
        createGrandPrix(
          id: 'gp3',
          name: 'Grand Prix 3',
        ),
      ];
      repositoryImpl = GrandPrixRepositoryImpl(
        firebaseGrandPrixService: dbGrandPrixService,
        initialData: existingGrandPrixes,
      );

      final Stream<GrandPrix?> grandPrix$ = repositoryImpl.getGrandPrixById(
        grandPrixId: grandPrixId,
      );

      expect(grandPrix$, emits(existingGrandPrixes[1]));
    },
  );

  test(
    'getGrandPrixById, '
    'grand prix does not exist in repository state, '
    'should load grand prix from db, add it to repository state and emit it',
    () async {
      const String grandPrixId = 'gp2';
      final GrandPrixDto grandPrixDto = createGrandPrixDto(
        id: grandPrixId,
        name: 'Grand Prix 2',
      );
      final GrandPrix expectedGrandPrix = createGrandPrix(
        id: grandPrixId,
        name: 'Grand Prix 2',
      );
      final List<GrandPrix> existingGrandPrixes = [
        createGrandPrix(
          id: 'gp1',
          name: 'Grand Prix 1',
        ),
        createGrandPrix(
          id: 'gp3',
          name: 'Grand Prix 3',
        ),
      ];
      dbGrandPrixService.mockLoadGrandPrixById(grandPrixDto);
      repositoryImpl = GrandPrixRepositoryImpl(
        firebaseGrandPrixService: dbGrandPrixService,
        initialData: existingGrandPrixes,
      );

      final Stream<GrandPrix?> grandPrix$ = repositoryImpl.getGrandPrixById(
        grandPrixId: grandPrixId,
      );

      expect(await grandPrix$.first, expectedGrandPrix);
      expect(
        repositoryImpl.repositoryState$,
        emits([
          ...existingGrandPrixes,
          expectedGrandPrix,
        ]),
      );
      verify(
        () => dbGrandPrixService.loadGrandPrixById(grandPrixId: grandPrixId),
      ).called(1);
    },
  );
}
