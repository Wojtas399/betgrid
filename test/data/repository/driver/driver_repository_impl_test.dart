import 'package:betgrid/data/repository/driver/driver_repository_impl.dart';
import 'package:betgrid/firebase/model/driver_dto/driver_dto.dart';
import 'package:betgrid/firebase/service/firebase_driver_service.dart';
import 'package:betgrid/model/driver.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mock/firebase/mock_firebase_driver_service.dart';

void main() {
  final dbDriverService = MockFirebaseDriverService();
  late DriverRepositoryImpl repositoryImpl;

  setUpAll(() {
    GetIt.I.registerFactory<FirebaseDriverService>(() => dbDriverService);
  });

  setUp(() {
    repositoryImpl = DriverRepositoryImpl();
  });

  tearDown(() {
    reset(dbDriverService);
  });

  test(
    'getAllDrivers, '
    'repository state is not initialized, '
    'should fetch drivers from db, add them to repo and emit them',
    () async {
      const List<DriverDto> driverDtos = [
        DriverDto(
          id: 'd1',
          name: 'Robert',
          surname: 'Kubica',
          number: 100,
          team: TeamDto.redBullRacing,
        ),
        DriverDto(
          id: 'd2',
          name: 'Max',
          surname: 'Verstappen',
          number: 1,
          team: TeamDto.redBullRacing,
        ),
        DriverDto(
          id: 'd3',
          name: 'Luis',
          surname: 'Hamilton',
          number: 44,
          team: TeamDto.mercedes,
        ),
      ];
      const List<Driver> expectedDrivers = [
        Driver(
          id: 'd1',
          name: 'Robert',
          surname: 'Kubica',
          number: 100,
          team: Team.redBullRacing,
        ),
        Driver(
          id: 'd2',
          name: 'Max',
          surname: 'Verstappen',
          number: 1,
          team: Team.redBullRacing,
        ),
        Driver(
          id: 'd3',
          name: 'Luis',
          surname: 'Hamilton',
          number: 44,
          team: Team.mercedes,
        ),
      ];
      dbDriverService.mockFetchAllDrivers(allDriverDtos: driverDtos);

      final Stream<List<Driver>> allDrivers$ = repositoryImpl.getAllDrivers();

      expect(await allDrivers$.first, expectedDrivers);
      expect(repositoryImpl.repositoryState$, emits(expectedDrivers));
      verify(dbDriverService.fetchAllDrivers).called(1);
    },
  );

  test(
    'getAllDrivers, '
    'repository state is empty, '
    'should fetch drivers from db, add them to repo and emit them',
    () async {
      const List<DriverDto> driverDtos = [
        DriverDto(
          id: 'd1',
          name: 'Robert',
          surname: 'Kubica',
          number: 100,
          team: TeamDto.redBullRacing,
        ),
        DriverDto(
          id: 'd2',
          name: 'Max',
          surname: 'Verstappen',
          number: 1,
          team: TeamDto.redBullRacing,
        ),
        DriverDto(
          id: 'd3',
          name: 'Luis',
          surname: 'Hamilton',
          number: 44,
          team: TeamDto.mercedes,
        ),
      ];
      const List<Driver> expectedDrivers = [
        Driver(
          id: 'd1',
          name: 'Robert',
          surname: 'Kubica',
          number: 100,
          team: Team.redBullRacing,
        ),
        Driver(
          id: 'd2',
          name: 'Max',
          surname: 'Verstappen',
          number: 1,
          team: Team.redBullRacing,
        ),
        Driver(
          id: 'd3',
          name: 'Luis',
          surname: 'Hamilton',
          number: 44,
          team: Team.mercedes,
        ),
      ];
      dbDriverService.mockFetchAllDrivers(allDriverDtos: driverDtos);
      repositoryImpl = DriverRepositoryImpl(initialData: []);

      final Stream<List<Driver>> allDrivers$ = repositoryImpl.getAllDrivers();

      expect(await allDrivers$.first, expectedDrivers);
      expect(repositoryImpl.repositoryState$, emits(expectedDrivers));
      verify(dbDriverService.fetchAllDrivers).called(1);
    },
  );

  test(
    'getAllDrivers, '
    'repository state contains drivers, '
    'should only emit all drivers from repository state',
    () async {
      const List<Driver> expectedDrivers = [
        Driver(
          id: 'd1',
          name: 'Robert',
          surname: 'Kubica',
          number: 100,
          team: Team.redBullRacing,
        ),
        Driver(
          id: 'd2',
          name: 'Max',
          surname: 'Verstappen',
          number: 1,
          team: Team.redBullRacing,
        ),
        Driver(
          id: 'd3',
          name: 'Luis',
          surname: 'Hamilton',
          number: 44,
          team: Team.mercedes,
        ),
      ];
      repositoryImpl = DriverRepositoryImpl(initialData: expectedDrivers);

      final Stream<List<Driver>> allDrivers$ = repositoryImpl.getAllDrivers();

      expect(await allDrivers$.first, expectedDrivers);
      verifyNever(dbDriverService.fetchAllDrivers);
    },
  );

  test(
    'getDriverById, '
    'driver exists in repository state, '
    'should emit existing driver',
    () {
      final List<Driver> existingDrivers = [
        const Driver(
          id: 'd1',
          name: 'Robert',
          surname: 'Kubica',
          number: 1,
          team: Team.ferrari,
        ),
        const Driver(
          id: 'd2',
          name: 'Max',
          surname: 'Verstappen',
          number: 2,
          team: Team.redBullRacing,
        ),
      ];
      final expectedDriver = existingDrivers.first;
      repositoryImpl = DriverRepositoryImpl(initialData: existingDrivers);

      final Stream<Driver?> driver$ = repositoryImpl.getDriverById(
        driverId: expectedDriver.id,
      );

      expect(driver$, emits(expectedDriver));
    },
  );

  test(
    'getDriverById, '
    'driver does not exist in repository state, '
    'should fetch driver from db, add it to repo state and emit it',
    () async {
      const DriverDto expectedDriverDto = DriverDto(
        id: 'd3',
        name: 'Juan',
        surname: 'Pablo',
        number: 100,
        team: TeamDto.mercedes,
      );
      const Driver expectedDriver = Driver(
        id: 'd3',
        name: 'Juan',
        surname: 'Pablo',
        number: 100,
        team: Team.mercedes,
      );
      final List<Driver> existingDrivers = [
        const Driver(
          id: 'd1',
          name: 'Robert',
          surname: 'Kubica',
          number: 1,
          team: Team.ferrari,
        ),
        const Driver(
          id: 'd2',
          name: 'Max',
          surname: 'Verstappen',
          number: 2,
          team: Team.redBullRacing,
        ),
      ];
      dbDriverService.mockFetchDriverById(driverDto: expectedDriverDto);
      repositoryImpl = DriverRepositoryImpl(initialData: existingDrivers);

      final Stream<Driver?> driver$ = repositoryImpl.getDriverById(
        driverId: expectedDriver.id,
      );

      expect(await driver$.first, expectedDriver);
      expect(
        repositoryImpl.repositoryState$,
        emits([...existingDrivers, expectedDriver]),
      );
      verify(
        () => dbDriverService.fetchDriverById(driverId: expectedDriver.id),
      ).called(1);
    },
  );
}