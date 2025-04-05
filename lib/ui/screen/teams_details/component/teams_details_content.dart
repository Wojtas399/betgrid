import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../model/season_team.dart';
import '../../../component/custom_card_component.dart';
import '../../../component/text_component.dart';
import '../../../extensions/string_extensions.dart';
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
      padding: const EdgeInsets.all(8),
      itemCount: teams.length,
      itemBuilder: (_, int index) {
        final SeasonTeam team = teams[index];

        return _TeamItem(team: team);
      },
    );
  }
}

class _TeamItem extends StatelessWidget {
  final SeasonTeam team;

  const _TeamItem({required this.team});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: team.baseHexColor.toColor(),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 16),
              TitleMedium(team.shortName),
            ],
          ),
          const SizedBox(height: 16),
          Image.network(team.carImgUrl),
        ],
      ),
    );
  }
}
