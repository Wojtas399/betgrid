import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../component/gap/gap_vertical.dart';
import '../../../../component/padding_component.dart';
import '../../../../component/text_component.dart';
import '../../../../extensions/build_context_extensions.dart';
import '../cubit/new_season_grand_prix_dialog_cubit.dart';
import 'new_season_grand_prix_dialog_end_date.dart';
import 'new_season_grand_prix_dialog_grand_prix_selection.dart';
import 'new_season_grand_prix_dialog_round_number.dart';
import 'new_season_grand_prix_dialog_start_date.dart';

class NewSeasonGrandPrixDialogContent extends StatelessWidget {
  const NewSeasonGrandPrixDialogContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.str.seasonGrandPrixesEditorAddSeasonGrandPrix),
      ),
      body: Padding24(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleMedium(context.str.seasonGrandPrixesEditorGrandPrix),
            const NewSeasonGrandPrixDialogGrandPrixSelection(),
            const GapVertical16(),
            TitleMedium(context.str.seasonGrandPrixesEditorRoundNumber),
            const NewSeasonGrandPrixDialogRoundNumber(),
            const GapVertical16(),
            TitleMedium(context.str.seasonGrandPrixesEditorStartDate),
            const NewSeasonGrandPrixDialogStartDate(),
            const GapVertical16(),
            TitleMedium(context.str.seasonGrandPrixesEditorEndDate),
            const NewSeasonGrandPrixDialogEndDate(),
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
    context.read<NewSeasonGrandPrixDialogCubit>().submit();
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
