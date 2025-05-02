import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../dependency_injection.dart';
import '../../../../model/team_basic_info.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../extensions/widget_list_extensions.dart';
import '../../../service/dialog_service.dart';
import '../cubit/season_teams_editor_cubit.dart';
import 'season_teams_creator_editor_item.dart';

class SeasonTeamsEditorListOfSeasonTeams extends StatelessWidget {
  const SeasonTeamsEditorListOfSeasonTeams({super.key});

  Future<void> _onDeleteTeam(
    BuildContext context,
    String teamId,
    String teamName,
  ) async {
    final cubit = context.read<SeasonTeamsEditorCubit>();
    final bool? canDelete = await getIt<DialogService>().askForConfirmation(
      title: context.str.seasonTeamsEditorSeasonTeamDeletionConfirmationTitle,
      message: context.str
          .seasonTeamsEditorSeasonTeamDeletionConfirmationMessage(
            teamName,
            cubit.state.selectedSeason!,
          ),
    );
    if (canDelete == true) {
      cubit.deleteTeamFromSeason(teamId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<TeamBasicInfo>? teamsFromSeason = context.select(
      (SeasonTeamsEditorCubit cubit) => cubit.state.teamsFromSeason,
    );

    return teamsFromSeason != null
        ? Column(
          children: [
            ...teamsFromSeason.map(
              (teamBasicInfo) => SeasonTeamsCreatorTeamItem(
                teamBasicInfo: teamBasicInfo,
                onDelete:
                    () => _onDeleteTeam(
                      context,
                      teamBasicInfo.id,
                      teamBasicInfo.name,
                    ),
              ),
            ),
          ].divide(const Divider(height: 0)),
        )
        : const Center(child: CircularProgressIndicator());
  }
}
