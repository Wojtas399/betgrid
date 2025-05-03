import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../dependency_injection.dart';
import '../../../component/gap/gap_vertical.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../service/dialog_service.dart';
import '../cubit/season_teams_editor_cubit.dart';
import '../cubit/season_teams_editor_state.dart';
import '../new_season_team_dialog/new_season_team_dialog.dart';
import 'season_teams_editor_list_of_season_teams.dart';
import 'season_teams_editor_season_selection.dart';

class SeasonTeamsEditorContent extends StatelessWidget {
  const SeasonTeamsEditorContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(appBar: _AppBar(), body: _Body());
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  Future<void> _addTeamToSeason(BuildContext context) async {
    final int? selectedSeason =
        context.read<SeasonTeamsEditorCubit>().state.selectedSeason;
    if (selectedSeason == null) return;
    await getIt<DialogService>().showFullScreenDialog(
      NewSeasonTeamDialog(season: selectedSeason),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(context.str.seasonTeamsEditorScreenTitle),
      actions: [
        IconButton(
          onPressed: () => _addTeamToSeason(context),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final cubitStatus = context.select(
      (SeasonTeamsEditorCubit cubit) => cubit.state.status,
    );

    return cubitStatus.isInitial
        ? const Center(child: CircularProgressIndicator())
        : const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(bottom: 24),
            child: Column(
              children: [
                SeasonTeamsEditorSeasonSelection(),
                GapVertical24(),
                SeasonTeamsEditorListOfSeasonTeams(),
                GapVertical32(),
              ],
            ),
          ),
        );
  }
}
