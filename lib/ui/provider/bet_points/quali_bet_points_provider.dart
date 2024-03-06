import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

import '../../../data/repository/grand_prix_bet/grand_prix_bet_repository.dart';
import '../../../data/repository/grand_prix_result/grand_prix_results_repository.dart';
import '../../../dependency_injection.dart';
import '../../../model/grand_prix_bet.dart';
import '../../../model/grand_prix_results.dart';
import '../../config/bet_points_multipliers_config.dart';
import 'quali_position_bet_points_provider.dart';

part 'quali_bet_points_provider.g.dart';

@riverpod
Stream<double?> qualiBetPoints(
  QualiBetPointsRef ref, {
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
  final betMultipliers = getIt<BetPointsMultipliersConfig>();
  await for (final params in params$) {
    final GrandPrixBet? bets = params.bets;
    final GrandPrixResults? results = params.results;
    if (bets == null ||
        results == null ||
        results.qualiStandingsByDriverIds == null) {
      yield 0.0;
      continue;
    }
    int points = 0, numOfQ1Hits = 0, numOfQ2Hits = 0, numOfQ3Hits = 0;
    for (int i = 0; i < 20; i++) {
      final int? positionPoints = ref.read(qualiPositionBetPointsProvider(
        betStandings: bets.qualiStandingsByDriverIds,
        resultsStandings: results.qualiStandingsByDriverIds!,
        positionIndex: i,
      ));
      if (positionPoints != null && positionPoints > 0) {
        points += positionPoints;
        if (i >= 15) {
          numOfQ1Hits++;
        } else if (i >= 10) {
          numOfQ2Hits++;
        } else {
          numOfQ3Hits++;
        }
      }
    }
    double multiplier = 0;
    if (numOfQ1Hits == 5) multiplier += betMultipliers.perfectQ1;
    if (numOfQ2Hits == 5) multiplier += betMultipliers.perfectQ2;
    if (numOfQ3Hits == 10) multiplier += betMultipliers.perfectQ3;
    yield points * (multiplier == 0 ? 1 : multiplier);
  }
}

class _ListenedParams extends Equatable {
  final GrandPrixBet? bets;
  final GrandPrixResults? results;

  const _ListenedParams({this.bets, this.results});

  @override
  List<Object?> get props => [bets, results];
}
