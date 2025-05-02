import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../dependency_injection.dart';
import '../../../../model/team_basic_info.dart';
import '../../../component/slidable_item.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../extensions/string_extensions.dart';
import '../../../service/dialog_service.dart';
import '../cubit/teams_editor_cubit.dart';

class TeamsEditorTeamsList extends StatelessWidget {
  const TeamsEditorTeamsList({super.key});

  Future<void> _deleteTeam(BuildContext context, TeamBasicInfo team) async {
    final bool? canDelete = await getIt<DialogService>().askForConfirmation(
      title: context.str.teamsEditorDeleteTeamConfirmationTitle,
      message: context.str.teamsEditorDeleteTeamConfirmationMessage(team.name),
    );
    if (canDelete == true && context.mounted) {
      context.read<TeamsEditorCubit>().deleteTeam(team.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<TeamBasicInfo> teams = context.select(
      (TeamsEditorCubit cubit) => cubit.state.teams!,
    );

    return ListView(
      children:
          ListTile.divideTiles(
            context: context,
            tiles: teams.map(
              (team) => _TeamItem(
                team: team,
                onDelete: () => _deleteTeam(context, team),
              ),
            ),
          ).toList(),
    );
  }
}

class _TeamItem extends StatelessWidget {
  const _TeamItem({required this.team, required this.onDelete});

  final TeamBasicInfo team;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) => SlidableItem(
    onDelete: onDelete,
    child: ListTile(
      title: Text(team.name),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: team.hexColor.toColor(),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );
}
