import 'package:betgrid/ui/config/bet_points_config.dart';
import 'package:betgrid/ui/provider/bet_points/race_single_bet_points_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

void main() {
  final betPointsConfig = BetPointsConfig();

  setUpAll(() {
    GetIt.I.registerFactory(() => betPointsConfig);
  });

  test(
    'p1 position, '
    'resultsDriverId is null, '
    'should return null',
    () {
      final container = ProviderContainer();

      final int? betPoints = container.read(raceSingleBetPointsProvider(
        positionType: RacePositionType.p1,
        betDriverId: 'd1',
        resultsDriverId: null,
      ));

      expect(betPoints, null);
    },
  );

  test(
    'p1 position, '
    'resultsDriverId is not null but betDriverIsNull, '
    'should return 0 points',
    () {
      const int expectedPoints = 0;
      final container = ProviderContainer();

      final int? betPoints = container.read(raceSingleBetPointsProvider(
        positionType: RacePositionType.p1,
        betDriverId: null,
        resultsDriverId: 'd1',
      ));

      expect(betPoints, expectedPoints);
    },
  );

  test(
    'p1 position, '
    'betDriverId and resultsDriverId are not null and not equal to each other, '
    'should return 0 points',
    () {
      const int expectedPoints = 0;
      final container = ProviderContainer();

      final int? betPoints = container.read(raceSingleBetPointsProvider(
        positionType: RacePositionType.p1,
        betDriverId: 'd1',
        resultsDriverId: 'd2',
      ));

      expect(betPoints, expectedPoints);
    },
  );

  test(
    'p1 position, '
    'betDriverId and resultsDriverId are not null and equal to each other, '
    'should return 2 points',
    () {
      const int expectedPoints = 2;
      final container = ProviderContainer();

      final int? betPoints = container.read(raceSingleBetPointsProvider(
        positionType: RacePositionType.p1,
        betDriverId: 'd1',
        resultsDriverId: 'd1',
      ));

      expect(betPoints, expectedPoints);
    },
  );

  test(
    'p2 position, '
    'resultsDriverId is null, '
    'should return null',
    () {
      final container = ProviderContainer();

      final int? betPoints = container.read(raceSingleBetPointsProvider(
        positionType: RacePositionType.p2,
        betDriverId: 'd1',
        resultsDriverId: null,
      ));

      expect(betPoints, null);
    },
  );

  test(
    'p2 position, '
    'resultsDriverId is not null but betDriverIsNull, '
    'should return 0 points',
    () {
      const int expectedPoints = 0;
      final container = ProviderContainer();

      final int? betPoints = container.read(raceSingleBetPointsProvider(
        positionType: RacePositionType.p2,
        betDriverId: null,
        resultsDriverId: 'd1',
      ));

      expect(betPoints, expectedPoints);
    },
  );

  test(
    'p2 position, '
    'betDriverId and resultsDriverId are not null and not equal to each other, '
    'should return 0 points',
    () {
      const int expectedPoints = 0;
      final container = ProviderContainer();

      final int? betPoints = container.read(raceSingleBetPointsProvider(
        positionType: RacePositionType.p2,
        betDriverId: 'd1',
        resultsDriverId: 'd2',
      ));

      expect(betPoints, expectedPoints);
    },
  );

  test(
    'p2 position, '
    'betDriverId and resultsDriverId are not null and equal to each other, '
    'should return 2 points',
    () {
      const int expectedPoints = 2;
      final container = ProviderContainer();

      final int? betPoints = container.read(raceSingleBetPointsProvider(
        positionType: RacePositionType.p2,
        betDriverId: 'd1',
        resultsDriverId: 'd1',
      ));

      expect(betPoints, expectedPoints);
    },
  );

  test(
    'p3 position, '
    'resultsDriverId is null, '
    'should return null',
    () {
      final container = ProviderContainer();

      final int? betPoints = container.read(raceSingleBetPointsProvider(
        positionType: RacePositionType.p3,
        betDriverId: 'd1',
        resultsDriverId: null,
      ));

      expect(betPoints, null);
    },
  );

  test(
    'p3 position, '
    'resultsDriverId is not null but betDriverIsNull, '
    'should return 0 points',
    () {
      const int expectedPoints = 0;
      final container = ProviderContainer();

      final int? betPoints = container.read(raceSingleBetPointsProvider(
        positionType: RacePositionType.p3,
        betDriverId: null,
        resultsDriverId: 'd1',
      ));

      expect(betPoints, expectedPoints);
    },
  );

  test(
    'p3 position, '
    'betDriverId and resultsDriverId are not null and not equal to each other, '
    'should return 0 points',
    () {
      const int expectedPoints = 0;
      final container = ProviderContainer();

      final int? betPoints = container.read(raceSingleBetPointsProvider(
        positionType: RacePositionType.p3,
        betDriverId: 'd1',
        resultsDriverId: 'd2',
      ));

      expect(betPoints, expectedPoints);
    },
  );

  test(
    'p3 position, '
    'betDriverId and resultsDriverId are not null and equal to each other, '
    'should return 2 points',
    () {
      const int expectedPoints = 2;
      final container = ProviderContainer();

      final int? betPoints = container.read(raceSingleBetPointsProvider(
        positionType: RacePositionType.p3,
        betDriverId: 'd1',
        resultsDriverId: 'd1',
      ));

      expect(betPoints, expectedPoints);
    },
  );

  test(
    'p10 position, '
    'resultsDriverId is null, '
    'should return null',
    () {
      final container = ProviderContainer();

      final int? betPoints = container.read(raceSingleBetPointsProvider(
        positionType: RacePositionType.p10,
        betDriverId: 'd1',
        resultsDriverId: null,
      ));

      expect(betPoints, null);
    },
  );

  test(
    'p10 position, '
    'resultsDriverId is not null but betDriverIsNull, '
    'should return 0 points',
    () {
      const int expectedPoints = 0;
      final container = ProviderContainer();

      final int? betPoints = container.read(raceSingleBetPointsProvider(
        positionType: RacePositionType.p10,
        betDriverId: null,
        resultsDriverId: 'd1',
      ));

      expect(betPoints, expectedPoints);
    },
  );

  test(
    'p10 position, '
    'betDriverId and resultsDriverId are not null and not equal to each other, '
    'should return 0 points',
    () {
      const int expectedPoints = 0;
      final container = ProviderContainer();

      final int? betPoints = container.read(raceSingleBetPointsProvider(
        positionType: RacePositionType.p10,
        betDriverId: 'd1',
        resultsDriverId: 'd2',
      ));

      expect(betPoints, expectedPoints);
    },
  );

  test(
    'p10 position, '
    'betDriverId and resultsDriverId are not null and equal to each other, '
    'should return 4 points',
    () {
      const int expectedPoints = 4;
      final container = ProviderContainer();

      final int? betPoints = container.read(raceSingleBetPointsProvider(
        positionType: RacePositionType.p10,
        betDriverId: 'd1',
        resultsDriverId: 'd1',
      ));

      expect(betPoints, expectedPoints);
    },
  );

  test(
    'fastestLap position, '
    'resultsDriverId is null, '
    'should return null',
    () {
      final container = ProviderContainer();

      final int? betPoints = container.read(raceSingleBetPointsProvider(
        positionType: RacePositionType.fastestLap,
        betDriverId: 'd1',
        resultsDriverId: null,
      ));

      expect(betPoints, null);
    },
  );

  test(
    'fastestLap position, '
    'resultsDriverId is not null but betDriverIsNull, '
    'should return 0 points',
    () {
      const int expectedPoints = 0;
      final container = ProviderContainer();

      final int? betPoints = container.read(raceSingleBetPointsProvider(
        positionType: RacePositionType.fastestLap,
        betDriverId: null,
        resultsDriverId: 'd1',
      ));

      expect(betPoints, expectedPoints);
    },
  );

  test(
    'fastestLap position, '
    'betDriverId and resultsDriverId are not null and not equal to each other, '
    'should return 0 points',
    () {
      const int expectedPoints = 0;
      final container = ProviderContainer();

      final int? betPoints = container.read(raceSingleBetPointsProvider(
        positionType: RacePositionType.fastestLap,
        betDriverId: 'd1',
        resultsDriverId: 'd2',
      ));

      expect(betPoints, expectedPoints);
    },
  );

  test(
    'fastestLap position, '
    'betDriverId and resultsDriverId are not null and equal to each other, '
    'should return 2 points',
    () {
      const int expectedPoints = 2;
      final container = ProviderContainer();

      final int? betPoints = container.read(raceSingleBetPointsProvider(
        positionType: RacePositionType.fastestLap,
        betDriverId: 'd1',
        resultsDriverId: 'd1',
      ));

      expect(betPoints, expectedPoints);
    },
  );
}
