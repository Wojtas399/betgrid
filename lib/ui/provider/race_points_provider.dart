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
import 'grand_prix_id_provider.dart';
import 'player_id_provider.dart';

part 'race_points_provider.g.dart';

@Riverpod(dependencies: [grandPrixId, playerId])
Stream<double?> racePoints(RacePointsRef ref) async* {
  final String? grandPrixId = ref.watch(grandPrixIdProvider);
  final String? playerId = ref.watch(playerIdProvider);
  if (grandPrixId == null || playerId == null) {
    yield null;
  } else {
    final Stream<_ListenedParams> params$ = Rx.combineLatest2(
      ref.watch(grandPrixBetRepositoryProvider).getGrandPrixBetByGrandPrixId(
            userId: playerId,
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
      bool isP1Correct = false,
          isP2Correct = false,
          isP3Correct = false,
          isP10Correct = false;
      double points = 0;
      if (results.p1DriverId != null && bets.p1DriverId == results.p1DriverId) {
        points += betPoints.raceP1;
        isP1Correct = true;
      }
      if (results.p2DriverId != null && bets.p2DriverId == results.p2DriverId) {
        points += betPoints.raceP2;
        isP2Correct = true;
      }
      if (results.p3DriverId != null && bets.p3DriverId == results.p3DriverId) {
        points += betPoints.raceP3;
        isP3Correct = true;
      }
      if (results.p10DriverId != null &&
          bets.p10DriverId == results.p10DriverId) {
        points += betPoints.raceP10;
        isP10Correct = true;
      }
      if (isP1Correct && isP2Correct && isP3Correct && isP10Correct) {
        points *= betMultipliers.perfectRacePodiumAndP10;
      }
      if (results.fastestLapDriverId != null &&
          bets.fastestLapDriverId == results.fastestLapDriverId) {
        points += betPoints.raceFastestLap;
      }
      yield points;
    }
  }
}

class _ListenedParams extends Equatable {
  final GrandPrixBet? bets;
  final GrandPrixResults? results;

  const _ListenedParams({this.bets, this.results});

  @override
  List<Object?> get props => [bets, results];
}
