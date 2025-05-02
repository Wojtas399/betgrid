import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../model/team_basic_info.dart';
import '../cubit/new_season_driver_dialog_cubit.dart';

class NewSeasonDriverDialogTeamSelection extends StatelessWidget {
  const NewSeasonDriverDialogTeamSelection({super.key});

  void _onChanged(String? teamId, BuildContext context) {
    if (teamId != null) {
      context.read<NewSeasonDriverDialogCubit>().onTeamSelected(teamId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<TeamBasicInfo>? teamsToSelect = context.select(
      (NewSeasonDriverDialogCubit cubit) => cubit.state.teamsToSelect,
    );
    final String? selectedTeamId = context.select(
      (NewSeasonDriverDialogCubit cubit) => cubit.state.selectedTeamId,
    );

    return DropdownButtonFormField<String>(
      value: selectedTeamId,
      items: [
        ...?teamsToSelect?.map(
          (team) =>
              DropdownMenuItem<String>(value: team.id, child: Text(team.name)),
        ),
      ],
      onChanged: (String? driverId) => _onChanged(driverId, context),
    );
  }
}
