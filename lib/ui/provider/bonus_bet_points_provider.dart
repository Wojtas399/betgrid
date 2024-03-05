import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

import '../../data/repository/grand_prix_bet/grand_prix_bet_repository.dart';
import '../../data/repository/grand_prix_result/grand_prix_results_repository.dart';
import '../../dependency_injection.dart';
import '../../model/grand_prix_bet.dart';
import '../../model/grand_prix_results.dart';
import '../config/bet_points_config.dart';
import '../config/bet_points_multipliers_config.dart';

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
    ref.watch(grandPrixResultsRepositoryProvider).getResultForGrandPrix(
          grandPrixId: grandPrixId,
        ),
    (bets, results) => _ListenedParams(bets: bets, results: results),
  );
  final betPoints = getIt<BetPointsConfig>();
  final betMultipliers = getIt<BetPointsMultipliersConfig>();
  await for (final params in params$) {
    final GrandPrixBet? bets = params.bets;
    final GrandPrixResults? results = params.results;
    if (bets == null || results == null) {
      yield 0.0;
      continue;
    }
    double points = 0;
    if (results.dnfDriverIds != null) {
      final int numberOfDnfHits = bets.dnfDriverIds
          .where((driverId) => results.dnfDriverIds!.contains(driverId))
          .length;
      points += numberOfDnfHits * betPoints.raceOneDnfDriver;
      if (numberOfDnfHits == 3) {
        points *= betMultipliers.perfectDnf;
      }
    }
    if (results.wasThereSafetyCar != null &&
        results.wasThereSafetyCar == bets.willBeSafetyCar) {
      points += betPoints.raceSafetyCar;
    }
    if (results.wasThereRedFlag != null &&
        results.wasThereRedFlag == bets.willBeRedFlag) {
      points += betPoints.raceRedFlag;
    }
    yield points;
  }
}

class _ListenedParams extends Equatable {
  final GrandPrixBet? bets;
  final GrandPrixResults? results;

  const _ListenedParams({this.bets, this.results});

  @override
  List<Object?> get props => [bets, results];
}
