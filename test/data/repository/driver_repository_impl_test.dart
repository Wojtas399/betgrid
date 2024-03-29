import 'package:betgrid/data/repository/driver/driver_repository_impl.dart';
import 'package:betgrid/firebase/model/driver_dto/driver_dto.dart';
import 'package:betgrid/firebase/service/firebase_driver_service.dart';
import 'package:betgrid/model/driver.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../../mock/firebase/mock_firebase_driver_service.dart';

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
    'loadAllDrivers, '
    'repository state is not set, '
    'should load drivers from db, add them to repo and return them',
    () async {
      final List<DriverDto> driverDtos = [
        const DriverDto(
          id: 'd1',
          name: 'Robert',
          surname: 'Kubica',
          number: 1,
          team: TeamDto.ferrari,
        ),
        const DriverDto(
          id: 'd2',
          name: 'Max',
          surname: 'Verstappen',
          number: 2,
          team: TeamDto.redBullRacing,
        ),
      ];
      final List<Driver> expectedDrivers = [
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
      dbDriverService.mockLoadAllDrivers(driverDtos);

      final List<Driver>? drivers = await repositoryImpl.loadAllDrivers();

      expect(drivers, expectedDrivers);
      expect(
        repositoryImpl.repositoryState$,
        emitsInOrder([expectedDrivers]),
      );
      verify(dbDriverService.loadAllDrivers).called(1);
    },
  );

  test(
    'loadAllDrivers, '
    'repository state is empty array, '
    'should load drivers from db, add them to repo and return them',
    () async {
      final List<DriverDto> driverDtos = [
        const DriverDto(
          id: 'd1',
          name: 'Robert',
          surname: 'Kubica',
          number: 1,
          team: TeamDto.ferrari,
        ),
        const DriverDto(
          id: 'd2',
          name: 'Max',
          surname: 'Verstappen',
          number: 2,
          team: TeamDto.redBullRacing,
        ),
      ];
      final List<Driver> expectedDrivers = [
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
      dbDriverService.mockLoadAllDrivers(driverDtos);
      repositoryImpl = DriverRepositoryImpl(initialData: []);

      final List<Driver>? drivers = await repositoryImpl.loadAllDrivers();

      expect(drivers, expectedDrivers);
      expect(
        repositoryImpl.repositoryState$,
        emitsInOrder([expectedDrivers]),
      );
      verify(dbDriverService.loadAllDrivers).called(1);
    },
  );

  test(
    'loadAllDrivers, '
    'repository state contains drivers, '
    'should only emit drivers from repository state',
    () async {
      final List<Driver> expectedDrivers = [
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
      repositoryImpl = DriverRepositoryImpl(initialData: expectedDrivers);

      final List<Driver>? drivers = await repositoryImpl.loadAllDrivers();

      expect(drivers, expectedDrivers);
      expect(repositoryImpl.repositoryState$, emits(expectedDrivers));
      verifyNever(dbDriverService.loadAllDrivers);
    },
  );
}
