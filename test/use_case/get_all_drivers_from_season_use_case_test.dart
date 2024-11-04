import 'package:betgrid/model/driver.dart';
import 'package:betgrid/model/season_driver.dart';
import 'package:betgrid/use_case/get_all_drivers_from_season_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../creator/driver_creator.dart';
import '../creator/season_driver_creator.dart';
import '../mock/data/repository/mock_season_driver_repository.dart';
import '../mock/use_case/mock_get_driver_based_on_season_driver_use_case.dart';

void main() {
  final seasonDriverRepository = MockSeasonDriverRepository();
  final getDriverBasedOnSeasonDriverUseCase =
      MockGetDriverBasedOnSeasonDriverUseCase();
  final useCase = GetAllDriversFromSeasonUseCase(
    seasonDriverRepository,
    getDriverBasedOnSeasonDriverUseCase,
  );

  tearDown(() {
    reset(seasonDriverRepository);
    reset(getDriverBasedOnSeasonDriverUseCase);
  });

  test(
    'should get all season drivers from given season from '
    'SeasonDriverRepository and should map them to Driver model using '
    'GetDriverBasedOnSeasonDriverUseCase',
    () async {
      const int season = 2024;
      final List<SeasonDriver> seasonDrivers = [
        const SeasonDriverCreator(id: 'sd1').createEntity(),
        const SeasonDriverCreator(id: 'sd2').createEntity(),
        const SeasonDriverCreator(id: 'sd3').createEntity(),
      ];
      final List<Driver> expectedDrivers = [
        const DriverCreator(seasonDriverId: 'sd1').create(),
        const DriverCreator(seasonDriverId: 'sd2').create(),
      ];
      seasonDriverRepository.mockGetAllSeasonDriversFromSeason(
        expectedSeasonDrivers: seasonDrivers,
      );
      when(
        () => getDriverBasedOnSeasonDriverUseCase.call(seasonDrivers.first),
      ).thenAnswer((_) => Stream.value(expectedDrivers.first));
      when(
        () => getDriverBasedOnSeasonDriverUseCase.call(seasonDrivers[1]),
      ).thenAnswer((_) => Stream.value(null));
      when(
        () => getDriverBasedOnSeasonDriverUseCase.call(seasonDrivers.last),
      ).thenAnswer((_) => Stream.value(expectedDrivers.last));

      final Stream<List<Driver>> drivers$ = useCase(season);

      expect(await drivers$.first, expectedDrivers);
      verify(
        () => seasonDriverRepository.getAllSeasonDriversFromSeason(season),
      ).called(1);
      verify(
        () => getDriverBasedOnSeasonDriverUseCase.call(seasonDrivers.first),
      ).called(1);
      verify(
        () => getDriverBasedOnSeasonDriverUseCase.call(seasonDrivers[1]),
      ).called(1);
      verify(
        () => getDriverBasedOnSeasonDriverUseCase.call(seasonDrivers.last),
      ).called(1);
    },
  );
}
