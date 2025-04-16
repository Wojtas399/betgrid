import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import '../../common_cubit/season_cubit.dart';
import 'component/season_teams_content.dart';
import 'cubit/season_teams_cubit.dart';

class SeasonTeamsScreen extends StatelessWidget {
  const SeasonTeamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              getIt<SeasonTeamsCubit>(param1: context.read<SeasonCubit>())
                ..initialize(),
      child: const SeasonTeamsContent(),
    );
  }
}
