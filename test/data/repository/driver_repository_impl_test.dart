import 'package:betgrid/data/firebase/model/driver_dto.dart';
import 'package:betgrid/data/repository/driver/driver_repository_impl.dart';
import 'package:betgrid/model/driver.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

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

  test(
    'getAllDrivers, '
    'repository state is empty, '
    'should fetch drivers from db, add them to repo state and emit them if repo '
    'state is empty, '
    'should only emit all drivers if repo state is not empty',
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
      when(
        () => driverMapper.mapFromDto(driverDtos.first),
      ).thenReturn(expectedDrivers.first);
      when(
        () => driverMapper.mapFromDto(driverDtos[1]),
      ).thenReturn(expectedDrivers[1]);
      when(
        () => driverMapper.mapFromDto(driverDtos.last),
      ).thenReturn(expectedDrivers.last);

      final Stream<List<Driver>> allDrivers1$ = repositoryImpl.getAllDrivers();
      final Stream<List<Driver>> allDrivers2$ = repositoryImpl.getAllDrivers();

      expect(await allDrivers1$.first, expectedDrivers);
      expect(await allDrivers2$.first, expectedDrivers);
      expect(repositoryImpl.repositoryState$, emits(expectedDrivers));
      verify(dbDriverService.fetchAllDrivers).called(1);
    },
  );

  test(
    'getDriverById, '
    'should fetch driver from db, add it to repo state and emit it if driver '
    'does not exist in repo state, '
    'should only emit driver if it exists in repo state',
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
      dbDriverService.mockFetchDriverById(driverDto: expectedDriverDto);
      driverMapper.mockMapFromDto(expectedDriver: expectedDriver);

      final Stream<Driver?> driver1$ = repositoryImpl.getDriverById(
        driverId: expectedDriver.id,
      );
      final Stream<Driver?> driver2$ = repositoryImpl.getDriverById(
        driverId: expectedDriver.id,
      );

      expect(await driver1$.first, expectedDriver);
      expect(await driver2$.first, expectedDriver);
      expect(await repositoryImpl.repositoryState$.first, [expectedDriver]);
      verify(
        () => dbDriverService.fetchDriverById(driverId: expectedDriver.id),
      ).called(1);
    },
  );
}
