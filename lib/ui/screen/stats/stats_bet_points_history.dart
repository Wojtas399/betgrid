import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../component/avatar_component.dart';
import '../../component/gap/gap_horizontal.dart';
import '../../component/text_component.dart';
import 'cubit/stats_cubit.dart';
import 'cubit/stats_state.dart';
import 'stats_model/points_history.dart';

class StatsBetPointsHistory extends StatelessWidget {
  final bool showPointsForEachRound;

  const StatsBetPointsHistory({
    super.key,
    this.showPointsForEachRound = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCubitLoading = context.select(
      (StatsCubit cubit) => cubit.state.status.isLoading,
    );
    final PointsHistory? pointsHistory = context.select(
      (StatsCubit cubit) => cubit.state.pointsHistory,
    );

    return isCubitLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : SfCartesianChart(
            primaryXAxis: const CategoryAxis(),
            series: <CartesianSeries>[
              for (final player in [...?pointsHistory?.players])
                LineSeries<PointsHistoryGrandPrix, String>(
                  dataSource: pointsHistory!.grandPrixes.toList(),
                  xValueMapper: (data, _) => '${data.roundNumber}',
                  yValueMapper: (data, _) => data.playersPoints
                      .firstWhere((el) => el.playerId == player.id)
                      .points,
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    labelAlignment: ChartDataLabelAlignment.top,
                    builder: (_, ChartPoint point, __, int gpIndex, _____) {
                      final bool isLastGrandPrix =
                          gpIndex == pointsHistory.grandPrixes.length - 1;
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
                                usernameFontSize: 14,
                              ),
                            ),
                            const GapHorizontal8(),
                          ],
                          if (showPointsForEachRound || isLastGrandPrix)
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
