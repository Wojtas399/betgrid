import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../component/gap/gap_vertical.dart';
import '../../component/padding/padding_components.dart';
import '../../component/text_component.dart';
import '../../extensions/build_context_extensions.dart';
import 'stats_bet_points_history.dart';
import 'stats_players_podium.dart';

@RoutePage()
class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding24(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleLarge(
              context.str.statsTop3Players,
              fontWeight: FontWeight.bold,
            ),
            const GapVertical16(),
            const SizedBox(
              height: 300,
              child: StatsPlayersPodium(),
            ),
            const GapVertical32(),
            TitleLarge(
              context.str.statsPointsHistory,
              fontWeight: FontWeight.bold,
            ),
            const GapVertical16(),
            const SizedBox(
              height: 300,
              child: StatsBetPointsHistory(),
            ),
          ],
        ),
      ),
    );
  }
}
