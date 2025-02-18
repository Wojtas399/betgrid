import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/gap/gap_horizontal.dart';
import '../../../extensions/build_context_extensions.dart';
import '../cubit/season_grand_prix_bet_editor_cubit.dart';
import '../cubit/season_grand_prix_bet_editor_state.dart';

class SeasonGrandPrixBetEditorAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const SeasonGrandPrixBetEditorAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final SeasonGrandPrixBetEditorStateStatus cubitStatus = context.select(
      (SeasonGrandPrixBetEditorCubit cubit) => cubit.state.status,
    );

    return AppBar(
      centerTitle: false,
      title: Text(context.str.grandPrixBetEditorScreenTitle),
      actions:
          cubitStatus.isInitial
              ? null
              : [const _SaveButton(), const GapHorizontal16()],
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton();

  @override
  Widget build(BuildContext context) {
    final bool canSave = context.select(
      (SeasonGrandPrixBetEditorCubit cubit) => cubit.state.canSave,
    );

    return FilledButton(
      onPressed:
          canSave ? context.read<SeasonGrandPrixBetEditorCubit>().submit : null,
      child: Text(context.str.save),
    );
  }
}
