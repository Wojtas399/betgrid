import 'package:betgrid/data/firebase/model/driver_dto.dart';
import 'package:betgrid/data/repository/driver/driver_repository_impl.dart';
import 'package:betgrid/model/driver.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../creator/driver_creator.dart';
import '../../mock/data/mapper/mock_driver_mapper.dart';
import '../../mock/firebase/mock_firebase_driver_service.dart';

void main() {
  final dbDriverService = MockFirebaseDriverService();
  final driverMapper = MockDriverMapper();
  late DriverRepositoryImpl repositoryImpl;

  setUp(() {
    repositoryImpl = DriverRepositoryImpl(dbDriverService, driverMapper);
  });

  tearDown(() {
    reset(dbDriverService);
    reset(driverMapper);
  });

  group(
    'getAllDrivers, ',
    () {
      final List<DriverCreator> driverCreators = [
        DriverCreator(
          id: 'd1',
          name: 'Robert',
          surname: 'Kubica',
          number: 100,
          team: DriverCreatorTeam.redBullRacing,
        ),
        DriverCreator(
          id: 'd2',
          name: 'Max',
          surname: 'Verstappen',
          number: 1,
          team: DriverCreatorTeam.redBullRacing,
        ),
        DriverCreator(
          id: 'd3',
          name: 'Luis',
          surname: 'Hamilton',
          number: 44,
          team: DriverCreatorTeam.mercedes,
        ),
      ];

      test(
        'should fetch drivers from db, add them to repo state and emit them if '
        'repo state is empty',
        () async {
          final List<DriverDto> driverDtos =
              driverCreators.map((creator) => creator.createDto()).toList();
          final List<Driver> expectedDrivers =
              driverCreators.map((creator) => creator.createEntity()).toList();
          dbDriverService.mockFetchAllDrivers(allDriverDtos: driverDtos);
          when(
            () => driverMapper.mapFromDto(driverDtos.first),
          ).thenReturn(expectedDrivers.first);
          when(
            () => driverMapper.mapFromDto(driverDtos[1]),
          ).thenReturn(expectedDrivers[1]);
          when(
            () => driverMapper.mapFromDto(driverDtos.last),
          ).thenReturn(expectedDrivers.last);

          final Stream<List<Driver>> allDrivers$ =
              repositoryImpl.getAllDrivers();

          expect(await allDrivers$.first, expectedDrivers);
          expect(repositoryImpl.repositoryState$, emits(expectedDrivers));
          verify(dbDriverService.fetchAllDrivers).called(1);
        },
      );

      test(
        'should only emit all drivers if repo state is not empty',
        () async {
          final List<Driver> existingDrivers =
              driverCreators.map((creator) => creator.createEntity()).toList();
          repositoryImpl.addEntities(existingDrivers);

          final Stream<List<Driver>> allDrivers$ =
              repositoryImpl.getAllDrivers();

          expect(await allDrivers$.first, existingDrivers);
        },
      );
    },
  );

  group(
    'getDriverById, ',
    () {
      const String driverId = 'd1';
      const DriverCreator driverCreator = DriverCreator(
        id: driverId,
        name: 'Juan',
        surname: 'Pablo',
        number: 100,
        team: DriverCreatorTeam.mercedes,
      );
      final List<Driver> existingDrivers = [
        DriverCreator(id: 'd2').createEntity(),
        DriverCreator(id: 'd3').createEntity(),
      ];

      test(
        'should fetch driver from db, add it to repo state and emit it if '
        'driver does not exist in repo state',
        () async {
          final DriverDto expectedDriverDto = driverCreator.createDto();
          final Driver expectedDriver = driverCreator.createEntity();
          dbDriverService.mockFetchDriverById(driverDto: expectedDriverDto);
          driverMapper.mockMapFromDto(expectedDriver: expectedDriver);
          repositoryImpl.addEntities(existingDrivers);

          final Stream<Driver?> driver$ = repositoryImpl.getDriverById(
            driverId: expectedDriver.id,
          );

          expect(await driver$.first, expectedDriver);
          expect(
            await repositoryImpl.repositoryState$.first,
            [...existingDrivers, expectedDriver],
          );
          verify(
            () => dbDriverService.fetchDriverById(driverId: expectedDriver.id),
          ).called(1);
        },
      );

      test(
        'should only emit driver if it already exists in repo state',
        () async {
          final Driver expectedDriver = driverCreator.createEntity();
          repositoryImpl.addEntities(
            [...existingDrivers, expectedDriver],
          );

          final Stream<Driver?> driver$ = repositoryImpl.getDriverById(
            driverId: expectedDriver.id,
          );

          expect(await driver$.first, expectedDriver);
        },
      );
    },
  );
}
