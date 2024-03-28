import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../component/avatar_component.dart';
import '../../component/gap/gap_vertical.dart';
import '../../component/text_component.dart';
import 'provider/players_podium_chart_data_provider.dart';

class StatsPlayersPodium extends ConsumerWidget {
  const StatsPlayersPodium({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playersPodium = ref.watch(playersPodiumChartDataProvider);

    return playersPodium.when(
      data: (playersPodium) {
        final List<PlayersPodiumChartPlayer> podiumArray = playersPodium != null
            ? [
                if (playersPodium.p2Player != null) playersPodium.p2Player!,
                playersPodium.p1Player,
                if (playersPodium.p3Player != null) playersPodium.p3Player!,
              ]
            : [];

        return SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          primaryYAxis: NumericAxis(
            minimum: 0,
            maximum: (playersPodium?.p1Player.points ?? 0.0) + 30,
            // interval: 5,
          ),
          series: <CartesianSeries<PlayersPodiumChartPlayer, String>>[
            ColumnSeries<PlayersPodiumChartPlayer, String>(
              dataSource: podiumArray,
              xValueMapper: (data, _) => data.player.username,
              yValueMapper: (data, _) => data.points,
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
                          avatarUrl: podiumArray[columnIndex].player.avatarUrl,
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
      error: (Object? error, __) => Text(error.toString()),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
