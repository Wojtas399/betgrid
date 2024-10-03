import 'package:betgrid/data/firebase/model/grand_prix_dto.dart';
import 'package:betgrid/data/repository/grand_prix/grand_prix_repository_impl.dart';
import 'package:betgrid/model/grand_prix.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../creator/grand_prix_creator.dart';
import '../../mock/data/mapper/mock_grand_prix_mapper.dart';
import '../../mock/firebase/mock_firebase_grand_prix_service.dart';

void main() {
  final dbGrandPrixService = MockFirebaseGrandPrixService();
  final grandPrixMapper = MockGrandPrixMapper();
  late GrandPrixRepositoryImpl repositoryImpl;

  setUp(() {
    repositoryImpl = GrandPrixRepositoryImpl(
      dbGrandPrixService,
      grandPrixMapper,
    );
  });

  tearDown(() {
    reset(dbGrandPrixService);
    reset(grandPrixMapper);
  });

  group(
    'getAllGrandPrixes, ',
    () {
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

      test(
        'should only emit all grand prixes if repo state is not empty',
        () async {
          final List<GrandPrix> existingGrandPrixes = grandPrixCreators
              .map((creator) => creator.createEntity())
              .toList();
          repositoryImpl.addEntities(existingGrandPrixes);

          final Stream<List<GrandPrix>?> grandPrixes$ =
              repositoryImpl.getAllGrandPrixes();

          expect(await grandPrixes$.first, existingGrandPrixes);
        },
      );

      test(
        'should fetch grand prixes from db, add them to repo state and emit '
        'them if repo state is empty',
        () async {
          final List<GrandPrixDto> grandPrixDtos =
              grandPrixCreators.map((creator) => creator.createDto()).toList();
          final List<GrandPrix> expectedGrandPrixes = grandPrixCreators
              .map((creator) => creator.createEntity())
              .toList();
          dbGrandPrixService.mockFetchAllGrandPrixes(
            grandPrixDtos: grandPrixDtos,
          );
          when(
            () => grandPrixMapper.mapFromDto(grandPrixDtos.first),
          ).thenReturn(expectedGrandPrixes.first);
          when(
            () => grandPrixMapper.mapFromDto(grandPrixDtos[1]),
          ).thenReturn(expectedGrandPrixes[1]);
          when(
            () => grandPrixMapper.mapFromDto(grandPrixDtos.last),
          ).thenReturn(expectedGrandPrixes.last);

          final Stream<List<GrandPrix>?> grandPrixes$ =
              repositoryImpl.getAllGrandPrixes();

          expect(await grandPrixes$.first, expectedGrandPrixes);
          expect(
            await repositoryImpl.repositoryState$.first,
            expectedGrandPrixes,
          );
          verify(dbGrandPrixService.fetchAllGrandPrixes).called(1);
        },
      );
    },
  );

  group(
    'getGrandPrixById, ',
    () {
      const String grandPrixId = 'gp2';
      final GrandPrixCreator grandPrixCreator = GrandPrixCreator(
        id: grandPrixId,
        name: 'Grand Prix 2',
      );
      final List<GrandPrix> existingGrandPrixes = [
        GrandPrixCreator(id: 'gp1').createEntity(),
        GrandPrixCreator(id: 'gp3').createEntity(),
      ];

      test(
        'should only emit grand prix if it already exists in repo state',
        () async {
          final GrandPrix expectedGrandPrix = grandPrixCreator.createEntity();
          repositoryImpl.addEntities([
            ...existingGrandPrixes,
            expectedGrandPrix,
          ]);

          final Stream<GrandPrix?> grandPrix$ = repositoryImpl.getGrandPrixById(
            grandPrixId: grandPrixId,
          );

          expect(await grandPrix$.first, expectedGrandPrix);
        },
      );

      test(
        'should fetch grand prix from db, add it to repo state and emit it if '
        'it does not exist in repo state',
        () async {
          final GrandPrixDto grandPrixDto = grandPrixCreator.createDto();
          final GrandPrix expectedGrandPrix = grandPrixCreator.createEntity();
          dbGrandPrixService.mockFetchGrandPrixById(grandPrixDto);
          grandPrixMapper.mockMapFromDto(expectedGrandPrix: expectedGrandPrix);
          repositoryImpl.addEntities(existingGrandPrixes);

          final Stream<GrandPrix?> grandPrix$ = repositoryImpl.getGrandPrixById(
            grandPrixId: grandPrixId,
          );

          expect(await grandPrix$.first, expectedGrandPrix);
          expect(
            await repositoryImpl.repositoryState$.first,
            [...existingGrandPrixes, expectedGrandPrix],
          );
          verify(
            () => dbGrandPrixService.fetchGrandPrixById(
              grandPrixId: grandPrixId,
            ),
          ).called(1);
        },
      );
    },
  );
}
