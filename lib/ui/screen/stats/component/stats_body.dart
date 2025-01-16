import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/empty_content_info_component.dart';
import '../../../component/gap/gap_vertical.dart';
import '../../../component/padding/padding_components.dart';
import '../../../extensions/build_context_extensions.dart';
import '../cubit/stats_cubit.dart';
import '../cubit/stats_state.dart';
import 'stats_grouped_stats.dart';
import 'stats_individual_stats.dart';
import 'stats_type_selection.dart';

class StatsBody extends StatelessWidget {
  const StatsBody({super.key});

  @override
  Widget build(BuildContext context) {
    final StatsType? statsType = context.select(
      (StatsCubit cubit) => cubit.state.type,
    );
    final StatsStateStatus status = context.select(
      (StatsCubit cubit) => cubit.state.status,
    );

    return statsType == null || status.isInitial
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : status.isNoData
            ? EmptyContentInfo(
                title: context.str.statsNoDataTitle,
                message: context.str.statsNoDataMessage,
              )
            : SingleChildScrollView(
                child: Padding8(
                  child: Column(
                    children: [
                      const StatsTypeSelection(),
                      if (status.isChangingStatsType) ...[
                        const GapVertical32(),
                        const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ] else
                        switch (statsType) {
                          StatsType.grouped => const StatsGroupedStats(),
                          StatsType.individual => const StatsIndividualStats(),
                        },
                    ],
                  ),
                ),
              );
  }
}
