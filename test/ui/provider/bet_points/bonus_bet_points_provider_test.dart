import 'package:betgrid/data/repository/grand_prix_bet/grand_prix_bet_repository.dart';
import 'package:betgrid/data/repository/grand_prix_result/grand_prix_results_repository.dart';
import 'package:betgrid/ui/config/bet_points_config.dart';
import 'package:betgrid/ui/config/bet_points_multipliers_config.dart';
import 'package:betgrid/ui/provider/bet_points/bonus_bet_points_provider.dart';
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

  ProviderContainer makeProviderContainer() {
    final container = ProviderContainer(
      overrides: [
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
    reset(grandPrixBetRepository);
  });

  test(
    'should emit 0 if player does not have bets for given grand prix',
    () async {
      grandPrixBetRepository.mockGetBetByGrandPrixIdAndPlayerId(null);
      grandPrixResultsRepository.mockGetResultsForGrandPrix(
        results: createGrandPrixResults(),
      );

      final container = makeProviderContainer();

      await expectLater(
        container.read(
          bonusBetPointsProvider(
            grandPrixId: grandPrixId,
            playerId: playerId,
          ).future,
        ),
        completion(0.0),
      );
    },
  );

  test(
    'should emit 0 if there are no results for given grand prix',
    () async {
      grandPrixBetRepository.mockGetBetByGrandPrixIdAndPlayerId(
        createGrandPrixBet(),
      );
      grandPrixResultsRepository.mockGetResultsForGrandPrix(results: null);

      final container = makeProviderContainer();

      await expectLater(
        container.read(
          bonusBetPointsProvider(
            grandPrixId: grandPrixId,
            playerId: playerId,
          ).future,
        ),
        completion(0.0),
      );
    },
  );

  test(
    'should add 1 point for each dnf driver hit',
    () async {
      const List<String> dnfDriverIds = ['d1', 'd2', 'd3'];
      const List<String?> betDnfDriverIds = ['d1', null, 'd3'];
      final double expectedPoints = 2.0 * betPoints.raceOneDnfDriver;
      grandPrixBetRepository.mockGetBetByGrandPrixIdAndPlayerId(
        createGrandPrixBet(dnfDriverIds: betDnfDriverIds),
      );
      grandPrixResultsRepository.mockGetResultsForGrandPrix(
        results: createGrandPrixResults(dnfDriverIds: dnfDriverIds),
      );

      final container = makeProviderContainer();

      await expectLater(
        container.read(
          bonusBetPointsProvider(
            grandPrixId: grandPrixId,
            playerId: playerId,
          ).future,
        ),
        completion(expectedPoints),
      );
    },
  );

  test(
    'should multiply points for dnf drivers by 1.5 if all 3 bets are '
    'correct',
    () async {
      const List<String> dnfDriverIds = ['d0', 'd1', 'd2', 'd3', 'd4'];
      const List<String?> betDnfDriverIds = ['d1', 'd2', 'd3'];
      final double expectedPoints =
          (3 * betPoints.raceOneDnfDriver) * betMultipliers.perfectDnf;
      grandPrixBetRepository.mockGetBetByGrandPrixIdAndPlayerId(
        createGrandPrixBet(dnfDriverIds: betDnfDriverIds),
      );
      grandPrixResultsRepository.mockGetResultsForGrandPrix(
        results: createGrandPrixResults(dnfDriverIds: dnfDriverIds),
      );

      final container = makeProviderContainer();

      await expectLater(
        container.read(
          bonusBetPointsProvider(
            grandPrixId: grandPrixId,
            playerId: playerId,
          ).future,
        ),
        completion(expectedPoints),
      );
    },
  );

  test(
    'should add 1 point for correct safety car bet',
    () async {
      final double expectedPoints = betPoints.raceSafetyCar.toDouble();
      grandPrixBetRepository.mockGetBetByGrandPrixIdAndPlayerId(
        createGrandPrixBet(willBeSafetyCar: true),
      );
      grandPrixResultsRepository.mockGetResultsForGrandPrix(
        results: createGrandPrixResults(wasThereSafetyCar: true),
      );

      final container = makeProviderContainer();

      await expectLater(
        container.read(
          bonusBetPointsProvider(
            grandPrixId: grandPrixId,
            playerId: playerId,
          ).future,
        ),
        completion(expectedPoints),
      );
    },
  );

  test(
    'should not add 1 point for safety car if bet is null',
    () async {
      const double expectedPoints = 0.0;
      grandPrixBetRepository.mockGetBetByGrandPrixIdAndPlayerId(
        createGrandPrixBet(willBeSafetyCar: null),
      );
      grandPrixResultsRepository.mockGetResultsForGrandPrix(
        results: createGrandPrixResults(wasThereSafetyCar: true),
      );

      final container = makeProviderContainer();

      await expectLater(
        container.read(
          bonusBetPointsProvider(
            grandPrixId: grandPrixId,
            playerId: playerId,
          ).future,
        ),
        completion(expectedPoints),
      );
    },
  );

  test(
    'should add 1 point for correct red flag bet',
    () async {
      final double expectedPoints = betPoints.raceSafetyCar.toDouble();
      grandPrixBetRepository.mockGetBetByGrandPrixIdAndPlayerId(
        createGrandPrixBet(willBeRedFlag: false),
      );
      grandPrixResultsRepository.mockGetResultsForGrandPrix(
        results: createGrandPrixResults(wasThereRedFlag: false),
      );

      final container = makeProviderContainer();

      await expectLater(
        container.read(
          bonusBetPointsProvider(
            grandPrixId: grandPrixId,
            playerId: playerId,
          ).future,
        ),
        completion(expectedPoints),
      );
    },
  );

  test(
    'should not add 1 point for red flag if bet is null',
    () async {
      const double expectedPoints = 0.0;
      grandPrixBetRepository.mockGetBetByGrandPrixIdAndPlayerId(
        createGrandPrixBet(willBeRedFlag: null),
      );
      grandPrixResultsRepository.mockGetResultsForGrandPrix(
        results: createGrandPrixResults(wasThereRedFlag: false),
      );

      final container = makeProviderContainer();

      await expectLater(
        container.read(
          bonusBetPointsProvider(
            grandPrixId: grandPrixId,
            playerId: playerId,
          ).future,
        ),
        completion(expectedPoints),
      );
    },
  );

  test(
    'should sum points of each correct bonus bet',
    () async {
      const List<String> dnfDriverIds = ['d0', 'd1', 'd2', 'd3', 'd4'];
      const List<String?> betDnfDriverIds = ['d1', 'd2', 'd3'];
      final double pointsForDnfDrivers =
          (3 * betPoints.raceOneDnfDriver) * betMultipliers.perfectDnf;
      final double expectedPoints =
          pointsForDnfDrivers + betPoints.raceSafetyCar + betPoints.raceRedFlag;
      grandPrixBetRepository.mockGetBetByGrandPrixIdAndPlayerId(
        createGrandPrixBet(
          dnfDriverIds: betDnfDriverIds,
          willBeSafetyCar: false,
          willBeRedFlag: true,
        ),
      );
      grandPrixResultsRepository.mockGetResultsForGrandPrix(
        results: createGrandPrixResults(
          dnfDriverIds: dnfDriverIds,
          wasThereSafetyCar: false,
          wasThereRedFlag: true,
        ),
      );

      final container = makeProviderContainer();

      await expectLater(
        container.read(
          bonusBetPointsProvider(
            grandPrixId: grandPrixId,
            playerId: playerId,
          ).future,
        ),
        completion(expectedPoints),
      );
    },
  );
}
