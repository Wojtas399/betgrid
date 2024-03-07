import 'package:betgrid/data/repository/grand_prix_bet/grand_prix_bet_repository.dart';
import 'package:betgrid/data/repository/grand_prix_result/grand_prix_results_repository.dart';
import 'package:betgrid/ui/config/bet_points_config.dart';
import 'package:betgrid/ui/config/bet_points_multipliers_config.dart';
import 'package:betgrid/ui/provider/bet_points/race_bet_points_provider.dart';
import 'package:betgrid/ui/provider/grand_prix/grand_prix_id_provider.dart';
import 'package:betgrid/ui/provider/player/player_id_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/grand_prix_bet_creator.dart';
import '../../../creator/grand_prix_results_creator.dart';
import '../../../mock/data/repository/mock_grand_prix_bet_repository.dart';
import '../../../mock/data/repository/mock_grand_prix_results_repository.dart';

void main() {
  final grandPrixResultsRepository = MockGrandPrixResultsRepository();
  final grandPrixBetRepository = MockGrandPrixBetRepository();
  final betPoints = BetPointsConfig();
  final betMultipliers = BetPointsMultipliersConfig();
  const String grandPrixId = 'gp1';
  const String playerId = 'p1';

  ProviderContainer makeProviderContainer({
    String? grandPrixId,
    String? playerId,
  }) {
    final container = ProviderContainer(
      overrides: [
        grandPrixIdProvider.overrideWithValue(grandPrixId),
        playerIdProvider.overrideWithValue(playerId),
        grandPrixResultsRepositoryProvider.overrideWithValue(
          grandPrixResultsRepository,
        ),
        grandPrixBetRepositoryProvider.overrideWithValue(
          grandPrixBetRepository,
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUpAll(() {
    GetIt.I.registerFactory(() => betPoints);
    GetIt.I.registerFactory(() => betMultipliers);
  });

  tearDown(() {
    reset(grandPrixResultsRepository);
  });

  test(
    'should emit null if grand prix id is null',
    () async {
      final container = makeProviderContainer(playerId: playerId);

      await expectLater(
        container.read(raceBetPointsProvider.future),
        completion(null),
      );
    },
  );

  test(
    'should emit null if player id is null',
    () async {
      final container = makeProviderContainer(grandPrixId: grandPrixId);

      await expectLater(
        container.read(raceBetPointsProvider.future),
        completion(null),
      );
    },
  );

  test(
    'should emit null if there is no results for given grand prix',
    () async {
      grandPrixBetRepository.mockGetBetByGrandPrixIdAndPlayerId(
        createGrandPrixBet(),
      );
      grandPrixResultsRepository.mockGetResultsForGrandPrix(results: null);

      final container = makeProviderContainer(
        grandPrixId: grandPrixId,
        playerId: playerId,
      );

      await expectLater(
        container.read(raceBetPointsProvider.future),
        completion(null),
      );
    },
  );

  test(
    'should emit null if there is no race results for given grand prix',
    () async {
      grandPrixBetRepository.mockGetBetByGrandPrixIdAndPlayerId(
        createGrandPrixBet(),
      );
      grandPrixResultsRepository.mockGetResultsForGrandPrix(
        results: createGrandPrixResults(),
      );

      final container = makeProviderContainer(
        grandPrixId: grandPrixId,
        playerId: playerId,
      );

      await expectLater(
        container.read(raceBetPointsProvider.future),
        completion(null),
      );
    },
  );

  test(
    'should emit 0 points if there are no bets for given grand prix',
    () async {
      grandPrixBetRepository.mockGetBetByGrandPrixIdAndPlayerId(null);
      grandPrixResultsRepository.mockGetResultsForGrandPrix(
        results: createGrandPrixResults(
          raceResults: createRaceResults(),
        ),
      );

      final container = makeProviderContainer(
        grandPrixId: grandPrixId,
        playerId: playerId,
      );

      await expectLater(
        container.read(raceBetPointsProvider.future),
        completion(
          const RaceBetPointsDetails(
            totalPoints: 0.0,
            pointsForPositions: 0,
            pointsForFastestLap: 0,
          ),
        ),
      );
    },
  );

  test(
    'should add 2 points to totalPoints and pointsForPositions for correct p1',
    () async {
      final results = createGrandPrixResults(
        raceResults: createRaceResults(p1DriverId: 'd1'),
      );
      final bets = createGrandPrixBet(p1DriverId: 'd1');
      grandPrixResultsRepository.mockGetResultsForGrandPrix(results: results);
      grandPrixBetRepository.mockGetBetByGrandPrixIdAndPlayerId(bets);

      final container = makeProviderContainer(
        grandPrixId: grandPrixId,
        playerId: playerId,
      );

      await expectLater(
        container.read(raceBetPointsProvider.future),
        completion(
          const RaceBetPointsDetails(
            totalPoints: 2.0,
            pointsForPositions: 2,
            pointsForFastestLap: 0,
          ),
        ),
      );
    },
  );

  test(
    'should add 2 points to totalPoints and pointsForPositions for correct p2',
    () async {
      final results = createGrandPrixResults(
        raceResults: createRaceResults(p2DriverId: 'd1'),
      );
      final bets = createGrandPrixBet(p2DriverId: 'd1');
      grandPrixResultsRepository.mockGetResultsForGrandPrix(results: results);
      grandPrixBetRepository.mockGetBetByGrandPrixIdAndPlayerId(bets);

      final container = makeProviderContainer(
        grandPrixId: grandPrixId,
        playerId: playerId,
      );

      await expectLater(
        container.read(raceBetPointsProvider.future),
        completion(
          const RaceBetPointsDetails(
            totalPoints: 2.0,
            pointsForPositions: 2,
            pointsForFastestLap: 0,
          ),
        ),
      );
    },
  );

  test(
    'should add 2 points to totalPoints and pointsForPositions for correct p3',
    () async {
      final results = createGrandPrixResults(
        raceResults: createRaceResults(p3DriverId: 'd1'),
      );
      final bets = createGrandPrixBet(p3DriverId: 'd1');
      grandPrixResultsRepository.mockGetResultsForGrandPrix(results: results);
      grandPrixBetRepository.mockGetBetByGrandPrixIdAndPlayerId(bets);

      final container = makeProviderContainer(
        grandPrixId: grandPrixId,
        playerId: playerId,
      );

      await expectLater(
        container.read(raceBetPointsProvider.future),
        completion(
          const RaceBetPointsDetails(
            totalPoints: 2.0,
            pointsForPositions: 2,
            pointsForFastestLap: 0,
          ),
        ),
      );
    },
  );

  test(
    'should add 2 points to totalPoints and pointsForPositions for correct p10',
    () async {
      final results = createGrandPrixResults(
        raceResults: createRaceResults(p10DriverId: 'd1'),
      );
      final bets = createGrandPrixBet(p10DriverId: 'd1');
      grandPrixResultsRepository.mockGetResultsForGrandPrix(results: results);
      grandPrixBetRepository.mockGetBetByGrandPrixIdAndPlayerId(bets);

      final container = makeProviderContainer(
        grandPrixId: grandPrixId,
        playerId: playerId,
      );

      await expectLater(
        container.read(raceBetPointsProvider.future),
        completion(
          const RaceBetPointsDetails(
            totalPoints: 4.0,
            pointsForPositions: 4,
            pointsForFastestLap: 0,
          ),
        ),
      );
    },
  );

  test(
    'should add 2 points to totalPoints and pointsForPositions for correct fastest lap',
    () async {
      final results = createGrandPrixResults(
        raceResults: createRaceResults(fastestLapDriverId: 'd1'),
      );
      final bets = createGrandPrixBet(fastestLapDriverId: 'd1');
      grandPrixResultsRepository.mockGetResultsForGrandPrix(results: results);
      grandPrixBetRepository.mockGetBetByGrandPrixIdAndPlayerId(bets);

      final container = makeProviderContainer(
        grandPrixId: grandPrixId,
        playerId: playerId,
      );

      await expectLater(
        container.read(raceBetPointsProvider.future),
        completion(
          const RaceBetPointsDetails(
            totalPoints: 2.0,
            pointsForPositions: 0,
            pointsForFastestLap: 2,
          ),
        ),
      );
    },
  );

  test(
    'should sum points of each correct hit',
    () async {
      final results = createGrandPrixResults(
        raceResults: createRaceResults(
          p1DriverId: 'd1',
          p10DriverId: 'd10',
          fastestLapDriverId: 'd1',
        ),
      );
      final bets = createGrandPrixBet(
        p1DriverId: 'd1',
        p10DriverId: 'd10',
        fastestLapDriverId: 'd1',
      );
      final int pointsForPositions = betPoints.raceP1 + betPoints.raceP10;
      final int pointsForFastestLap = betPoints.raceFastestLap;
      final double totalPoints =
          (pointsForPositions + pointsForFastestLap).toDouble();
      grandPrixResultsRepository.mockGetResultsForGrandPrix(results: results);
      grandPrixBetRepository.mockGetBetByGrandPrixIdAndPlayerId(bets);

      final container = makeProviderContainer(
        grandPrixId: grandPrixId,
        playerId: playerId,
      );

      await expectLater(
        container.read(raceBetPointsProvider.future),
        completion(
          RaceBetPointsDetails(
            totalPoints: totalPoints,
            pointsForPositions: pointsForPositions,
            pointsForFastestLap: pointsForFastestLap,
          ),
        ),
      );
    },
  );

  test(
    'should multiply points from p1, p2, p3 and p10 by 1.5 if bets are correct',
    () async {
      final results = createGrandPrixResults(
        raceResults: createRaceResults(
          p1DriverId: 'd1',
          p2DriverId: 'd2',
          p3DriverId: 'd3',
          p10DriverId: 'd10',
        ),
      );
      final bets = createGrandPrixBet(
        p1DriverId: 'd1',
        p2DriverId: 'd2',
        p3DriverId: 'd3',
        p10DriverId: 'd10',
      );
      final int pointsForPositions = betPoints.raceP1 +
          betPoints.raceP2 +
          betPoints.raceP3 +
          betPoints.raceP10;
      final double positionsPointsMultiplier =
          betMultipliers.perfectRacePodiumAndP10;
      final double totalPoints = pointsForPositions * positionsPointsMultiplier;
      grandPrixResultsRepository.mockGetResultsForGrandPrix(results: results);
      grandPrixBetRepository.mockGetBetByGrandPrixIdAndPlayerId(bets);

      final container = makeProviderContainer(
        grandPrixId: grandPrixId,
        playerId: playerId,
      );

      await expectLater(
        container.read(raceBetPointsProvider.future),
        completion(
          RaceBetPointsDetails(
            totalPoints: totalPoints,
            pointsForPositions: pointsForPositions,
            pointsForFastestLap: 0,
            positionsPointsMultiplier: positionsPointsMultiplier,
          ),
        ),
      );
    },
  );

  test(
    'if all bets are correct should only multiply points from p1, p2, p3 and '
    'p10 by 1.5 and should add points for fastest lap to it',
    () async {
      final results = createGrandPrixResults(
        raceResults: createRaceResults(
          p1DriverId: 'd1',
          p2DriverId: 'd2',
          p3DriverId: 'd3',
          p10DriverId: 'd10',
          fastestLapDriverId: 'd1',
        ),
      );
      final bets = createGrandPrixBet(
        p1DriverId: 'd1',
        p2DriverId: 'd2',
        p3DriverId: 'd3',
        p10DriverId: 'd10',
        fastestLapDriverId: 'd1',
      );
      final int pointsForPositions = betPoints.raceP1 +
          betPoints.raceP2 +
          betPoints.raceP3 +
          betPoints.raceP10;
      final double positionsPointsMultiplier =
          betMultipliers.perfectRacePodiumAndP10;
      final int pointsForFastestLap = betPoints.raceFastestLap;
      final double totalPoints =
          (pointsForPositions * positionsPointsMultiplier) +
              pointsForFastestLap;
      grandPrixResultsRepository.mockGetResultsForGrandPrix(results: results);
      grandPrixBetRepository.mockGetBetByGrandPrixIdAndPlayerId(bets);

      final container = makeProviderContainer(
        grandPrixId: grandPrixId,
        playerId: playerId,
      );

      await expectLater(
        container.read(raceBetPointsProvider.future),
        completion(
          RaceBetPointsDetails(
            totalPoints: totalPoints,
            pointsForPositions: pointsForPositions,
            pointsForFastestLap: pointsForFastestLap,
            positionsPointsMultiplier: positionsPointsMultiplier,
          ),
        ),
      );
    },
  );
}
