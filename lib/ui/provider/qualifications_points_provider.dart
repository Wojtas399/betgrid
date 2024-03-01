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

part 'qualifications_points_provider.g.dart';

@Riverpod(dependencies: [grandPrixId, playerId])
Stream<double?> qualificationsPoints(QualificationsPointsRef ref) async* {
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
      if (bets == null ||
          results == null ||
          results.qualiStandingsByDriverIds == null) {
        yield 0.0;
        continue;
      }
      final betStandingsByDriverIds = bets.qualiStandingsByDriverIds;
      final standingsByDriverIds = results.qualiStandingsByDriverIds!;
      final q1Standings = standingsByDriverIds.sublist(15, 20);
      final q2Standings = standingsByDriverIds.sublist(10, 15);
      final q3Standings = standingsByDriverIds.sublist(0, 10);
      final betQ1Standings = betStandingsByDriverIds.sublist(15, 20);
      final betQ2Standings = betStandingsByDriverIds.sublist(10, 15);
      final betQ3Standings = betStandingsByDriverIds.sublist(0, 10);
      int points = 0, numOfQ1Hits = 0, numOfQ2Hits = 0, numOfQ3Hits = 0;
      for (int i = 0; i < 10; i++) {
        if (q3Standings[i] == betQ3Standings[i]) {
          points += i <= 2
              ? betPoints.onePositionFromP3ToP1InQ3
              : betPoints.onePositionFromP10ToP4InQ3;
          numOfQ3Hits++;
        }
        if (i < 5) {
          if (q1Standings[i] == betQ1Standings[i]) {
            points += betPoints.onePositionInQ1;
            numOfQ1Hits++;
          }
          if (q2Standings[i] == betQ2Standings[i]) {
            points += betPoints.onePositionInQ2;
            numOfQ2Hits++;
          }
        }
      }
      double multiplier = 0;
      if (numOfQ1Hits == 5) multiplier += betMultipliers.perfectQ1Multiplier;
      if (numOfQ2Hits == 5) multiplier += betMultipliers.perfectQ2Multiplier;
      if (numOfQ3Hits == 10) multiplier += betMultipliers.perfectQ3Multiplier;
      yield points * (multiplier == 0 ? 1 : multiplier);
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
