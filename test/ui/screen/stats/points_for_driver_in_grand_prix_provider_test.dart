import 'package:betgrid/data/repository/grand_prix_bet/grand_prix_bet_repository_method_providers.dart';
import 'package:betgrid/data/repository/grand_prix_result/grand_prix_results_repository_method_providers.dart';
import 'package:betgrid/model/grand_prix_bet.dart';
import 'package:betgrid/model/grand_prix_bet_points.dart';
import 'package:betgrid/model/grand_prix_results.dart';
import 'package:betgrid/ui/screen/stats/provider/points_for_driver_in_grand_prix_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../creator/grand_prix_bet_creator.dart';
import '../../../creator/grand_prix_bet_points_creator.dart';
import '../../../creator/grand_prix_results_creator.dart';
import '../../../creator/quali_bet_points_creator.dart';
import '../../../creator/race_bet_points_creator.dart';

void main() {
  const String playerId = 'p1';
  const String grandPrixId = 'gp1';
  const String driverId = 'd1';

  ProviderContainer makeProviderContainer({
    GrandPrixResults? grandPrixResults,
    GrandPrixBet? grandPrixBet,
  }) {
    final container = ProviderContainer(
      overrides: [
        grandPrixResultsProvider(grandPrixId: grandPrixId).overrideWith(
          (_) => Stream.value(grandPrixResults),
        ),
        grandPrixBetByPlayerIdAndGrandPrixIdProvider(
          playerId: playerId,
          grandPrixId: grandPrixId,
        ).overrideWith((_) => Stream.value(grandPrixBet)),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test(
    'quali results do not exist, '
    'should only return points for race',
    () async {
      final GrandPrixResults results = createGrandPrixResults(
        raceResults: createRaceResults(
          p1DriverId: 'd2',
          p2DriverId: driverId,
          p3DriverId: 'd4',
          fastestLapDriverId: driverId,
          dnfDriverIds: ['d3', 'd5', 'd10', driverId],
        ),
      );
      final GrandPrixBetPoints betPoints = createGrandPrixBetPoints(
        qualiBetPoints: createQualiBetPoints(
          q3P1Points: 1,
          q3P2Points: 1,
          q3P3Points: 1,
          q3P4Points: 2,
          q1P16Points: 1,
        ),
        raceBetPoints: createRaceBetPoints(
          p1Points: 1,
          p2Points: 2,
          p3Points: 1,
          fastestLapPoints: 2,
          dnfDriver1Points: 1,
          dnfDriver2Points: 2,
          dnfDriver3Points: 3,
        ),
      );
      final GrandPrixBet bet = createGrandPrixBet(
        dnfDriverIds: ['d6', 'd8', driverId],
      );
      const double expectedPoints = 7;
      final container = makeProviderContainer(
        grandPrixResults: results,
        grandPrixBet: bet,
      );

      final double points = await container.read(
        pointsForDriverInGrandPrixProvider(
          playerId: playerId,
          grandPrixId: grandPrixId,
          driverId: driverId,
          grandPrixBetPoints: betPoints,
        ).future,
      );

      expect(points, expectedPoints);
    },
  );

  test(
    'quali bet points do not exist, '
    'should only return points for race',
    () async {
      final GrandPrixResults results = createGrandPrixResults(
        qualiStandingsByDriverIds: List.generate(
          20,
          (index) => switch (index) {
            3 => driverId,
            _ => 'driver$index',
          },
        ),
        raceResults: createRaceResults(
          p1DriverId: 'd2',
          p2DriverId: driverId,
          p3DriverId: 'd4',
          fastestLapDriverId: driverId,
          dnfDriverIds: ['d3', 'd5', 'd10', driverId],
        ),
      );
      final GrandPrixBetPoints betPoints = createGrandPrixBetPoints(
        raceBetPoints: createRaceBetPoints(
          p1Points: 1,
          p2Points: 2,
          p3Points: 1,
          fastestLapPoints: 2,
          dnfDriver1Points: 1,
          dnfDriver2Points: 2,
          dnfDriver3Points: 3,
        ),
      );
      final GrandPrixBet bet = createGrandPrixBet(
        dnfDriverIds: ['d6', 'd8', driverId],
      );
      const double expectedPoints = 7;
      final container = makeProviderContainer(
        grandPrixResults: results,
        grandPrixBet: bet,
      );

      final double points = await container.read(
        pointsForDriverInGrandPrixProvider(
          playerId: playerId,
          grandPrixId: grandPrixId,
          driverId: driverId,
          grandPrixBetPoints: betPoints,
        ).future,
      );

      expect(points, expectedPoints);
    },
  );

  test(
    'race results do not exist, '
    'should only return points for quali',
    () async {
      final GrandPrixResults results = createGrandPrixResults(
        qualiStandingsByDriverIds: List.generate(
          20,
          (index) => switch (index) {
            3 => driverId,
            _ => 'driver$index',
          },
        ),
      );
      final GrandPrixBetPoints betPoints = createGrandPrixBetPoints(
        qualiBetPoints: createQualiBetPoints(
          q3P1Points: 1,
          q3P2Points: 1,
          q3P3Points: 1,
          q3P4Points: 2,
          q1P16Points: 1,
        ),
        raceBetPoints: createRaceBetPoints(
          p1Points: 1,
          p2Points: 2,
          p3Points: 1,
          fastestLapPoints: 2,
          dnfDriver1Points: 1,
          dnfDriver2Points: 2,
          dnfDriver3Points: 3,
        ),
      );
      final GrandPrixBet bet = createGrandPrixBet(
        dnfDriverIds: ['d6', 'd8', driverId],
      );
      const double expectedPoints = 2;
      final container = makeProviderContainer(
        grandPrixResults: results,
        grandPrixBet: bet,
      );

      final double points = await container.read(
        pointsForDriverInGrandPrixProvider(
          playerId: playerId,
          grandPrixId: grandPrixId,
          driverId: driverId,
          grandPrixBetPoints: betPoints,
        ).future,
      );

      expect(points, expectedPoints);
    },
  );

  test(
    'race bet points do not exist, '
    'should only return points for quali',
    () async {
      final GrandPrixResults results = createGrandPrixResults(
        qualiStandingsByDriverIds: List.generate(
          20,
          (index) => switch (index) {
            3 => driverId,
            _ => 'driver$index',
          },
        ),
        raceResults: createRaceResults(
          p1DriverId: 'd2',
          p2DriverId: driverId,
          p3DriverId: 'd4',
          fastestLapDriverId: driverId,
          dnfDriverIds: ['d3', 'd5', 'd10', driverId],
        ),
      );
      final GrandPrixBetPoints betPoints = createGrandPrixBetPoints(
        qualiBetPoints: createQualiBetPoints(
          q3P1Points: 1,
          q3P2Points: 1,
          q3P3Points: 1,
          q3P4Points: 2,
          q1P16Points: 1,
        ),
      );
      final GrandPrixBet bet = createGrandPrixBet(
        dnfDriverIds: ['d6', 'd8', driverId],
      );
      const double expectedPoints = 2;
      final container = makeProviderContainer(
        grandPrixResults: results,
        grandPrixBet: bet,
      );

      final double points = await container.read(
        pointsForDriverInGrandPrixProvider(
          playerId: playerId,
          grandPrixId: grandPrixId,
          driverId: driverId,
          grandPrixBetPoints: betPoints,
        ).future,
      );

      expect(points, expectedPoints);
    },
  );

  test(
    'bets for grand prix do not exist, '
    'should not add points for dnf drivers',
    () async {
      final GrandPrixResults results = createGrandPrixResults(
        qualiStandingsByDriverIds: List.generate(
          20,
          (index) => switch (index) {
            3 => driverId,
            _ => 'driver$index',
          },
        ),
        raceResults: createRaceResults(
          p1DriverId: 'd2',
          p2DriverId: driverId,
          p3DriverId: 'd4',
          fastestLapDriverId: driverId,
          dnfDriverIds: ['d3', 'd5', 'd10', driverId],
        ),
      );
      final GrandPrixBetPoints betPoints = createGrandPrixBetPoints(
        qualiBetPoints: createQualiBetPoints(
          q3P1Points: 1,
          q3P2Points: 1,
          q3P3Points: 1,
          q3P4Points: 2,
          q1P16Points: 1,
        ),
        raceBetPoints: createRaceBetPoints(
          p1Points: 1,
          p2Points: 2,
          p3Points: 1,
          fastestLapPoints: 2,
          dnfDriver1Points: 1,
          dnfDriver2Points: 2,
          dnfDriver3Points: 3,
        ),
      );
      const double expectedPoints = 6;
      final container = makeProviderContainer(
        grandPrixResults: results,
      );

      final double points = await container.read(
        pointsForDriverInGrandPrixProvider(
          playerId: playerId,
          grandPrixId: grandPrixId,
          driverId: driverId,
          grandPrixBetPoints: betPoints,
        ).future,
      );

      expect(points, expectedPoints);
    },
  );

  test(
    'should sum points received by driver in grand prix',
    () async {
      final GrandPrixResults results = createGrandPrixResults(
        qualiStandingsByDriverIds: List.generate(
          20,
          (index) => switch (index) {
            3 => driverId,
            _ => 'driver$index',
          },
        ),
        raceResults: createRaceResults(
          p1DriverId: 'd2',
          p2DriverId: driverId,
          p3DriverId: 'd4',
          fastestLapDriverId: driverId,
          dnfDriverIds: ['d3', 'd5', 'd10', driverId],
        ),
      );
      final GrandPrixBetPoints betPoints = createGrandPrixBetPoints(
        qualiBetPoints: createQualiBetPoints(
          q3P1Points: 1,
          q3P2Points: 1,
          q3P3Points: 1,
          q3P4Points: 2,
          q1P16Points: 1,
        ),
        raceBetPoints: createRaceBetPoints(
          p1Points: 1,
          p2Points: 2,
          p3Points: 1,
          fastestLapPoints: 2,
          dnfDriver1Points: 1,
          dnfDriver2Points: 2,
          dnfDriver3Points: 3,
        ),
      );
      final GrandPrixBet bet = createGrandPrixBet(
        dnfDriverIds: ['d6', 'd8', driverId],
      );
      const double expectedPoints = 9;
      final container = makeProviderContainer(
        grandPrixResults: results,
        grandPrixBet: bet,
      );

      final double points = await container.read(
        pointsForDriverInGrandPrixProvider(
          playerId: playerId,
          grandPrixId: grandPrixId,
          driverId: driverId,
          grandPrixBetPoints: betPoints,
        ).future,
      );

      expect(points, expectedPoints);
    },
  );
}
