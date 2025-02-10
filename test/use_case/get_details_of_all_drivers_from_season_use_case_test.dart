import 'package:betgrid/model/driver_details.dart';
import 'package:betgrid/model/season_driver.dart';
import 'package:betgrid/use_case/get_details_of_all_drivers_from_season_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../creator/driver_details_creator.dart';
import '../creator/season_driver_creator.dart';
import '../mock/repository/mock_season_driver_repository.dart';
import '../mock/use_case/mock_get_details_for_season_driver_use_case.dart';

void main() {
  final seasonDriverRepository = MockSeasonDriverRepository();
  final getDetailsForSeasonDriverUseCase =
      MockGetDetailsForSeasonDriverUseCase();
  final useCase = GetDetailsOfAllDriversFromSeasonUseCase(
    seasonDriverRepository,
    getDetailsForSeasonDriverUseCase,
  );

  tearDown(() {
    reset(seasonDriverRepository);
    reset(getDetailsForSeasonDriverUseCase);
  });

  test(
    'should get all season drivers from given season from '
    'SeasonDriverRepository and should map them to DriverDetails model using '
    'GetDetailsForSeasonDriverUseCase',
    () async {
      const int season = 2024;
      final List<SeasonDriver> seasonDrivers = [
        const SeasonDriverCreator(id: 'sd1').create(),
        const SeasonDriverCreator(id: 'sd2').create(),
        const SeasonDriverCreator(id: 'sd3').create(),
      ];
      final List<DriverDetails> expectedDrivers = [
        const DriverDetailsCreator(seasonDriverId: 'sd1').create(),
        const DriverDetailsCreator(seasonDriverId: 'sd2').create(),
      ];
      seasonDriverRepository.mockGetAllFromSeason(
        expectedSeasonDrivers: seasonDrivers,
      );
      when(
        () => getDetailsForSeasonDriverUseCase.call(seasonDrivers.first),
      ).thenAnswer((_) => Stream.value(expectedDrivers.first));
      when(
        () => getDetailsForSeasonDriverUseCase.call(seasonDrivers[1]),
      ).thenAnswer((_) => Stream.value(null));
      when(
        () => getDetailsForSeasonDriverUseCase.call(seasonDrivers.last),
      ).thenAnswer((_) => Stream.value(expectedDrivers.last));

      final Stream<List<DriverDetails>> drivers$ = useCase(season);

      expect(await drivers$.first, expectedDrivers);
      verify(
        () => seasonDriverRepository.getAllFromSeason(season),
      ).called(1);
      verify(
        () => getDetailsForSeasonDriverUseCase.call(seasonDrivers.first),
      ).called(1);
      verify(
        () => getDetailsForSeasonDriverUseCase.call(seasonDrivers[1]),
      ).called(1);
      verify(
        () => getDetailsForSeasonDriverUseCase.call(seasonDrivers.last),
      ).called(1);
    },
  );
}
