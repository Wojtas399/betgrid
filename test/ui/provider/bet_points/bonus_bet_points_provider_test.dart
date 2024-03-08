import 'package:betgrid/data/repository/grand_prix_bet/grand_prix_bet_repository.dart';
import 'package:betgrid/data/repository/grand_prix_result/grand_prix_results_repository.dart';
import 'package:betgrid/ui/config/bet_points_config.dart';
import 'package:betgrid/ui/config/bet_points_multipliers_config.dart';
import 'package:betgrid/ui/provider/bet_points/bonus_bet_points_provider.dart';
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
    reset(grandPrixBetRepository);
  });

  test(
    'grand prix id is null, '
    'should emit null',
    () async {
      final container = makeProviderContainer(playerId: playerId);

      await expectLater(
        container.read(bonusBetPointsProvider.future),
        completion(null),
      );
    },
  );

  test(
    'player id is null, '
    'should emit null',
    () async {
      final container = makeProviderContainer(grandPrixId: grandPrixId);

      await expectLater(
        container.read(bonusBetPointsProvider.future),
        completion(null),
      );
    },
  );

  test(
    'should emit null if there are no results for given grand prix, ',
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
        container.read(bonusBetPointsProvider.future),
        completion(null),
      );
    },
  );

  test(
    'should emit null if there are no race results for given grand prix, ',
    () async {
      grandPrixBetRepository.mockGetBetByGrandPrixIdAndPlayerId(
        createGrandPrixBet(),
      );
      grandPrixResultsRepository.mockGetResultsForGrandPrix(
        results: createGrandPrixResults(raceResults: null),
      );

      final container = makeProviderContainer(
        grandPrixId: grandPrixId,
        playerId: playerId,
      );

      await expectLater(
        container.read(bonusBetPointsProvider.future),
        completion(null),
      );
    },
  );

  test(
    'should emit 0 total points if player does not have bets for given grand prix',
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
        container.read(bonusBetPointsProvider.future),
        completion(
          const BonusBetPointsDetails(
            totalPoints: 0.0,
            dnfDriversPoints: 0,
            safetyCarAndRedFlagPoints: 0,
          ),
        ),
      );
    },
  );

  test(
    'should add 1 point for each dnf driver hit',
    () async {
      const List<String> dnfDriverIds = ['d1', 'd2', 'd3'];
      const List<String?> betDnfDriverIds = ['d1', null, 'd3'];
      final int dnfDriversPoints = 2 * betPoints.raceOneDnfDriver;
      grandPrixBetRepository.mockGetBetByGrandPrixIdAndPlayerId(
        createGrandPrixBet(dnfDriverIds: betDnfDriverIds),
      );
      grandPrixResultsRepository.mockGetResultsForGrandPrix(
        results: createGrandPrixResults(
          raceResults: createRaceResults(
            dnfDriverIds: dnfDriverIds,
          ),
        ),
      );

      final container = makeProviderContainer(
        grandPrixId: grandPrixId,
        playerId: playerId,
      );

      await expectLater(
        container.read(bonusBetPointsProvider.future),
        completion(
          BonusBetPointsDetails(
            totalPoints: dnfDriversPoints.toDouble(),
            dnfDriversPoints: dnfDriversPoints,
            safetyCarAndRedFlagPoints: 0,
          ),
        ),
      );
    },
  );

  test(
    'should multiply points for dnf drivers by 1.5 if all 3 bets are '
    'correct',
    () async {
      const List<String> dnfDriverIds = ['d0', 'd1', 'd2', 'd3', 'd4'];
      const List<String?> betDnfDriverIds = ['d1', 'd2', 'd3'];
      final int dnfDriversPoints = 3 * betPoints.raceOneDnfDriver;
      final double multiplier = betMultipliers.perfectDnf;
      final double totalPoints = dnfDriversPoints * multiplier;
      grandPrixBetRepository.mockGetBetByGrandPrixIdAndPlayerId(
        createGrandPrixBet(dnfDriverIds: betDnfDriverIds),
      );
      grandPrixResultsRepository.mockGetResultsForGrandPrix(
        results: createGrandPrixResults(
          raceResults: createRaceResults(
            dnfDriverIds: dnfDriverIds,
          ),
        ),
      );

      final container = makeProviderContainer(
        grandPrixId: grandPrixId,
        playerId: playerId,
      );

      await expectLater(
        container.read(bonusBetPointsProvider.future),
        completion(
          BonusBetPointsDetails(
            totalPoints: totalPoints,
            dnfDriversPoints: dnfDriversPoints,
            dnfDriversPointsMultiplier: multiplier,
            safetyCarAndRedFlagPoints: 0,
          ),
        ),
      );
    },
  );

  test(
    'should add 1 point for correct safety car bet',
    () async {
      final int safetyCarPoints = betPoints.raceSafetyCar;
      grandPrixBetRepository.mockGetBetByGrandPrixIdAndPlayerId(
        createGrandPrixBet(willBeSafetyCar: true),
      );
      grandPrixResultsRepository.mockGetResultsForGrandPrix(
        results: createGrandPrixResults(
          raceResults: createRaceResults(wasThereSafetyCar: true),
        ),
      );

      final container = makeProviderContainer(
        grandPrixId: grandPrixId,
        playerId: playerId,
      );

      await expectLater(
        container.read(bonusBetPointsProvider.future),
        completion(
          BonusBetPointsDetails(
            totalPoints: safetyCarPoints.toDouble(),
            dnfDriversPoints: 0,
            safetyCarAndRedFlagPoints: safetyCarPoints,
          ),
        ),
      );
    },
  );

  test(
    'should not add 1 point for safety car if bet for it is null',
    () async {
      const int safetyCarPoints = 0;
      grandPrixBetRepository.mockGetBetByGrandPrixIdAndPlayerId(
        createGrandPrixBet(willBeSafetyCar: null),
      );
      grandPrixResultsRepository.mockGetResultsForGrandPrix(
        results: createGrandPrixResults(
          raceResults: createRaceResults(wasThereSafetyCar: true),
        ),
      );

      final container = makeProviderContainer(
        grandPrixId: grandPrixId,
        playerId: playerId,
      );

      await expectLater(
        container.read(bonusBetPointsProvider.future),
        completion(
          BonusBetPointsDetails(
            totalPoints: safetyCarPoints.toDouble(),
            dnfDriversPoints: 0,
            safetyCarAndRedFlagPoints: safetyCarPoints,
          ),
        ),
      );
    },
  );

  test(
    'should add 1 point for correct red flag bet',
    () async {
      final int redFlagPoints = betPoints.raceSafetyCar;
      grandPrixBetRepository.mockGetBetByGrandPrixIdAndPlayerId(
        createGrandPrixBet(willBeRedFlag: false),
      );
      grandPrixResultsRepository.mockGetResultsForGrandPrix(
        results: createGrandPrixResults(
          raceResults: createRaceResults(wasThereRedFlag: false),
        ),
      );

      final container = makeProviderContainer(
        grandPrixId: grandPrixId,
        playerId: playerId,
      );

      await expectLater(
        container.read(bonusBetPointsProvider.future),
        completion(
          BonusBetPointsDetails(
            totalPoints: redFlagPoints.toDouble(),
            dnfDriversPoints: 0,
            safetyCarAndRedFlagPoints: redFlagPoints,
          ),
        ),
      );
    },
  );

  test(
    'should not add 1 point for red flag if bet for it is null',
    () async {
      const int redFlagPoints = 0;
      grandPrixBetRepository.mockGetBetByGrandPrixIdAndPlayerId(
        createGrandPrixBet(willBeRedFlag: null),
      );
      grandPrixResultsRepository.mockGetResultsForGrandPrix(
        results: createGrandPrixResults(
          raceResults: createRaceResults(wasThereRedFlag: false),
        ),
      );

      final container = makeProviderContainer(
        grandPrixId: grandPrixId,
        playerId: playerId,
      );

      await expectLater(
        container.read(bonusBetPointsProvider.future),
        completion(
          BonusBetPointsDetails(
            totalPoints: redFlagPoints.toDouble(),
            dnfDriversPoints: 0,
            safetyCarAndRedFlagPoints: redFlagPoints,
          ),
        ),
      );
    },
  );

  test(
    'should sum points of each correct bonus bet',
    () async {
      const List<String> dnfDriverIds = ['d0', 'd1', 'd2', 'd3', 'd4'];
      const List<String?> betDnfDriverIds = ['d1', 'd2', 'd3'];
      final int dnfDriversPoints = 3 * betPoints.raceOneDnfDriver;
      final double dnfDriversPointsMultiplier = betMultipliers.perfectDnf;
      final int safetyCarAndRedFlagPoints =
          betPoints.raceSafetyCar + betPoints.raceRedFlag;
      final double totalPoints =
          (dnfDriversPoints * dnfDriversPointsMultiplier) +
              safetyCarAndRedFlagPoints;
      grandPrixBetRepository.mockGetBetByGrandPrixIdAndPlayerId(
        createGrandPrixBet(
          dnfDriverIds: betDnfDriverIds,
          willBeSafetyCar: false,
          willBeRedFlag: true,
        ),
      );
      grandPrixResultsRepository.mockGetResultsForGrandPrix(
        results: createGrandPrixResults(
          raceResults: createRaceResults(
            dnfDriverIds: dnfDriverIds,
            wasThereSafetyCar: false,
            wasThereRedFlag: true,
          ),
        ),
      );

      final container = makeProviderContainer(
        grandPrixId: grandPrixId,
        playerId: playerId,
      );

      await expectLater(
        container.read(bonusBetPointsProvider.future),
        completion(
          BonusBetPointsDetails(
            totalPoints: totalPoints,
            dnfDriversPoints: dnfDriversPoints,
            dnfDriversPointsMultiplier: dnfDriversPointsMultiplier,
            safetyCarAndRedFlagPoints: safetyCarAndRedFlagPoints,
          ),
        ),
      );
    },
  );
}
