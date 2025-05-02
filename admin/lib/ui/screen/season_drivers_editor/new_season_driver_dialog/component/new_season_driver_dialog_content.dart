import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../component/gap/gap_vertical.dart';
import '../../../../component/padding_component.dart';
import '../../../../component/text_component.dart';
import '../../../../extensions/build_context_extensions.dart';
import '../cubit/new_season_driver_dialog_cubit.dart';
import 'new_season_driver_dialog_driver_number.dart';
import 'new_season_driver_dialog_driver_selection.dart';
import 'new_season_driver_dialog_team_selection.dart';

class NewSeasonDriverDialogContent extends StatelessWidget {
  const NewSeasonDriverDialogContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.str.seasonDriversEditorAddSeasonDriver),
      ),
      body: Padding24(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleMedium(
              context.str.seasonDriversEditorDriver,
              color: context.colorScheme.outline,
            ),
            const NewSeasonDriverDialogDriverSelection(),
            const GapVertical16(),
            TitleMedium(
              context.str.seasonDriversEditorDriverNumber,
              color: context.colorScheme.outline,
            ),
            const NewSeasonDriverDialogDriverNumber(),
            const GapVertical16(),
            TitleMedium(
              context.str.seasonDriversEditorTeam,
              color: context.colorScheme.outline,
            ),
            const NewSeasonDriverDialogTeamSelection(),
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
    context.read<NewSeasonDriverDialogCubit>().submit();
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
