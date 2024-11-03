import 'package:betgrid/model/driver.dart';
import 'package:betgrid/model/driver_details.dart';
import 'package:betgrid/model/season_driver.dart';
import 'package:betgrid/model/team.dart' as team_model;
import 'package:betgrid/use_case/get_driver_details_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../creator/driver_creator.dart';
import '../creator/season_driver_creator.dart';
import '../creator/team_creator.dart';
import '../mock/data/repository/mock_driver_repository.dart';
import '../mock/data/repository/mock_season_driver_repository.dart';
import '../mock/data/repository/mock_team_repository.dart';

void main() {
  final driverRepository = MockDriverRepository();
  final seasonDriverRepository = MockSeasonDriverRepository();
  final teamRepository = MockTeamRepository();
  final useCase = GetDriverDetailsUseCase(
    driverRepository,
    seasonDriverRepository,
    teamRepository,
  );
  const String driverId = 'd1';
  const int season = 2024;
  const String teamId = 't1';
  final Driver driver = const DriverCreator(id: driverId).createEntity();
  final SeasonDriver seasonDriver = const SeasonDriverCreator(
    driverId: driverId,
    season: season,
    teamId: teamId,
  ).createEntity();
  final team_model.Team team = const TeamCreator(id: teamId).createEntity();

  tearDown(() {
    reset(driverRepository);
    reset(seasonDriverRepository);
    reset(teamRepository);
  });

  test(
    'should emit null if matching driver does not exist in DriverRepository',
    () async {
      driverRepository.mockGetDriverById();
      seasonDriverRepository.mockGetSeasonDriverByDriverIdAndSeason(
        expectedSeasonDriver: seasonDriver,
      );

      final Stream<DriverDetails?> driverDetails$ = useCase(
        driverId: driverId,
        season: season,
      );

      expect(await driverDetails$.first, null);
    },
  );

  test(
    'should emit null if matching season driver does not exist in '
    'SeasonDriverRepository',
    () async {
      driverRepository.mockGetDriverById(driver: driver);
      seasonDriverRepository.mockGetSeasonDriverByDriverIdAndSeason();

      final Stream<DriverDetails?> driverDetails$ = useCase(
        driverId: driverId,
        season: season,
      );

      expect(await driverDetails$.first, null);
    },
  );

  test(
    'should emit null if matching team does not exist in TeamRepository',
    () async {
      driverRepository.mockGetDriverById(driver: driver);
      seasonDriverRepository.mockGetSeasonDriverByDriverIdAndSeason(
        expectedSeasonDriver: seasonDriver,
      );
      teamRepository.mockGetTeamById();

      final Stream<DriverDetails?> driverDetails$ = useCase(
        driverId: driverId,
        season: season,
      );

      expect(await driverDetails$.first, null);
    },
  );

  test(
    'should emit DriverDetails with Driver, SeasonDriver and Team data',
    () async {
      final expectedDriverDetails = DriverDetails(
        driver: driver,
        seasonDriver: seasonDriver,
        team: team,
      );
      driverRepository.mockGetDriverById(driver: driver);
      seasonDriverRepository.mockGetSeasonDriverByDriverIdAndSeason(
        expectedSeasonDriver: seasonDriver,
      );
      teamRepository.mockGetTeamById(expectedTeam: team);

      final Stream<DriverDetails?> driverDetails$ = useCase(
        driverId: driverId,
        season: season,
      );

      expect(await driverDetails$.first, expectedDriverDetails);
    },
  );
}
