import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../dependency_injection.dart';
import '../../../component/custom_card_component.dart';
import '../../../component/gap/gap_vertical.dart';
import '../../../component/padding/padding_components.dart';
import '../../../component/text_component.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../service/dialog_service.dart';
import '../cubit/stats_cubit.dart';
import 'stats_bet_points_history.dart';
import 'stats_bet_points_history_preview.dart';
import 'stats_players_podium.dart';
import 'stats_points_by_driver_dropdown_button.dart';
import 'stats_points_by_driver_players_list.dart';

class StatsStatsContent extends StatelessWidget {
  const StatsStatsContent({super.key});

  @override
  Widget build(BuildContext context) => const SingleChildScrollView(
        child: Padding8(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              _PlayersPodium(),
              _PointsHistory(),
              _PointsByDriver(),
            ],
          ),
        ),
      );
}

class _PlayersPodium extends StatelessWidget {
  const _PlayersPodium();

  @override
  Widget build(BuildContext context) => CustomCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 16,
              children: [
                const _Icon(Icons.leaderboard_outlined),
                TitleLarge(context.str.statsTop3Players),
              ],
            ),
            const GapVertical16(),
            const SizedBox(
              height: 300,
              child: StatsPlayersPodium(),
            ),
          ],
        ),
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
  Widget build(BuildContext context) => CustomCard(
        onPressed: () => _onShowPointsHistoryPreview(context),
        child: Column(
          children: [
            Row(
              spacing: 16,
              children: [
                const _Icon(Icons.ssid_chart),
                TitleLarge(context.str.statsPointsHistory),
              ],
            ),
            const GapVertical16(),
            const SizedBox(
              height: 300,
              child: StatsBetPointsHistory(),
            ),
          ],
        ),
      );
}

class _PointsByDriver extends StatelessWidget {
  const _PointsByDriver();

  @override
  Widget build(BuildContext context) => CustomCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 16,
              children: [
                const _Icon(Icons.format_list_numbered),
                TitleLarge(context.str.statsPointsByDriver),
              ],
            ),
            const GapVertical16(),
            const StatsPointsByDriverDropdownButton(),
            const StatsPointsByDriverPlayersList(),
          ],
        ),
      );
}

class _Icon extends StatelessWidget {
  const _Icon(this.icon);

  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: context.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
          color: context.colorScheme.primary,
        ),
      );
}
