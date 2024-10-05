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

  test(
    'getAllGrandPrixesFromSeason, '
    'should fetch grand prixes from db, add them to repo state and should emit '
    'grand prixes from specified season',
    () async {
      const int season = 2024;
      final List<GrandPrix> existingGrandPrixes = [
        GrandPrixCreator(
          id: 'gp1_$season',
          season: season,
          name: 'grand prix 1',
        ).createEntity(),
        GrandPrixCreator(id: 'gp1_2023', season: 2023).createEntity(),
        GrandPrixCreator(id: 'gp1_2022', season: 2022).createEntity(),
        GrandPrixCreator(id: 'gp2_$season', season: season).createEntity(),
      ];
      final List<GrandPrixCreator> fetchedGrandPrixCreators = [
        GrandPrixCreator(
          id: 'gp1_$season',
          season: season,
          name: 'updated grand prix 1',
        ),
        GrandPrixCreator(id: 'gp3_$season', season: season),
        GrandPrixCreator(id: 'gp4_$season', season: season),
      ];
      final List<GrandPrixDto> fetchedGrandPrixDtos = fetchedGrandPrixCreators
          .map((creator) => creator.createDto())
          .toList();
      final List<GrandPrix> fetchedGrandPrixes = fetchedGrandPrixCreators
          .map((creator) => creator.createEntity())
          .toList();
      final List<GrandPrix> expectedGrandPrixesFromSeason = [
        fetchedGrandPrixes.first,
        existingGrandPrixes.last,
        fetchedGrandPrixes[1],
        fetchedGrandPrixes.last,
      ];
      final List<GrandPrix> expectedUpdatedRepoState = [
        fetchedGrandPrixes.first,
        existingGrandPrixes[1],
        existingGrandPrixes[2],
        existingGrandPrixes.last,
        fetchedGrandPrixes[1],
        fetchedGrandPrixes.last,
      ];
      dbGrandPrixService.mockFetchAllGrandPrixesFromSeason(
        expectedGrandPrixDtos: fetchedGrandPrixDtos,
      );
      when(
        () => grandPrixMapper.mapFromDto(fetchedGrandPrixDtos.first),
      ).thenReturn(fetchedGrandPrixes.first);
      when(
        () => grandPrixMapper.mapFromDto(fetchedGrandPrixDtos[1]),
      ).thenReturn(fetchedGrandPrixes[1]);
      when(
        () => grandPrixMapper.mapFromDto(fetchedGrandPrixDtos.last),
      ).thenReturn(fetchedGrandPrixes.last);
      repositoryImpl.addEntities(existingGrandPrixes);

      final Stream<List<GrandPrix>?> grandPrixes$ =
          repositoryImpl.getAllGrandPrixesFromSeason(season);

      expect(await grandPrixes$.first, expectedGrandPrixesFromSeason);
      expect(
        await repositoryImpl.repositoryState$.first,
        expectedUpdatedRepoState,
      );
      verify(
        () => dbGrandPrixService.fetchAllGrandPrixesFromSeason(season),
      ).called(1);
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
          dbGrandPrixService.mockFetchGrandPrixById(
            expectedGrandPrixDto: grandPrixDto,
          );
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
