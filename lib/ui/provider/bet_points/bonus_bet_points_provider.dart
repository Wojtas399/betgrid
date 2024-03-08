import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

import '../../../data/repository/grand_prix_bet/grand_prix_bet_repository.dart';
import '../../../data/repository/grand_prix_result/grand_prix_results_repository.dart';
import '../../../dependency_injection.dart';
import '../../../model/grand_prix_bet.dart';
import '../../../model/grand_prix_results.dart';
import '../../config/bet_points_multipliers_config.dart';
import '../grand_prix/grand_prix_id_provider.dart';
import '../player/player_id_provider.dart';
import 'dnf_driver_points_provider.dart';
import 'safety_car_and_red_flag_points_provider.dart';

part 'bonus_bet_points_provider.g.dart';

@Riverpod(dependencies: [grandPrixId, playerId])
Stream<BonusBetPointsDetails?> bonusBetPoints(BonusBetPointsRef ref) async* {
  final String? grandPrixId = ref.watch(grandPrixIdProvider);
  final String? playerId = ref.watch(playerIdProvider);
  if (grandPrixId == null || playerId == null) {
    yield null;
  } else {
    final Stream<_ListenedParams> params$ = Rx.combineLatest2(
      _getGrandPrixBet(ref, playerId, grandPrixId),
      _getRaceResults(ref, grandPrixId),
      (bets, raceResults) => _ListenedParams(
        bets: bets,
        raceResults: raceResults,
      ),
    );
    final betMultipliers = getIt<BetPointsMultipliersConfig>();
    await for (final params in params$) {
      final GrandPrixBet? bets = params.bets;
      final RaceResults? raceResults = params.raceResults;
      if (raceResults == null) {
        yield null;
        continue;
      }
      if (bets == null) {
        yield const BonusBetPointsDetails(
          totalPoints: 0.0,
          dnfDriversPoints: 0,
          safetyCarAndRedFlagPoints: 0,
        );
        continue;
      }
      int dnfDriversPoints = 0;
      int numberOfDnfHits = 0;
      for (final driverId in bets.dnfDriverIds) {
        final int points = ref.watch(dnfDriverPointsProvider(
              resultsDnfDriverIds: raceResults.dnfDriverIds,
              betDnfDriverId: driverId,
            )) ??
            0;
        if (points > 0) {
          numberOfDnfHits++;
          dnfDriversPoints += points;
        }
      }
      double? dnfDriversPointsMultiplier;
      if (numberOfDnfHits == 3) {
        dnfDriversPointsMultiplier = betMultipliers.perfectDnf;
      }
      int safetyCarAndRedFlagPoints = 0;
      safetyCarAndRedFlagPoints += ref.watch(safetyCarAndRedFlagPointsProvider(
            resultsVal: raceResults.wasThereSafetyCar,
            betVal: bets.willBeSafetyCar,
          )) ??
          0;
      safetyCarAndRedFlagPoints += ref.watch(safetyCarAndRedFlagPointsProvider(
            resultsVal: raceResults.wasThereRedFlag,
            betVal: bets.willBeRedFlag,
          )) ??
          0;
      yield BonusBetPointsDetails(
        totalPoints: (dnfDriversPoints * (dnfDriversPointsMultiplier ?? 1.0)) +
            safetyCarAndRedFlagPoints,
        dnfDriversPoints: dnfDriversPoints,
        dnfDriversPointsMultiplier: dnfDriversPointsMultiplier,
        safetyCarAndRedFlagPoints: safetyCarAndRedFlagPoints,
      );
    }
  }
}

class BonusBetPointsDetails extends Equatable {
  final double totalPoints;
  final int dnfDriversPoints;
  final double? dnfDriversPointsMultiplier;
  final int safetyCarAndRedFlagPoints;

  const BonusBetPointsDetails({
    required this.totalPoints,
    required this.dnfDriversPoints,
    this.dnfDriversPointsMultiplier,
    required this.safetyCarAndRedFlagPoints,
  });

  @override
  List<Object?> get props => [
        totalPoints,
        dnfDriversPoints,
        dnfDriversPointsMultiplier,
        safetyCarAndRedFlagPoints,
      ];
}

class _ListenedParams extends Equatable {
  final GrandPrixBet? bets;
  final RaceResults? raceResults;

  const _ListenedParams({this.bets, this.raceResults});

  @override
  List<Object?> get props => [bets, raceResults];
}

Stream<GrandPrixBet?> _getGrandPrixBet(
  BonusBetPointsRef ref,
  String playerId,
  String grandPrixId,
) =>
    ref.watch(grandPrixBetRepositoryProvider).getBetByGrandPrixIdAndPlayerId(
          playerId: playerId,
          grandPrixId: grandPrixId,
        );

Stream<RaceResults?> _getRaceResults(
  BonusBetPointsRef ref,
  String grandPrixId,
) =>
    ref
        .watch(grandPrixResultsRepositoryProvider)
        .getResultForGrandPrix(grandPrixId: grandPrixId)
        .map((results) => results?.raceResults);
