import 'package:betgrid/data/firebase/model/season_grand_prix_dto.dart';
import 'package:betgrid/data/repository/season_grand_prix/season_grand_prix_repository_impl.dart';
import 'package:betgrid/model/season_grand_prix.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../creator/season_grand_prix_creator.dart';
import '../../mock/data/firebase/mock_firebase_season_grand_prix_service.dart';
import '../../mock/data/mapper/mock_season_grand_prix_mapper.dart';

void main() {
  final firebaseSeasonGrandPrixService = MockFirebaseSeasonGrandPrixService();
  final seasonGrandPrixMapper = MockSeasonGrandPrixMapper();
  late SeasonGrandPrixRepositoryImpl repositoryImpl;

  setUp(() {
    repositoryImpl = SeasonGrandPrixRepositoryImpl(
      firebaseSeasonGrandPrixService,
      seasonGrandPrixMapper,
    );
  });

  tearDown(() {
    reset(firebaseSeasonGrandPrixService);
    reset(seasonGrandPrixMapper);
  });

  test(
    'getAllSeasonGrandPrixesFromSeason, '
    'should fetch all SeasonGrandPrixes from given season, should add new or '
    'update existing ones in repo state and should emit all SeasonGrandPrixes '
    'with matching season from repo state',
    () async {
      const int season = 2024;
      final List<SeasonGrandPrix> existingSeasonGrandPrixes = [
        SeasonGrandPrixCreator(id: 'sgp1', season: 2023).createEntity(),
        SeasonGrandPrixCreator(id: 'sgp2', season: season).createEntity(),
        SeasonGrandPrixCreator(id: 'sgp3', season: season).createEntity(),
        SeasonGrandPrixCreator(id: 'sgp4', season: 2022).createEntity(),
      ];
      final List<SeasonGrandPrixCreator> fetchedSeasonGrandPrixCreators = [
        SeasonGrandPrixCreator(id: 'sgp3', season: season),
        SeasonGrandPrixCreator(id: 'sgp6', season: season),
        SeasonGrandPrixCreator(id: 'sgp7', season: season),
      ];
      final fetchedSeasonGrandPrixDtos = fetchedSeasonGrandPrixCreators
          .map((creator) => creator.createDto())
          .toList();
      final fetchedSeasonGrandPrixes = fetchedSeasonGrandPrixCreators
          .map((creator) => creator.createEntity())
          .toList();
      final List<SeasonGrandPrix> expectedSeasonGrandPrixes = [
        existingSeasonGrandPrixes[1],
        ...fetchedSeasonGrandPrixes,
      ];
      final List<SeasonGrandPrix> expectedRepoState = [
        existingSeasonGrandPrixes.first,
        existingSeasonGrandPrixes[1],
        fetchedSeasonGrandPrixes.first,
        existingSeasonGrandPrixes.last,
        fetchedSeasonGrandPrixes[1],
        fetchedSeasonGrandPrixes.last,
      ];
      firebaseSeasonGrandPrixService.mockFetchAllSeasonGrandPrixesFromSeason(
        expectedSeasonGrandPrixDtos: fetchedSeasonGrandPrixDtos,
      );
      when(
        () => seasonGrandPrixMapper.mapFromDto(
          fetchedSeasonGrandPrixDtos.first,
        ),
      ).thenReturn(fetchedSeasonGrandPrixes.first);
      when(
        () => seasonGrandPrixMapper.mapFromDto(
          fetchedSeasonGrandPrixDtos[1],
        ),
      ).thenReturn(fetchedSeasonGrandPrixes[1]);
      when(
        () => seasonGrandPrixMapper.mapFromDto(
          fetchedSeasonGrandPrixDtos.last,
        ),
      ).thenReturn(fetchedSeasonGrandPrixes.last);
      repositoryImpl.addEntities(existingSeasonGrandPrixes);

      final Stream<List<SeasonGrandPrix>> seasonGrandPrixes$ =
          repositoryImpl.getAllSeasonGrandPrixesFromSeason(season);

      expect(await seasonGrandPrixes$.first, expectedSeasonGrandPrixes);
      expect(await repositoryImpl.repositoryState$.first, expectedRepoState);
      verify(
        () => firebaseSeasonGrandPrixService
            .fetchAllSeasonGrandPrixesFromSeason(season),
      ).called(1);
    },
  );

  group(
    'getSeasonGrandPrixById, ',
    () {
      const String id = 'sgp1';
      final SeasonGrandPrixCreator seasonGrandPrixCreator =
          SeasonGrandPrixCreator(id: id);
      final List<SeasonGrandPrix> existingSeasonGrandPrixes = [
        SeasonGrandPrixCreator(id: 'sgp2').createEntity(),
        SeasonGrandPrixCreator(id: 'sgp3').createEntity(),
        SeasonGrandPrixCreator(id: 'sgp4').createEntity(),
      ];

      test(
        'should fetch season grand prix from db, add it to repo state and emit '
        'it if matching season grand prix does not exist in repo state',
        () async {
          final SeasonGrandPrixDto expectedSeasonGrandPrixDto =
              seasonGrandPrixCreator.createDto();
          final SeasonGrandPrix expectedSeasonGrandPrix =
              seasonGrandPrixCreator.createEntity();
          firebaseSeasonGrandPrixService.mockFetchSeasonGrandPrixById(
            expectedSeasonGrandPrixDto: expectedSeasonGrandPrixDto,
          );
          seasonGrandPrixMapper.mockMapFromDto(
            expectedSeasonGrandPrix: expectedSeasonGrandPrix,
          );
          repositoryImpl.addEntities(existingSeasonGrandPrixes);

          final Stream<SeasonGrandPrix?> seasonGrandPrix$ =
              repositoryImpl.getSeasonGrandPrixById(id);

          expect(await seasonGrandPrix$.first, expectedSeasonGrandPrix);
          expect(
            await repositoryImpl.repositoryState$.first,
            [...existingSeasonGrandPrixes, expectedSeasonGrandPrix],
          );
          verify(
            () => firebaseSeasonGrandPrixService.fetchSeasonGrandPrixById(id),
          ).called(1);
        },
      );

      test(
        'should only emit season grand prix if season grand prix with matching '
        'id already exists in repo state',
        () async {
          final SeasonGrandPrix expectedSeasonGrandPrix =
              seasonGrandPrixCreator.createEntity();
          repositoryImpl.addEntities(
            [...existingSeasonGrandPrixes, expectedSeasonGrandPrix],
          );

          final Stream<SeasonGrandPrix?> seasonGrandPrix$ =
              repositoryImpl.getSeasonGrandPrixById(id);

          expect(await seasonGrandPrix$.first, expectedSeasonGrandPrix);
        },
      );
    },
  );
}
