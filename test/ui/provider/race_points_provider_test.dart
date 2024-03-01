import 'package:betgrid/data/repository/grand_prix_bet/grand_prix_bet_repository.dart';
import 'package:betgrid/data/repository/grand_prix_result/grand_prix_results_repository.dart';
import 'package:betgrid/ui/config/bet_points_config.dart';
import 'package:betgrid/ui/config/bet_points_multipliers_config.dart';
import 'package:betgrid/ui/provider/grand_prix_id_provider.dart';
import 'package:betgrid/ui/provider/player_id_provider.dart';
import 'package:betgrid/ui/provider/race_points_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../../creator/grand_prix_bet_creator.dart';
import '../../creator/grand_prix_results_creator.dart';
import '../../mock/data/repository/mock_grand_prix_bet_repository.dart';
import '../../mock/data/repository/mock_grand_prix_results_repository.dart';

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
        grandPrixBetRepositoryProvider.overrideWithValue(grandPrixBetRepository)
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
        container.read(racePointsProvider.future),
        completion(null),
      );
    },
  );

  test(
    'should emit null if playerId id is null',
    () async {
      final container = makeProviderContainer(grandPrixId: grandPrixId);

      await expectLater(
        container.read(racePointsProvider.future),
        completion(null),
      );
    },
  );

  test(
    'should emit 0 if user does not have bets for given grand prix',
    () async {
      grandPrixBetRepository.mockGetGrandPrixBetByGrandPrixId(null);
      grandPrixResultsRepository.mockGetResultsForGrandPrix(
        results: createGrandPrixResults(),
      );
      final container = makeProviderContainer(
        grandPrixId: grandPrixId,
        playerId: playerId,
      );

      await expectLater(
        container.read(racePointsProvider.future),
        completion(0),
      );
      verify(
        () => grandPrixBetRepository.getGrandPrixBetByGrandPrixId(
          userId: playerId,
          grandPrixId: grandPrixId,
        ),
      ).called(1);
      verify(
        () => grandPrixResultsRepository.getResultForGrandPrix(
          grandPrixId: grandPrixId,
        ),
      ).called(1);
    },
  );

  test(
    'should emit 0 if there are no results for given grand prix',
    () async {
      grandPrixBetRepository.mockGetGrandPrixBetByGrandPrixId(
        createGrandPrixBet(),
      );
      grandPrixResultsRepository.mockGetResultsForGrandPrix(results: null);
      final container = makeProviderContainer(
        grandPrixId: grandPrixId,
        playerId: playerId,
      );

      await expectLater(
        container.read(racePointsProvider.future),
        completion(0),
      );
      verify(
        () => grandPrixBetRepository.getGrandPrixBetByGrandPrixId(
          userId: playerId,
          grandPrixId: grandPrixId,
        ),
      ).called(1);
      verify(
        () => grandPrixResultsRepository.getResultForGrandPrix(
          grandPrixId: grandPrixId,
        ),
      ).called(1);
    },
  );

  test(
    'should add 2 points for correct p1',
    () async {
      final results = createGrandPrixResults(p1DriverId: 'd1');
      final bets = createGrandPrixBet(p1DriverId: 'd1');
      grandPrixResultsRepository.mockGetResultsForGrandPrix(results: results);
      grandPrixBetRepository.mockGetGrandPrixBetByGrandPrixId(bets);
      final container = makeProviderContainer(
        grandPrixId: grandPrixId,
        playerId: playerId,
      );

      await expectLater(
        container.read(racePointsProvider.future),
        completion(betPoints.raceP1),
      );
      verify(
        () => grandPrixResultsRepository.getResultForGrandPrix(
          grandPrixId: grandPrixId,
        ),
      ).called(1);
      verify(
        () => grandPrixBetRepository.getGrandPrixBetByGrandPrixId(
          userId: playerId,
          grandPrixId: grandPrixId,
        ),
      ).called(1);
    },
  );

  test(
    'should add 2 points for correct p2',
    () async {
      final results = createGrandPrixResults(p2DriverId: 'd1');
      final bets = createGrandPrixBet(p2DriverId: 'd1');
      grandPrixResultsRepository.mockGetResultsForGrandPrix(results: results);
      grandPrixBetRepository.mockGetGrandPrixBetByGrandPrixId(bets);
      final container = makeProviderContainer(
        grandPrixId: grandPrixId,
        playerId: playerId,
      );

      await expectLater(
        container.read(racePointsProvider.future),
        completion(betPoints.raceP2),
      );
      verify(
        () => grandPrixResultsRepository.getResultForGrandPrix(
          grandPrixId: grandPrixId,
        ),
      ).called(1);
      verify(
        () => grandPrixBetRepository.getGrandPrixBetByGrandPrixId(
          userId: playerId,
          grandPrixId: grandPrixId,
        ),
      ).called(1);
    },
  );

  test(
    'should add 2 points for correct p3',
    () async {
      final results = createGrandPrixResults(p3DriverId: 'd1');
      final bets = createGrandPrixBet(p3DriverId: 'd1');
      grandPrixResultsRepository.mockGetResultsForGrandPrix(results: results);
      grandPrixBetRepository.mockGetGrandPrixBetByGrandPrixId(bets);
      final container = makeProviderContainer(
        grandPrixId: grandPrixId,
        playerId: playerId,
      );

      await expectLater(
        container.read(racePointsProvider.future),
        completion(betPoints.raceP3),
      );
      verify(
        () => grandPrixResultsRepository.getResultForGrandPrix(
          grandPrixId: grandPrixId,
        ),
      ).called(1);
      verify(
        () => grandPrixBetRepository.getGrandPrixBetByGrandPrixId(
          userId: playerId,
          grandPrixId: grandPrixId,
        ),
      ).called(1);
    },
  );

  test(
    'should add 4 points for correct p10',
    () async {
      final results = createGrandPrixResults(p10DriverId: 'd1');
      final bets = createGrandPrixBet(p10DriverId: 'd1');
      grandPrixResultsRepository.mockGetResultsForGrandPrix(results: results);
      grandPrixBetRepository.mockGetGrandPrixBetByGrandPrixId(bets);
      final container = makeProviderContainer(
        grandPrixId: grandPrixId,
        playerId: playerId,
      );

      await expectLater(
        container.read(racePointsProvider.future),
        completion(betPoints.raceP10),
      );
      verify(
        () => grandPrixResultsRepository.getResultForGrandPrix(
          grandPrixId: grandPrixId,
        ),
      ).called(1);
      verify(
        () => grandPrixBetRepository.getGrandPrixBetByGrandPrixId(
          userId: playerId,
          grandPrixId: grandPrixId,
        ),
      ).called(1);
    },
  );

  test(
    'should add 2 points for correct fastest lap',
    () async {
      final results = createGrandPrixResults(fastestLapDriverId: 'd1');
      final bets = createGrandPrixBet(fastestLapDriverId: 'd1');
      grandPrixResultsRepository.mockGetResultsForGrandPrix(results: results);
      grandPrixBetRepository.mockGetGrandPrixBetByGrandPrixId(bets);
      final container = makeProviderContainer(
        grandPrixId: grandPrixId,
        playerId: playerId,
      );

      await expectLater(
        container.read(racePointsProvider.future),
        completion(betPoints.raceFastestLap),
      );
      verify(
        () => grandPrixResultsRepository.getResultForGrandPrix(
          grandPrixId: grandPrixId,
        ),
      ).called(1);
      verify(
        () => grandPrixBetRepository.getGrandPrixBetByGrandPrixId(
          userId: playerId,
          grandPrixId: grandPrixId,
        ),
      ).called(1);
    },
  );

  test(
    'should sum points of each correct hit',
    () async {
      final results = createGrandPrixResults(
        p1DriverId: 'd1',
        p10DriverId: 'd10',
        fastestLapDriverId: 'd1',
      );
      final bets = createGrandPrixBet(
        p1DriverId: 'd1',
        p10DriverId: 'd10',
        fastestLapDriverId: 'd1',
      );
      final double expectedPoints =
          (betPoints.raceP1 + betPoints.raceP10 + betPoints.raceFastestLap)
              .toDouble();
      grandPrixResultsRepository.mockGetResultsForGrandPrix(results: results);
      grandPrixBetRepository.mockGetGrandPrixBetByGrandPrixId(bets);
      final container = makeProviderContainer(
        grandPrixId: grandPrixId,
        playerId: playerId,
      );

      await expectLater(
        container.read(racePointsProvider.future),
        completion(expectedPoints),
      );
      verify(
        () => grandPrixResultsRepository.getResultForGrandPrix(
          grandPrixId: grandPrixId,
        ),
      ).called(1);
      verify(
        () => grandPrixBetRepository.getGrandPrixBetByGrandPrixId(
          userId: playerId,
          grandPrixId: grandPrixId,
        ),
      ).called(1);
    },
  );

  test(
    'should multiply points from p1, p2, p3 and p10 by 1.5 if bets are correct',
    () async {
      final results = createGrandPrixResults(
        p1DriverId: 'd1',
        p2DriverId: 'd2',
        p3DriverId: 'd3',
        p10DriverId: 'd10',
      );
      final bets = createGrandPrixBet(
        p1DriverId: 'd1',
        p2DriverId: 'd2',
        p3DriverId: 'd3',
        p10DriverId: 'd10',
      );
      final double expectedPoints = (betPoints.raceP1 +
              betPoints.raceP2 +
              betPoints.raceP3 +
              betPoints.raceP10) *
          betMultipliers.perfectRacePodiumAndP10;
      grandPrixResultsRepository.mockGetResultsForGrandPrix(results: results);
      grandPrixBetRepository.mockGetGrandPrixBetByGrandPrixId(bets);
      final container = makeProviderContainer(
        grandPrixId: grandPrixId,
        playerId: playerId,
      );

      await expectLater(
        container.read(racePointsProvider.future),
        completion(expectedPoints),
      );
      verify(
        () => grandPrixResultsRepository.getResultForGrandPrix(
          grandPrixId: grandPrixId,
        ),
      ).called(1);
      verify(
        () => grandPrixBetRepository.getGrandPrixBetByGrandPrixId(
          userId: playerId,
          grandPrixId: grandPrixId,
        ),
      ).called(1);
    },
  );

  test(
    'if all bets are correct should only multiply points from p1, p2, p3 and '
    'p10 by 1.5 and should add points for fastest lap to it',
    () async {
      final results = createGrandPrixResults(
        p1DriverId: 'd1',
        p2DriverId: 'd2',
        p3DriverId: 'd3',
        p10DriverId: 'd10',
        fastestLapDriverId: 'd1',
      );
      final bets = createGrandPrixBet(
        p1DriverId: 'd1',
        p2DriverId: 'd2',
        p3DriverId: 'd3',
        p10DriverId: 'd10',
        fastestLapDriverId: 'd1',
      );
      final double expectedPoints = ((betPoints.raceP1 +
                  betPoints.raceP2 +
                  betPoints.raceP3 +
                  betPoints.raceP10) *
              betMultipliers.perfectRacePodiumAndP10) +
          betPoints.raceFastestLap;
      grandPrixResultsRepository.mockGetResultsForGrandPrix(results: results);
      grandPrixBetRepository.mockGetGrandPrixBetByGrandPrixId(bets);
      final container = makeProviderContainer(
        grandPrixId: grandPrixId,
        playerId: playerId,
      );

      await expectLater(
        container.read(racePointsProvider.future),
        completion(expectedPoints),
      );
      verify(
        () => grandPrixResultsRepository.getResultForGrandPrix(
          grandPrixId: grandPrixId,
        ),
      ).called(1);
      verify(
        () => grandPrixBetRepository.getGrandPrixBetByGrandPrixId(
          userId: playerId,
          grandPrixId: grandPrixId,
        ),
      ).called(1);
    },
  );
}
