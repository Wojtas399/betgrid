import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../component/padding/padding_components.dart';
import 'stats_bet_points_history.dart';
import 'stats_players_podium.dart';

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
            child: StatsPlayersPodium(),
          ),
          SizedBox(
            height: 300,
            child: StatsBetPointsHistory(),
          ),
        ],
      ),
    );
  }
}
