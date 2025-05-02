import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../component/gap/gap_vertical.dart';
import '../../../../component/padding_component.dart';
import '../../../../component/text_component.dart';
import '../../../../extensions/build_context_extensions.dart';
import '../cubit/new_season_team_dialog_cubit.dart';
import 'new_season_team_dialog_team_selection.dart';

class NewSeasonTeamDialogContent extends StatelessWidget {
  const NewSeasonTeamDialogContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.str.seasonTeamsEditorAddSeasonTeam)),
      body: Padding24(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleMedium(
              context.str.seasonTeamsEditorTeam,
              color: context.colorScheme.outline,
            ),
            const NewSeasonTeamDialogTeamSelection(),
            const GapVertical24(),
            const _SubmitButton(),
          ],
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  void _onPressed(BuildContext context) {
    context.read<NewSeasonTeamDialogCubit>().submit();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FilledButton(
        onPressed: () => _onPressed(context),
        child: Text(context.str.add),
      ),
    );
  }
}
