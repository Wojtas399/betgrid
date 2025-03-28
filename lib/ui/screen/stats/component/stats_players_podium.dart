import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../component/avatar_component.dart';
import '../../../component/gap/gap_vertical.dart';
import '../../../component/text_component.dart';
import '../../../extensions/build_context_extensions.dart';
import '../cubit/stats_cubit.dart';
import '../cubit/stats_state.dart';
import '../stats_model/players_podium.dart';
import 'stats_no_data_info.dart';

class StatsPlayersPodium extends StatelessWidget {
  const StatsPlayersPodium({super.key});

  @override
  Widget build(BuildContext context) {
    final PlayersPodium? playersPodium = context.select(
      (StatsCubit cubit) => (cubit.state.stats as GroupedStats).playersPodium,
    );

    if (playersPodium == null) {
      return const StatsNoDataInfo();
    }

    final List<PlayersPodiumPlayer> podiumArray = [
      if (playersPodium.p2Player != null) playersPodium.p2Player!,
      playersPodium.p1Player,
      if (playersPodium.p3Player != null) playersPodium.p3Player!,
    ];
    return SfCartesianChart(
      primaryXAxis: const CategoryAxis(),
      primaryYAxis: NumericAxis(
        minimum: 0,
        maximum: playersPodium.p1Player.points * 1.8,
        // interval: 5,
      ),
      series: <CartesianSeries<PlayersPodiumPlayer, String>>[
        ColumnSeries<PlayersPodiumPlayer, String>(
          dataSource: podiumArray,
          xValueMapper: (data, _) => data.player.username,
          yValueMapper: (data, _) => data.points,
          color: context.colorScheme.primary,
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            builder:
                (_, ChartPoint point, _, int columnIndex, _) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BodyLarge('${point.y}', fontWeight: FontWeight.bold),
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
                ),
          ),
        ),
      ],
    );
  }
}
