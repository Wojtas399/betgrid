import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/season_team_details_cubit.dart';
import '../cubit/season_team_details_state.dart';
import 'season_team_details_body.dart';

class SeasonTeamDetailsContent extends StatelessWidget {
  const SeasonTeamDetailsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const _Title()),
      body: const SeasonTeamDetailsBody(),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    final String? teamShortName = context.select(
      (SeasonTeamDetailsCubit cubit) =>
          cubit.state is SeasonTeamDetailsStateLoaded
              ? cubit.state.loaded.team.shortName
              : null,
    );

    return Text(teamShortName ?? '');
  }
}
