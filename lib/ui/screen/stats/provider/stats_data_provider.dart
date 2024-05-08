import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/repository/grand_prix_bet_points/grand_prix_bet_points_repository.dart';
import '../../../../data/repository/player/player_repository.dart';
import '../../../../dependency_injection.dart';
import '../../../../model/grand_prix.dart';
import '../../../../model/grand_prix_bet_points.dart';
import '../../../../model/player.dart';
import 'finished_grand_prixes_provider.dart';
import 'players_podium_chart_data.dart';
import 'points_by_driver_data.dart';
import 'points_for_driver_in_grand_prix_provider.dart';
import 'points_history_chart_data.dart';

part 'stats_data_provider.freezed.dart';
part 'stats_data_provider.g.dart';

@riverpod
class Stats extends _$Stats {
  List<Player>? _allPlayers;
  List<GrandPrix>? _finishedGrandPrixes;
  List<GrandPrixBetPoints>? _pointsForBets;

  @override
  Future<StatsData?> build() async {
    _allPlayers = await getIt.get<PlayerRepository>().getAllPlayers().first;
    if (_allPlayers == null || _allPlayers!.isEmpty) return null;
    _finishedGrandPrixes = await ref.watch(finishedGrandPrixesProvider.future);
    _pointsForBets = [];
    for (final player in _allPlayers!) {
      for (final gp in _finishedGrandPrixes!) {
        final pointsForGrandPrixBets = await getIt
            .get<GrandPrixBetPointsRepository>()
            .getPointsForPlayerByGrandPrixId(
              playerId: player.id,
              grandPrixId: gp.id,
            )
            .first;
        if (pointsForGrandPrixBets != null) {
          _pointsForBets!.add(pointsForGrandPrixBets);
        }
      }
    }
    return StatsData(
      playersPodiumChartData: _createPlayersPodiumChartData(),
      pointsHistoryChartData: _createPointsHistoryChartData(),
      pointsByDriverChartData: const [],
    );
  }

  Future<void> onDriverChanged(String driverId) async {
    if (_allPlayers == null ||
        _finishedGrandPrixes == null ||
        _pointsForBets == null) {
      return;
    }
    state = const AsyncLoading<StatsData>();
    state = AsyncData(
      state.value?.copyWith(
        pointsByDriverChartData: await _createPointsByDriverData(driverId),
      ),
    );
  }

  PlayersPodiumChartData _createPlayersPodiumChartData() {
    final List<PlayersPodiumChartPlayer> players = [];
    for (final player in _allPlayers!) {
      final Iterable<double> pointsForEachGp = _pointsForBets!
          .where((betPoints) => betPoints.playerId == player.id)
          .map((betPoints) => betPoints.totalPoints);
      players.add(PlayersPodiumChartPlayer(
        player: player,
        points: pointsForEachGp.isNotEmpty
            ? pointsForEachGp.reduce((sum, points) => sum + points)
            : 0.0,
      ));
    }
    players.sort((p1, p2) => p1.points < p2.points ? 1 : -1);
    return PlayersPodiumChartData(
      p1Player: players.first,
      p2Player: players.length >= 2 ? players[1] : null,
      p3Player: players.length >= 3 ? players[2] : null,
    );
  }

  PointsHistoryChartData _createPointsHistoryChartData() {
    final List<PointsHistoryChartGrandPrix> chartGrandPrixes = [];
    final List<GrandPrix> sortedFinishedGrandPrixes = [
      ..._finishedGrandPrixes!,
    ];
    sortedFinishedGrandPrixes.sort(
      (gp1, gp2) => gp1.startDate.isBefore(gp2.startDate) ? -1 : 1,
    );
    for (final gp in sortedFinishedGrandPrixes) {
      final List<PointsHistoryChartPlayerPoints> playersPoints = [];
      for (final player in _allPlayers!) {
        final double pointsForGrandPrix =
            _getPointsReceivedByPlayerForGp(player.id, gp.id)?.totalPoints ??
                0.0;
        final sumFromPreviousGrandPrixes = chartGrandPrixes.isNotEmpty
            ? chartGrandPrixes.last.playersPoints
                .firstWhere((el) => el.playerId == player.id)
                .points
            : 0;
        playersPoints.add(PointsHistoryChartPlayerPoints(
          playerId: player.id,
          points: sumFromPreviousGrandPrixes + pointsForGrandPrix,
        ));
      }
      chartGrandPrixes.add(PointsHistoryChartGrandPrix(
        roundNumber: gp.roundNumber,
        playersPoints: playersPoints,
      ));
    }
    return PointsHistoryChartData(
      players: _allPlayers!,
      chartGrandPrixes: chartGrandPrixes,
    );
  }

  Future<List<PointsByDriverPlayerPoints>> _createPointsByDriverData(
    String driverId,
  ) async {
    final List<PointsByDriverPlayerPoints> playersPoints = [];
    for (final player in _allPlayers!) {
      double playerPointsForDriver = 0.0;
      for (final gp in _finishedGrandPrixes!) {
        final playerPointsForGp =
            _getPointsReceivedByPlayerForGp(player.id, gp.id);
        final playerPointsForDriverInGp = playerPointsForGp != null
            ? await ref.watch(
                pointsForDriverInGrandPrixProvider(
                  playerId: player.id,
                  grandPrixId: gp.id,
                  driverId: driverId,
                  grandPrixBetPoints: playerPointsForGp,
                ).future,
              )
            : 0.0;
        playerPointsForDriver += playerPointsForDriverInGp;
      }
      playersPoints.add(PointsByDriverPlayerPoints(
        player: player,
        points: playerPointsForDriver,
      ));
    }
    return playersPoints;
  }

  GrandPrixBetPoints? _getPointsReceivedByPlayerForGp(
    String playerId,
    String gpId,
  ) =>
      _pointsForBets?.firstWhereOrNull(
        (GrandPrixBetPoints betPoints) =>
            betPoints.playerId == playerId && betPoints.grandPrixId == gpId,
      );
}

@freezed
class StatsData with _$StatsData {
  const factory StatsData({
    required PlayersPodiumChartData playersPodiumChartData,
    required PointsHistoryChartData pointsHistoryChartData,
    required List<PointsByDriverPlayerPoints> pointsByDriverChartData,
  }) = _StatsData;
}
