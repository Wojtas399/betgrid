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
    'getAllDrivers, '
    'repository state is not set, '
    'should load drivers from db, add them to repo and emit them',
    () async {
      final List<DriverDto> driverDtos = [
        const DriverDto(
          id: 'd1',
          name: 'Robert',
          surname: 'Kubica',
          team: TeamDto.ferrari,
        ),
        const DriverDto(
          id: 'd2',
          name: 'Max',
          surname: 'Verstappen',
          team: TeamDto.redBullRacing,
        ),
      ];
      final List<Driver> expectedDrivers = [
        const Driver(
          id: 'd1',
          name: 'Robert',
          surname: 'Kubica',
          team: Team.ferrari,
        ),
        const Driver(
          id: 'd2',
          name: 'Max',
          surname: 'Verstappen',
          team: Team.redBullRacing,
        ),
      ];
      dbDriverService.mockLoadAllDrivers(driverDtos);

      final Stream<List<Driver>?> drivers = repositoryImpl.getAllDrivers();

      expect(drivers, emits(expectedDrivers));
      expect(
        repositoryImpl.repositoryState$,
        emitsInOrder([null, expectedDrivers]),
      );
      await repositoryImpl.repositoryState$.first;
      verify(dbDriverService.loadAllDrivers).called(1);
    },
  );

  test(
    'getAllDrivers, '
    'repository state is empty array, '
    'should load drivers from db, add them to repo and emit them',
    () async {
      final List<DriverDto> driverDtos = [
        const DriverDto(
          id: 'd1',
          name: 'Robert',
          surname: 'Kubica',
          team: TeamDto.ferrari,
        ),
        const DriverDto(
          id: 'd2',
          name: 'Max',
          surname: 'Verstappen',
          team: TeamDto.redBullRacing,
        ),
      ];
      final List<Driver> expectedDrivers = [
        const Driver(
          id: 'd1',
          name: 'Robert',
          surname: 'Kubica',
          team: Team.ferrari,
        ),
        const Driver(
          id: 'd2',
          name: 'Max',
          surname: 'Verstappen',
          team: Team.redBullRacing,
        ),
      ];
      dbDriverService.mockLoadAllDrivers(driverDtos);
      repositoryImpl = DriverRepositoryImpl(initialData: []);

      final Stream<List<Driver>?> drivers = repositoryImpl.getAllDrivers();

      expect(drivers, emits(expectedDrivers));
      expect(
        repositoryImpl.repositoryState$,
        emitsInOrder([[], expectedDrivers]),
      );
      await repositoryImpl.repositoryState$.first;
      verify(dbDriverService.loadAllDrivers).called(1);
    },
  );

  test(
    'getAllDrivers, '
    'repository state contains drivers, '
    'should only emit drivers from repository state',
    () async {
      final List<Driver> expectedDrivers = [
        const Driver(
          id: 'd1',
          name: 'Robert',
          surname: 'Kubica',
          team: Team.ferrari,
        ),
        const Driver(
          id: 'd2',
          name: 'Max',
          surname: 'Verstappen',
          team: Team.redBullRacing,
        ),
      ];
      repositoryImpl = DriverRepositoryImpl(initialData: expectedDrivers);

      final Stream<List<Driver>?> drivers = repositoryImpl.getAllDrivers();

      expect(drivers, emits(expectedDrivers));
      expect(repositoryImpl.repositoryState$, emits(expectedDrivers));
      await repositoryImpl.repositoryState$.first;
      verifyNever(dbDriverService.loadAllDrivers);
    },
  );
}
