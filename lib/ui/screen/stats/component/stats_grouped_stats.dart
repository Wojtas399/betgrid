import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../dependency_injection.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../service/dialog_service.dart';
import '../cubit/stats_cubit.dart';
import 'stats_best_points.dart';
import 'stats_bet_points_history.dart';
import 'stats_bet_points_history_preview.dart';
import 'stats_card.dart';
import 'stats_players_podium.dart';
import 'stats_points_by_driver_dropdown_button.dart';
import 'stats_points_by_driver_players_list.dart';

class StatsGroupedStats extends StatelessWidget {
  const StatsGroupedStats({super.key});

  @override
  Widget build(BuildContext context) => const Column(
        spacing: 8,
        children: [
          _PlayersPodium(),
          _BestPoints(),
          _PointsHistory(),
          _PointsByDriver(),
        ],
      );
}

class _PlayersPodium extends StatelessWidget {
  const _PlayersPodium();

  @override
  Widget build(BuildContext context) => StatsCard(
        title: context.str.statsTop3Players,
        icon: Icons.leaderboard_outlined,
        child: const SizedBox(
          height: 300,
          child: StatsPlayersPodium(),
        ),
      );
}

class _BestPoints extends StatelessWidget {
  const _BestPoints();

  @override
  Widget build(BuildContext context) => StatsCard(
        title: context.str.statsBestPoints,
        icon: Icons.star_outline_rounded,
        child: const StatsBestPoints(),
      );
}

class _PointsHistory extends StatelessWidget {
  const _PointsHistory();

  Future<void> _onShowPointsHistoryPreview(BuildContext context) async {
    await getIt<DialogService>().showFullScreenDialog(
      BlocProvider.value(
        value: context.read<StatsCubit>(),
        child: const StatsBetPointsHistoryPreview(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => StatsCard(
        title: context.str.statsPointsHistory,
        icon: Icons.stacked_line_chart_rounded,
        onPressed: () => _onShowPointsHistoryPreview(context),
        child: const SizedBox(
          height: 300,
          child: StatsBetPointsHistory(),
        ),
      );
}

class _PointsByDriver extends StatelessWidget {
  const _PointsByDriver();

  @override
  Widget build(BuildContext context) => StatsCard(
        title: context.str.statsPointsByDriver,
        icon: Icons.format_list_numbered_rounded,
        child: const Column(
          children: [
            StatsPointsByDriverDropdownButton(),
            StatsPointsByDriverPlayersList(),
          ],
        ),
      );
}
