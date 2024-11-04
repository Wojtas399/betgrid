import 'package:betgrid/model/driver.dart';
import 'package:betgrid/model/driver_personal_data.dart';
import 'package:betgrid/model/season_driver.dart';
import 'package:betgrid/model/team.dart';
import 'package:betgrid/use_case/get_driver_based_on_season_driver_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../creator/season_driver_creator.dart';
import '../creator/team_creator.dart';
import '../mock/data/repository/mock_driver_personal_data_repository.dart';
import '../mock/data/repository/mock_team_repository.dart';

void main() {
  final driverPersonalDataRepository = MockDriverPersonalDataRepository();
  final teamRepository = MockTeamRepository();
  final useCase = GetDriverBasedOnSeasonDriverUseCase(
    driverPersonalDataRepository,
    teamRepository,
  );
  final SeasonDriver seasonDriver = const SeasonDriverCreator(
    id: 'sd1',
    driverId: 'd1',
    driverNumber: 1,
  ).createEntity();
  final DriverPersonalData driverPersonalData = DriverPersonalData(
    id: seasonDriver.driverId,
    name: 'Max',
    surname: 'Verstappen',
  );
  final Team team = const TeamCreator(
    name: 'Red Bull Racing',
    hexColor: '#FFFFFF',
  ).createEntity();
  final Driver expectedDriver = Driver(
    seasonDriverId: seasonDriver.id,
    name: driverPersonalData.name,
    surname: driverPersonalData.surname,
    number: seasonDriver.driverNumber,
    teamName: team.name,
    teamHexColor: team.hexColor,
  );

  tearDown(() {
    verify(
      () => driverPersonalDataRepository.getDriverPersonalDataById(
        seasonDriver.driverId,
      ),
    ).called(1);
    verify(
      () => teamRepository.getTeamById(seasonDriver.teamId),
    ).called(1);
    reset(driverPersonalDataRepository);
    reset(teamRepository);
  });

  test(
    'should emit null if personal data of the driver does not exist in '
    'DriverPersonalDataRepository',
    () async {
      driverPersonalDataRepository.mockGetDriverPersonalDataById();
      teamRepository.mockGetTeamById(expectedTeam: team);

      final Stream<Driver?> driver$ = useCase(seasonDriver);

      expect(await driver$.first, null);
    },
  );

  test(
    'should emit null if team to which driver belongs does not exist in '
    'TeamRepository',
    () async {
      driverPersonalDataRepository.mockGetDriverPersonalDataById(
        expectedDriverPersonalData: driverPersonalData,
      );
      teamRepository.mockGetTeamById();

      final Stream<Driver?> driver$ = useCase(seasonDriver);

      expect(await driver$.first, null);
    },
  );

  test(
    'should emit Driver model which contains data from SeasonDriver, '
    'DriverPersonalData and Team',
    () async {
      driverPersonalDataRepository.mockGetDriverPersonalDataById(
        expectedDriverPersonalData: driverPersonalData,
      );
      teamRepository.mockGetTeamById(expectedTeam: team);

      final Stream<Driver?> driver$ = useCase(seasonDriver);

      expect(await driver$.first, expectedDriver);
    },
  );
}
