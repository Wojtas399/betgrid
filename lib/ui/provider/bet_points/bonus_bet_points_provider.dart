import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

import '../../../data/repository/grand_prix_bet/grand_prix_bet_repository.dart';
import '../../../data/repository/grand_prix_result/grand_prix_results_repository.dart';
import '../../../dependency_injection.dart';
import '../../../model/grand_prix_bet.dart';
import '../../../model/grand_prix_results.dart';
import '../../config/bet_points_config.dart';
import '../../config/bet_points_multipliers_config.dart';

part 'bonus_bet_points_provider.g.dart';

@riverpod
Stream<double?> bonusBetPoints(
  BonusBetPointsRef ref, {
  required String grandPrixId,
  required String playerId,
}) async* {
  final Stream<_ListenedParams> params$ = Rx.combineLatest2(
    ref.watch(grandPrixBetRepositoryProvider).getBetByGrandPrixIdAndPlayerId(
          playerId: playerId,
          grandPrixId: grandPrixId,
        ),
    ref
        .watch(grandPrixResultsRepositoryProvider)
        .getResultForGrandPrix(grandPrixId: grandPrixId)
        .map((results) => results?.raceResults),
    (bets, raceResults) => _ListenedParams(
      bets: bets,
      raceResults: raceResults,
    ),
  );
  final betPoints = getIt<BetPointsConfig>();
  final betMultipliers = getIt<BetPointsMultipliersConfig>();
  await for (final params in params$) {
    final GrandPrixBet? bets = params.bets;
    final RaceResults? raceResults = params.raceResults;
    if (raceResults == null) {
      yield null;
      continue;
    }
    if (bets == null) {
      yield 0.0;
      continue;
    }
    final int numberOfDnfHits = bets.dnfDriverIds
        .where((driverId) => raceResults.dnfDriverIds.contains(driverId))
        .length;
    double points = (numberOfDnfHits * betPoints.raceOneDnfDriver).toDouble();
    if (numberOfDnfHits == 3) {
      points *= betMultipliers.perfectDnf;
    }
    if (raceResults.wasThereSafetyCar == bets.willBeSafetyCar) {
      points += betPoints.raceSafetyCar;
    }
    if (raceResults.wasThereRedFlag == bets.willBeRedFlag) {
      points += betPoints.raceRedFlag;
    }
    yield points;
  }
}

class _ListenedParams extends Equatable {
  final GrandPrixBet? bets;
  final RaceResults? raceResults;

  const _ListenedParams({this.bets, this.raceResults});

  @override
  List<Object?> get props => [bets, raceResults];
}
