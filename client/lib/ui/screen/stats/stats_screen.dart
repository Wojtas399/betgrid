import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import '../../common_cubit/season_cubit.dart';
import 'component/stats_body.dart';
import 'cubit/stats_cubit.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create:
        (_) =>
            getIt.get<StatsCubit>(param1: getIt.get<SeasonCubit>())
              ..initialize(),
    child: const StatsBody(),
  );
}
