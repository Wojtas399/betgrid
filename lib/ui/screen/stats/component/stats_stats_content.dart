import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  Future<void> _onShowPointsHistoryPreview(BuildContext context) async {
    await showFullScreenDialog(
      BlocProvider.value(
        value: context.read<StatsCubit>(),
        child: const StatsBetPointsHistoryPreview(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TitleLarge(
                    context.str.statsPointsHistory,
                    fontWeight: FontWeight.bold,
                  ),
                  IconButton(
                    onPressed: () => _onShowPointsHistoryPreview(context),
                    icon: const Icon(
                      Icons.open_in_full,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const GapVertical16(),
              const SizedBox(
                height: 300,
                child: StatsBetPointsHistory(),
              ),
              const GapVertical32(),
              TitleLarge(
                context.str.statsPointsByDriver,
                fontWeight: FontWeight.bold,
              ),
              const GapVertical16(),
              const StatsPointsByDriverDropdownButton(),
              const StatsPointsByDriverPlayersList(),
            ],
          ),
        ),
      );
}
