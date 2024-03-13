import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../model/player.dart';
import '../../component/avatar_component.dart';
import '../../component/gap/gap_vertical.dart';
import '../../component/padding/padding_components.dart';
import '../../component/text/body.dart';
import '../../provider/player/all_players_provider.dart';
import '../../provider/player_points_provider.dart';

@RoutePage()
class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding24(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 300,
            child: _PlayersPodium(),
          ),
        ],
      ),
    );
  }
}

class _PlayersPodium extends ConsumerWidget {
  const _PlayersPodium();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allPlayers = ref.watch(allPlayersProvider);

    return allPlayers.when(
      data: (players) {
        if (players == null) {
          return const Text('There is no players');
        }
        final List<_ChartData> data = List.generate(
          players.length,
          (index) => _ChartData(
            player: players[index],
            totalPoints: ref.watch(
                  playerPointsProvider(
                    playerId: players[index].id,
                  ),
                ) ??
                0,
          ),
        );
        data.sort((p1, p2) => p1.totalPoints < p2.totalPoints ? 1 : -1);
        List<_ChartData> top3 = [];
        if (data.length >= 3) top3 = [data[1], data[0], data[2]];

        return SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          primaryYAxis: NumericAxis(
            minimum: 0,
            maximum: top3[1].totalPoints + 20,
            // interval: 5,
          ),
          series: <CartesianSeries<_ChartData, String>>[
            ColumnSeries<_ChartData, String>(
              dataSource: top3,
              xValueMapper: (_ChartData data, _) => data.player.username,
              yValueMapper: (_ChartData data, _) => data.totalPoints,
              color: Theme.of(context).colorScheme.primary,
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
                builder: (_, ChartPoint point, ___, int columnIndex, _____) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BodyLarge(
                        '${point.y}',
                        fontWeight: FontWeight.bold,
                      ),
                      const GapVertical8(),
                      SizedBox(
                        width: 64,
                        height: 64,
                        child: Avatar(
                          avatarUrl: top3[columnIndex].player.avatarUrl,
                          username: point.x,
                        ),
                      ),
                    ],
                  );
                },
              ),
            )
          ],
        );
      },
      error: (_, __) => const Text('Cannot load players'),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _ChartData {
  final Player player;
  final double totalPoints;

  _ChartData({required this.player, required this.totalPoints});
}
