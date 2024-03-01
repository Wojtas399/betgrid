import 'package:betgrid/ui/config/bet_points_config.dart';
import 'package:betgrid/ui/config/bet_points_multipliers_config.dart';
import 'package:betgrid/ui/provider/qualifications_points_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

void main() {
  final betPoints = BetPointsConfig();
  final betMultipliers = BetPointsMultipliersConfig();
  final List<String> qualiStandingsByDriverIds = List.generate(
    20,
    (i) => 'd${i + 1}',
  );

  ProviderContainer makeProviderContainer() {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    return container;
  }

  setUpAll(() {
    GetIt.I.registerFactory(() => betPoints);
    GetIt.I.registerFactory(() => betMultipliers);
  });

  test(
    'should throw exception if qualiStandingsByDriverIds length is different '
    'than 20',
    () {
      final List<String> qualiStandingsByDriverIds = ['d1', 'd2'];
      final List<String?> betQualiStandingsByDriverIds = List.generate(
        20,
        (index) => 'd$index',
      );
      final container = makeProviderContainer();

      Object? exception;
      try {
        container.read(
          qualificationsPointsProvider(
            qualiStandingsByDriverIds,
            betQualiStandingsByDriverIds,
          ),
        );
      } catch (e) {
        exception = e;
      }

      expect(exception, isNotNull);
    },
  );

  test(
    'should throw exception if betQualiStandingsByDriverIds length is different '
    'than 20',
    () {
      final List<String?> betQualiStandingsByDriverIds = List.generate(
        21,
        (index) => 'd$index',
      );
      final container = makeProviderContainer();

      Object? exception;
      try {
        container.read(
          qualificationsPointsProvider(
            qualiStandingsByDriverIds,
            betQualiStandingsByDriverIds,
          ),
        );
      } catch (e) {
        exception = e;
      }

      expect(exception, isNotNull);
    },
  );

  test(
    'should add 1 point for each correct bet in q1',
    () {
      final betQualiStandingsByDriverIds = _createBetQualiStandings(
        p16: 'd16',
        p18: 'd18',
        p20: 'd20',
      );
      final double expectedPoints = (3 * betPoints.onePositionInQ1).toDouble();
      final container = makeProviderContainer();

      final double points = container.read(
        qualificationsPointsProvider(
          qualiStandingsByDriverIds,
          betQualiStandingsByDriverIds,
        ),
      );

      expect(points, expectedPoints);
    },
  );

  test(
    'should multiply points by 1.25 if all bets from q1 are correct',
    () {
      final betQualiStandingsByDriverIds = _createBetQualiStandings(
        p16: 'd16',
        p17: 'd17',
        p18: 'd18',
        p19: 'd19',
        p20: 'd20',
      );
      final double expectedPoints =
          5 * betPoints.onePositionInQ1 * betMultipliers.perfectQ1Multiplier;
      final container = makeProviderContainer();

      final double points = container.read(
        qualificationsPointsProvider(
          qualiStandingsByDriverIds,
          betQualiStandingsByDriverIds,
        ),
      );

      expect(points, expectedPoints);
    },
  );

  test(
    'should add 2 points for each correct bet in q2',
    () {
      final betQualiStandingsByDriverIds = _createBetQualiStandings(
        p11: 'd11',
        p12: 'd12',
        p15: 'd15',
      );
      final double expectedPoints = (3 * betPoints.onePositionInQ2).toDouble();
      final container = makeProviderContainer();

      final double points = container.read(
        qualificationsPointsProvider(
          qualiStandingsByDriverIds,
          betQualiStandingsByDriverIds,
        ),
      );

      expect(points, expectedPoints);
    },
  );

  test(
    'should multiply points by 1.5 if all bets from q2 are correct',
    () {
      final betQualiStandingsByDriverIds = _createBetQualiStandings(
        p11: 'd11',
        p12: 'd12',
        p13: 'd13',
        p14: 'd14',
        p15: 'd15',
      );
      final double expectedPoints =
          5 * betPoints.onePositionInQ2 * betMultipliers.perfectQ2Multiplier;
      final container = makeProviderContainer();

      final double points = container.read(
        qualificationsPointsProvider(
          qualiStandingsByDriverIds,
          betQualiStandingsByDriverIds,
        ),
      );

      expect(points, expectedPoints);
    },
  );

  test(
    'should add 2 points for each correct bet from P10 to P4 in q3 and '
    '1 point for each correct bet from P3 to P1',
    () {
      final betQualiStandingsByDriverIds = _createBetQualiStandings(
        p1: 'd1',
        p2: 'd2',
        p4: 'd4',
        p6: 'd6',
        p10: 'd10',
      );
      final double expectedPoints = ((2 * betPoints.onePositionFromP3ToP1InQ3) +
              (3 * betPoints.onePositionFromP10ToP4InQ3))
          .toDouble();
      final container = makeProviderContainer();

      final double points = container.read(
        qualificationsPointsProvider(
          qualiStandingsByDriverIds,
          betQualiStandingsByDriverIds,
        ),
      );

      expect(points, expectedPoints);
    },
  );

  test(
    'should multiply points by 1.75 if all bets from q3 are correct',
    () {
      final betQualiStandingsByDriverIds = _createBetQualiStandings(
        p1: 'd1',
        p2: 'd2',
        p3: 'd3',
        p4: 'd4',
        p5: 'd5',
        p6: 'd6',
        p7: 'd7',
        p8: 'd8',
        p9: 'd9',
        p10: 'd10',
      );
      final double expectedPoints = ((3 * betPoints.onePositionFromP3ToP1InQ3) +
              (7 * betPoints.onePositionFromP10ToP4InQ3)) *
          betMultipliers.perfectQ3Multiplier;
      final container = makeProviderContainer();

      final double points = container.read(
        qualificationsPointsProvider(
          qualiStandingsByDriverIds,
          betQualiStandingsByDriverIds,
        ),
      );

      expect(points, expectedPoints);
    },
  );

  test(
    'should sum points of each quali session',
    () {
      final betQualiStandingsByDriverIds = _createBetQualiStandings(
        p1: 'd1',
        p3: 'd3',
        p7: 'd7',
        p9: 'd123123',
        p11: 'd11',
        p13: 'd13',
        p18: 'd18',
        p20: 'd222333',
      );
      final q1Points = 1 * betPoints.onePositionInQ1;
      final q2Points = 2 * betPoints.onePositionInQ2;
      final q3Points = 2 * betPoints.onePositionFromP3ToP1InQ3 +
          1 * betPoints.onePositionFromP10ToP4InQ3;
      final double expectedPoints = (q1Points + q2Points + q3Points).toDouble();
      final container = makeProviderContainer();

      final double points = container.read(
        qualificationsPointsProvider(
          qualiStandingsByDriverIds,
          betQualiStandingsByDriverIds,
        ),
      );
      expect(points, expectedPoints);
    },
  );

  test(
    'perfect q1 and q2, '
    'should sum points of each quali session and multiply them by '
    'summed multipliers',
    () {
      final betQualiStandingsByDriverIds = _createBetQualiStandings(
        p2: 'd2',
        p5: 'd123123',
        p8: 'd8',
        p10: 'd10',
        p11: 'd11',
        p12: 'd12',
        p13: 'd13',
        p14: 'd14',
        p15: 'd15',
        p16: 'd16',
        p17: 'd17',
        p18: 'd18',
        p19: 'd19',
        p20: 'd20',
      );
      final q1Points = 5 * betPoints.onePositionInQ1;
      final q2Points = 5 * betPoints.onePositionInQ2;
      final q3Points = (2 * betPoints.onePositionFromP10ToP4InQ3) +
          (1 * betPoints.onePositionFromP3ToP1InQ3);
      final multiplier = betMultipliers.perfectQ1Multiplier +
          betMultipliers.perfectQ2Multiplier;
      final double expectedPoints =
          (q1Points + q2Points + q3Points) * multiplier;
      final container = makeProviderContainer();

      final double points = container.read(
        qualificationsPointsProvider(
          qualiStandingsByDriverIds,
          betQualiStandingsByDriverIds,
        ),
      );
      expect(points, expectedPoints);
    },
  );

  test(
    'perfect q1 and q3, '
    'should sum points of each quali session and multiply them by '
    'summed multipliers',
    () {
      final betQualiStandingsByDriverIds = _createBetQualiStandings(
        p20: 'd20',
        p19: 'd19',
        p18: 'd18',
        p17: 'd17',
        p16: 'd16',
        p15: 'd15',
        p12: 'd12',
        p10: 'd10',
        p9: 'd9',
        p8: 'd8',
        p7: 'd7',
        p6: 'd6',
        p5: 'd5',
        p4: 'd4',
        p3: 'd3',
        p2: 'd2',
        p1: 'd1',
      );
      final q1Points = 5 * betPoints.onePositionInQ1;
      final q2Points = 2 * betPoints.onePositionInQ2;
      final q3Points = (3 * betPoints.onePositionFromP3ToP1InQ3) +
          (7 * betPoints.onePositionFromP10ToP4InQ3);
      final multiplier = betMultipliers.perfectQ1Multiplier +
          betMultipliers.perfectQ3Multiplier;
      final double expectedPoints =
          (q1Points + q2Points + q3Points) * multiplier;
      final container = makeProviderContainer();

      final double points = container.read(
        qualificationsPointsProvider(
          qualiStandingsByDriverIds,
          betQualiStandingsByDriverIds,
        ),
      );
      expect(points, expectedPoints);
    },
  );

  test(
    'perfect q2 and q3, '
    'should sum points of each quali session and multiply them by '
    'summed multipliers',
    () {
      final betQualiStandingsByDriverIds = _createBetQualiStandings(
        p20: 'd20',
        p19: 'd19',
        p15: 'd15',
        p14: 'd14',
        p13: 'd13',
        p12: 'd12',
        p11: 'd11',
        p10: 'd10',
        p9: 'd9',
        p8: 'd8',
        p7: 'd7',
        p6: 'd6',
        p5: 'd5',
        p4: 'd4',
        p3: 'd3',
        p2: 'd2',
        p1: 'd1',
      );
      final q1Points = 2 * betPoints.onePositionInQ1;
      final q2Points = 5 * betPoints.onePositionInQ2;
      final q3Points = (3 * betPoints.onePositionFromP3ToP1InQ3) +
          (7 * betPoints.onePositionFromP10ToP4InQ3);
      final multiplier = betMultipliers.perfectQ2Multiplier +
          betMultipliers.perfectQ3Multiplier;
      final double expectedPoints =
          (q1Points + q2Points + q3Points) * multiplier;
      final container = makeProviderContainer();

      final double points = container.read(
        qualificationsPointsProvider(
          qualiStandingsByDriverIds,
          betQualiStandingsByDriverIds,
        ),
      );
      expect(points, expectedPoints);
    },
  );

  test(
    'perfect q1, q2 and q3, '
    'should sum points of each quali session and multiply them by '
    'summed multipliers',
    () {
      final betQualiStandingsByDriverIds = _createBetQualiStandings(
        p20: 'd20',
        p19: 'd19',
        p18: 'd18',
        p17: 'd17',
        p16: 'd16',
        p15: 'd15',
        p14: 'd14',
        p13: 'd13',
        p12: 'd12',
        p11: 'd11',
        p10: 'd10',
        p9: 'd9',
        p8: 'd8',
        p7: 'd7',
        p6: 'd6',
        p5: 'd5',
        p4: 'd4',
        p3: 'd3',
        p2: 'd2',
        p1: 'd1',
      );
      final q1Points = 5 * betPoints.onePositionInQ1;
      final q2Points = 5 * betPoints.onePositionInQ2;
      final q3Points = (3 * betPoints.onePositionFromP3ToP1InQ3) +
          (7 * betPoints.onePositionFromP10ToP4InQ3);
      final multiplier = betMultipliers.perfectQ1Multiplier +
          betMultipliers.perfectQ2Multiplier +
          betMultipliers.perfectQ3Multiplier;
      final double expectedPoints =
          (q1Points + q2Points + q3Points) * multiplier;
      final container = makeProviderContainer();

      final double points = container.read(
        qualificationsPointsProvider(
          qualiStandingsByDriverIds,
          betQualiStandingsByDriverIds,
        ),
      );
      expect(points, expectedPoints);
    },
  );
}

List<String?> _createBetQualiStandings({
  String? p1,
  String? p2,
  String? p3,
  String? p4,
  String? p5,
  String? p6,
  String? p7,
  String? p8,
  String? p9,
  String? p10,
  String? p11,
  String? p12,
  String? p13,
  String? p14,
  String? p15,
  String? p16,
  String? p17,
  String? p18,
  String? p19,
  String? p20,
}) =>
    [
      p1,
      p2,
      p3,
      p4,
      p5,
      p6,
      p7,
      p8,
      p9,
      p10,
      p11,
      p12,
      p13,
      p14,
      p15,
      p16,
      p17,
      p18,
      p19,
      p20,
    ];
