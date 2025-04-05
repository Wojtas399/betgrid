import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../model/season_team.dart';
import '../../../component/custom_card_component.dart';
import '../cubit/teams_details_cubit.dart';
import '../cubit/teams_details_state.dart';

class TeamsDetailsContent extends StatelessWidget {
  const TeamsDetailsContent({super.key});

  @override
  Widget build(BuildContext context) {
    final TeamsDetailsState state = context.watch<TeamsDetailsCubit>().state;

    return switch (state) {
      TeamsDetailsStateLoaded() => const _ListOfTeams(),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}

class _ListOfTeams extends StatelessWidget {
  const _ListOfTeams();

  @override
  Widget build(BuildContext context) {
    final List<SeasonTeam> teams = context.select(
      (TeamsDetailsCubit cubit) => cubit.state.loaded.teams,
    );

    return ListView.builder(
      itemCount: teams.length,
      itemBuilder: (_, int index) {
        final SeasonTeam team = teams[index];

        return CustomCard(
          child: Column(
            children: [Text(team.shortName), Image.network(team.carImgUrl)],
          ),
        );
      },
    );
  }
}
