import 'package:betgrid/ui/config/bet_points_config.dart';
import 'package:betgrid/ui/provider/bet_points/quali_position_bet_points_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

void main() {
  final betPoints = BetPointsConfig();
  final List<String> standings = List.generate(20, (index) => 'd$index');

  setUpAll(() {
    GetIt.I.registerFactory(() => betPoints);
  });

  test(
    'results standings is null, '
    'should return null',
    () {
      final List<String> betStandings = ['d1', 'd3'];
      final container = ProviderContainer();

      final int? betPoints = container.read(
        qualiPositionBetPointsProvider(
          betStandings: betStandings,
          positionIndex: 0,
        ),
      );

      expect(betPoints, null);
    },
  );

  test(
    'results standings is empty, '
    'should return null',
    () {
      final List<String> betStandings = ['d1', 'd3'];
      final container = ProviderContainer();

      final int? betPoints = container.read(
        qualiPositionBetPointsProvider(
          betStandings: betStandings,
          resultsStandings: [],
          positionIndex: 0,
        ),
      );

      expect(betPoints, null);
    },
  );

  test(
    'results and bet standings have different length, '
    'should throw exception',
    () {
      final List<String> resultsStandings = ['d1', 'd2', 'd3'];
      final List<String> betStandings = ['d1', 'd3'];
      final container = ProviderContainer();

      Object? exception;
      try {
        container.read(
          qualiPositionBetPointsProvider(
            resultsStandings: resultsStandings,
            betStandings: betStandings,
            positionIndex: 0,
          ),
        );
      } catch (e) {
        exception = e;
      }

      expect(exception, isNotNull);
    },
  );

  test(
    'position index is lower than 20, '
    'should throw exception',
    () {
      final List<String> resultsStandings = ['d1', 'd2', 'd3'];
      final List<String> betStandings = ['d1', 'd3', 'd2'];
      final container = ProviderContainer();

      Object? exception;
      try {
        container.read(
          qualiPositionBetPointsProvider(
            resultsStandings: resultsStandings,
            betStandings: betStandings,
            positionIndex: -1,
          ),
        );
      } catch (e) {
        exception = e;
      }

      expect(exception, isNotNull);
    },
  );

  test(
    'bet on given position is wrong, '
    'should return 0',
    () {
      final List<String> resultsStandings = ['d1', 'd2', 'd3'];
      final List<String> betStandings = ['d1', 'd3', 'd2'];
      const int positionIndex = 1;
      final container = ProviderContainer();

      final int? betPoints = container.read(
        qualiPositionBetPointsProvider(
          betStandings: betStandings,
          resultsStandings: resultsStandings,
          positionIndex: positionIndex,
        ),
      );

      expect(betPoints, 0.0);
    },
  );

  test(
    'bet on index higher or equals to 15 is correct, '
    'should return 1 point',
    () {
      const int positionIndex = 15;
      const double expectedPoints = 1.0;
      final container = ProviderContainer();

      final int? betPoints = container.read(
        qualiPositionBetPointsProvider(
          resultsStandings: standings,
          betStandings: standings,
          positionIndex: positionIndex,
        ),
      );

      expect(betPoints, expectedPoints);
    },
  );

  test(
    'bet on index between 10 and 14 is correct, '
    'should return 2 points',
    () {
      const int positionIndex = 10;
      const double expectedPoints = 2.0;
      final container = ProviderContainer();

      final int? betPoints = container.read(
        qualiPositionBetPointsProvider(
          resultsStandings: standings,
          betStandings: standings,
          positionIndex: positionIndex,
        ),
      );

      expect(betPoints, expectedPoints);
    },
  );

  test(
    'bet on index between 3 and 9 is correct, '
    'should return 2 points',
    () {
      const int positionIndex = 3;
      const double expectedPoints = 2.0;
      final container = ProviderContainer();

      final int? betPoints = container.read(
        qualiPositionBetPointsProvider(
          resultsStandings: standings,
          betStandings: standings,
          positionIndex: positionIndex,
        ),
      );

      expect(betPoints, expectedPoints);
    },
  );

  test(
    'bet on index between 0 and 2 is correct, '
    'should return 1 point',
    () {
      const int positionIndex = 0;
      const double expectedPoints = 1.0;
      final container = ProviderContainer();

      final int? betPoints = container.read(
        qualiPositionBetPointsProvider(
          resultsStandings: standings,
          betStandings: standings,
          positionIndex: positionIndex,
        ),
      );

      expect(betPoints, expectedPoints);
    },
  );
}
