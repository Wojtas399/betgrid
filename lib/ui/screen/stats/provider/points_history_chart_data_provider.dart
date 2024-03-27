import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/repository/player/player_repository_method_providers.dart';
import '../../../../model/player.dart';
import '../../../provider/grand_prix_bet_points_provider.dart';
import 'finished_grand_prixes_provider.dart';

part 'points_history_chart_data_provider.g.dart';

@riverpod
Future<PointsHistoryChartData?> pointsHistoryChartData(
  PointsHistoryChartDataRef ref,
) async {
  final allPlayers = await ref.read(allPlayersProvider.future);
  if (allPlayers == null) return null;
  final terminatedGrandPrixes =
      await ref.watch(finishedGrandPrixesProvider.future);
  final List<PointsHistoryChartGrandPrix> chartGrandPrixes = [];
  for (final gp in terminatedGrandPrixes) {
    final List<PointsHistoryChartPlayerPoints> playersPoints = [];
    for (final player in allPlayers) {
      final double pointsForGrandPrix = await ref.watch(
            grandPrixBetPointsProvider(
              grandPrixId: gp.id,
              playerId: player.id,
            ).selectAsync((betPoints) => betPoints?.totalPoints),
          ) ??
          0.0;
      final sumFromPreviousGrandPrixes = chartGrandPrixes.isNotEmpty
          ? chartGrandPrixes.last.playersPoints
              .firstWhere((el) => el.playerId == player.id)
              .points
          : 0;
      playersPoints.add(
        PointsHistoryChartPlayerPoints(
          playerId: player.id,
          points: sumFromPreviousGrandPrixes + pointsForGrandPrix,
        ),
      );
    }
    chartGrandPrixes.add(
      PointsHistoryChartGrandPrix(
        grandPrixName: gp.name,
        playersPoints: playersPoints,
      ),
    );
  }
  return PointsHistoryChartData(
    players: allPlayers,
    chartGrandPrixes: chartGrandPrixes,
  );
}

class PointsHistoryChartData extends Equatable {
  final List<Player> players;
  final List<PointsHistoryChartGrandPrix> chartGrandPrixes;

  const PointsHistoryChartData({
    required this.players,
    required this.chartGrandPrixes,
  });

  @override
  List<Object?> get props => [players, chartGrandPrixes];
}

class PointsHistoryChartGrandPrix extends Equatable {
  final String grandPrixName;
  final List<PointsHistoryChartPlayerPoints> playersPoints;

  const PointsHistoryChartGrandPrix({
    required this.grandPrixName,
    required this.playersPoints,
  });

  @override
  List<Object?> get props => [grandPrixName, playersPoints];
}

class PointsHistoryChartPlayerPoints extends Equatable {
  final String playerId;
  final double points;

  const PointsHistoryChartPlayerPoints({
    required this.playerId,
    required this.points,
  });

  @override
  List<Object?> get props => [playerId, points];
}
