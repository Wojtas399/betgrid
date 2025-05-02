import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../model/season_team.dart';
import '../../../component/custom_card_component.dart';
import '../../../component/text_component.dart';
import '../../../config/router/app_router.dart';
import '../../../extensions/string_extensions.dart';
import '../cubit/season_teams_cubit.dart';
import '../cubit/season_teams_state.dart';

class SeasonTeamsContent extends StatelessWidget {
  const SeasonTeamsContent({super.key});

  @override
  Widget build(BuildContext context) {
    final SeasonTeamsState state = context.watch<SeasonTeamsCubit>().state;

    return switch (state) {
      SeasonTeamsStateLoaded() => const _ListOfTeams(),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}

class _ListOfTeams extends StatelessWidget {
  const _ListOfTeams();

  @override
  Widget build(BuildContext context) {
    final List<SeasonTeam> teams = context.select(
      (SeasonTeamsCubit cubit) => cubit.state.loaded.teams,
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

  void _onPressed(BuildContext context) {
    context.navigateTo(
      SeasonTeamDetailsRoute(season: team.season, seasonTeamId: team.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onPressed: () => _onPressed(context),
      child: Column(
        spacing: 16,
        children: [
          Row(
            spacing: 12,
            children: [
              Container(
                width: 4,
                height: 25,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: team.baseHexColor.toColor(),
                ),
              ),
              TitleMedium(team.shortName),
            ],
          ),
          Image.network(team.carImgUrl),
        ],
      ),
    );
  }
}
