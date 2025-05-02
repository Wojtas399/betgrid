import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../model/team_basic_info.dart';
import '../cubit/new_season_team_dialog_cubit.dart';

class NewSeasonTeamDialogTeamSelection extends StatelessWidget {
  const NewSeasonTeamDialogTeamSelection({super.key});

  void _onChanged(String? teamId, BuildContext context) {
    if (teamId != null) {
      context.read<NewSeasonTeamDialogCubit>().onTeamSelected(teamId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<TeamBasicInfo>? teamsToSelect = context.select(
      (NewSeasonTeamDialogCubit cubit) => cubit.state.teamsToSelect,
    );
    final String? selectedTeamId = context.select(
      (NewSeasonTeamDialogCubit cubit) => cubit.state.selectedTeamId,
    );

    return DropdownButtonFormField<String>(
      value: selectedTeamId,
      items: [
        ...?teamsToSelect?.map(
          (team) =>
              DropdownMenuItem<String>(value: team.id, child: Text(team.name)),
        ),
      ],
      onChanged: (String? teamId) => _onChanged(teamId, context),
    );
  }
}
