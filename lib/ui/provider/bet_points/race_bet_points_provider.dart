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
import 'race_single_bet_points_provider.dart';

part 'race_bet_points_provider.g.dart';

@Riverpod(dependencies: [grandPrixId, playerId])
Stream<RaceBetPointsDetails?> raceBetPoints(RaceBetPointsRef ref) async* {
  final String? grandPrixId = ref.watch(grandPrixIdProvider);
  final String? playerId = ref.watch(playerIdProvider);
  if (grandPrixId == null || playerId == null) {
    yield null;
  } else {
    final Stream<_ListenedParams> params$ = Rx.combineLatest2(
      _getGrandPrixBet(ref, playerId, grandPrixId),
      _getRaceResults(ref, grandPrixId),
      (bets, raceResults) => _ListenedParams(bets: bets, results: raceResults),
    );
    await for (final params in params$) {
      final GrandPrixBet? bets = params.bets;
      final RaceResults? results = params.results;
      if (results == null) {
        yield null;
        continue;
      }
      if (bets == null) {
        yield const RaceBetPointsDetails(
          totalPoints: 0.0,
          pointsForPositions: 0,
          pointsForFastestLap: 0,
        );
        continue;
      }
      final int p1Points = ref.watch(raceSingleBetPointsProvider(
            positionType: RacePositionType.p1,
            betDriverId: bets.p1DriverId,
            resultsDriverId: results.p1DriverId,
          )) ??
          0;
      final int p2Points = ref.watch(raceSingleBetPointsProvider(
            positionType: RacePositionType.p2,
            betDriverId: bets.p2DriverId,
            resultsDriverId: results.p2DriverId,
          )) ??
          0;
      final int p3Points = ref.watch(raceSingleBetPointsProvider(
            positionType: RacePositionType.p3,
            betDriverId: bets.p3DriverId,
            resultsDriverId: results.p3DriverId,
          )) ??
          0;
      final int p10Points = ref.watch(raceSingleBetPointsProvider(
            positionType: RacePositionType.p10,
            betDriverId: bets.p10DriverId,
            resultsDriverId: results.p10DriverId,
          )) ??
          0;
      final int pointsForPositions = p1Points + p2Points + p3Points + p10Points;
      final double? positionsPointsMultiplier =
          p1Points > 0 && p2Points > 0 && p3Points > 0 && p10Points > 0
              ? getIt<BetPointsMultipliersConfig>().perfectRacePodiumAndP10
              : null;
      final int pointsForFastestLap = ref.watch(raceSingleBetPointsProvider(
            positionType: RacePositionType.fastestLap,
            betDriverId: bets.fastestLapDriverId,
            resultsDriverId: results.fastestLapDriverId,
          )) ??
          0;
      yield RaceBetPointsDetails(
        totalPoints: ((pointsForPositions * (positionsPointsMultiplier ?? 1)) +
                pointsForFastestLap)
            .toDouble(),
        pointsForPositions: pointsForPositions,
        pointsForFastestLap: pointsForFastestLap,
        positionsPointsMultiplier: positionsPointsMultiplier,
      );
    }
  }
}

class RaceBetPointsDetails extends Equatable {
  final double totalPoints;
  final int pointsForPositions;
  final int pointsForFastestLap;
  final double? positionsPointsMultiplier;

  const RaceBetPointsDetails({
    required this.totalPoints,
    required this.pointsForPositions,
    required this.pointsForFastestLap,
    this.positionsPointsMultiplier,
  });

  @override
  List<Object?> get props => [
        totalPoints,
        pointsForPositions,
        pointsForFastestLap,
        positionsPointsMultiplier,
      ];
}

class _ListenedParams extends Equatable {
  final GrandPrixBet? bets;
  final RaceResults? results;

  const _ListenedParams({this.bets, this.results});

  @override
  List<Object?> get props => [bets, results];
}

Stream<GrandPrixBet?> _getGrandPrixBet(
  RaceBetPointsRef ref,
  String playerId,
  String grandPrixId,
) =>
    ref.watch(grandPrixBetRepositoryProvider).getBetByGrandPrixIdAndPlayerId(
          playerId: playerId,
          grandPrixId: grandPrixId,
        );

Stream<RaceResults?> _getRaceResults(
  RaceBetPointsRef ref,
  String grandPrixId,
) =>
    ref
        .watch(grandPrixResultsRepositoryProvider)
        .getResultForGrandPrix(grandPrixId: grandPrixId)
        .map((results) => results?.raceResults);
