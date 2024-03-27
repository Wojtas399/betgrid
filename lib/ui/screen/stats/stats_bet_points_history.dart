import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../component/avatar_component.dart';
import '../../component/gap/gap_horizontal.dart';
import '../../component/text_component.dart';
import 'provider/points_history_chart_data_provider.dart';

class StatsBetPointsHistory extends ConsumerWidget {
  const StatsBetPointsHistory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chartData = ref.watch(pointsHistoryChartDataProvider).value;

    return chartData == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : SfCartesianChart(
            primaryXAxis: const CategoryAxis(),
            series: <CartesianSeries>[
              for (final player in chartData.players)
                LineSeries<PointsHistoryChartGrandPrix, String>(
                  dataSource: chartData.chartGrandPrixes,
                  xValueMapper: (data, _) => data.grandPrixName,
                  yValueMapper: (data, _) => data.playersPoints
                      .firstWhere((el) => el.playerId == player.id)
                      .points,
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    labelAlignment: ChartDataLabelAlignment.top,
                    builder: (_, ChartPoint point, __, int gpIndex, _____) {
                      final bool isLastGrandPrix =
                          gpIndex == chartData.chartGrandPrixes.length - 1;
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isLastGrandPrix) ...[
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Avatar(
                                avatarUrl: player.avatarUrl,
                                username: player.username,
                              ),
                            ),
                            const GapHorizontal8(),
                          ],
                          LabelMedium('${point.y}'),
                        ],
                      );
                    },
                  ),
                ),
            ],
          );
  }
}
