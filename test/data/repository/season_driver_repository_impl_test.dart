import 'package:betgrid/data/firebase/model/season_driver_dto.dart';
import 'package:betgrid/data/repository/season_driver/season_driver_repository_impl.dart';
import 'package:betgrid/model/season_driver.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../creator/season_driver_creator.dart';
import '../../mock/data/firebase/mock_firebase_season_driver_service.dart';
import '../../mock/data/mapper/mock_season_driver_mapper.dart';

void main() {
  final firebaseSeasonDriverService = MockFirebaseSeasonDriverService();
  final seasonDriverMapper = MockSeasonDriverMapper();
  late SeasonDriverRepositoryImpl repositoryImpl;

  setUp(() {
    repositoryImpl = SeasonDriverRepositoryImpl(
      firebaseSeasonDriverService,
      seasonDriverMapper,
    );
  });

  tearDown(() {
    reset(firebaseSeasonDriverService);
    reset(seasonDriverMapper);
  });

  test(
    'getAllSeasonDriversFromSeason, '
    'should fetch all SeasonDrivers from given season, should add new or '
    'update existing ones in repo state and should emit all SeasonDrivers with '
    'matching season from repo state',
    () async {
      const int season = 2024;
      final List<SeasonDriver> existingSeasonDrivers = [
        const SeasonDriverCreator(id: 'sd1', season: 2023).createEntity(),
        const SeasonDriverCreator(id: 'sd2', season: season).createEntity(),
        const SeasonDriverCreator(
          id: 'sd3',
          season: season,
          teamId: 'mercedes',
        ).createEntity(),
        const SeasonDriverCreator(id: 'sd4', season: 2023).createEntity(),
      ];
      const List<SeasonDriverCreator> fetchedSeasonDriverCreators = [
        SeasonDriverCreator(id: 'sd3', season: season, teamId: 'rb'),
        SeasonDriverCreator(id: 'sd6', season: season),
        SeasonDriverCreator(id: 'sd7', season: season),
      ];
      final fetchedSeasonDriverDtos = fetchedSeasonDriverCreators
          .map((creator) => creator.createDto())
          .toList();
      final fetchedSeasonDrivers = fetchedSeasonDriverCreators
          .map((creator) => creator.createEntity())
          .toList();
      final List<SeasonDriver> expectedSeasonDrivers = [
        existingSeasonDrivers[1],
        ...fetchedSeasonDrivers,
      ];
      final List<SeasonDriver> expectedRepoState = [
        existingSeasonDrivers.first,
        existingSeasonDrivers[1],
        fetchedSeasonDrivers.first,
        existingSeasonDrivers.last,
        fetchedSeasonDrivers[1],
        fetchedSeasonDrivers.last,
      ];
      firebaseSeasonDriverService.mockFetchAllSeasonDriversFromSeason(
        expectedSeasonDriverDtos: fetchedSeasonDriverDtos,
      );
      when(
        () => seasonDriverMapper.mapFromDto(fetchedSeasonDriverDtos.first),
      ).thenReturn(fetchedSeasonDrivers.first);
      when(
        () => seasonDriverMapper.mapFromDto(fetchedSeasonDriverDtos[1]),
      ).thenReturn(fetchedSeasonDrivers[1]);
      when(
        () => seasonDriverMapper.mapFromDto(fetchedSeasonDriverDtos.last),
      ).thenReturn(fetchedSeasonDrivers.last);
      repositoryImpl.addEntities(existingSeasonDrivers);

      final Stream<List<SeasonDriver>> seasonDrivers$ =
          repositoryImpl.getAllSeasonDriversFromSeason(season);

      expect(await seasonDrivers$.first, expectedSeasonDrivers);
      expect(await repositoryImpl.repositoryState$.first, expectedRepoState);
      verify(
        () => firebaseSeasonDriverService.fetchAllSeasonDriversFromSeason(
          season,
        ),
      ).called(1);
    },
  );

  group(
    'getSeasonDriverById, ',
    () {
      const String id = 'sd1';
      const SeasonDriverCreator seasonDriverCreator =
          SeasonDriverCreator(id: id);
      final List<SeasonDriver> existingSeasonDrivers = [
        const SeasonDriverCreator(id: 'sd2').createEntity(),
        const SeasonDriverCreator(id: 'sd3').createEntity(),
        const SeasonDriverCreator(id: 'sd4').createEntity(),
      ];

      test(
        'should fetch season driver from db, add it to repo state and emit it '
        'if matching season driver does not exist in repo state',
        () async {
          final SeasonDriverDto expectedSeasonDriverDto =
              seasonDriverCreator.createDto();
          final SeasonDriver expectedSeasonDriver =
              seasonDriverCreator.createEntity();
          firebaseSeasonDriverService.mockFetchSeasonDriverById(
            expectedSeasonDriverDto: expectedSeasonDriverDto,
          );
          seasonDriverMapper.mockMapFromDto(
            expectedSeasonDriver: expectedSeasonDriver,
          );
          repositoryImpl.addEntities(existingSeasonDrivers);

          final Stream<SeasonDriver?> seasonDriver$ =
              repositoryImpl.getSeasonDriverById(id);

          expect(await seasonDriver$.first, expectedSeasonDriver);
          expect(
            await repositoryImpl.repositoryState$.first,
            [...existingSeasonDrivers, expectedSeasonDriver],
          );
          verify(
            () => firebaseSeasonDriverService.fetchSeasonDriverById(id),
          ).called(1);
        },
      );

      test(
        'should only emit season driver if season driver with matching id '
        'already exists in repo state',
        () async {
          final SeasonDriver expectedSeasonDriver =
              seasonDriverCreator.createEntity();
          repositoryImpl.addEntities(
            [...existingSeasonDrivers, expectedSeasonDriver],
          );

          final Stream<SeasonDriver?> seasonDriver$ =
              repositoryImpl.getSeasonDriverById(id);

          expect(await seasonDriver$.first, expectedSeasonDriver);
        },
      );
    },
  );
}
