import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/empty_content_info_component.dart';
import '../../../extensions/build_context_extensions.dart';
import '../cubit/stats_cubit.dart';
import '../cubit/stats_state.dart';
import 'stats_stats_content.dart';

class StatsBody extends StatelessWidget {
  const StatsBody({super.key});

  @override
  Widget build(BuildContext context) {
    final StatsStateStatus status = context.select(
      (StatsCubit cubit) => cubit.state.status,
    );

    return status.isNoData
        ? EmptyContentInfo(
            title: context.str.statsNoDataTitle,
            message: context.str.statsNoDataMessage,
          )
        : const StatsStatsContent();
  }
}
