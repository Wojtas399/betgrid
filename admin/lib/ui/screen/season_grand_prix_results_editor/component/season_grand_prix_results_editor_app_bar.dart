import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/gap/gap_horizontal.dart';
import '../../../extensions/build_context_extensions.dart';
import '../cubit/season_grand_prix_results_editor_cubit.dart';
import '../cubit/season_grand_prix_results_editor_state.dart';

class SeasonGrandPrixResultsEditorAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const SeasonGrandPrixResultsEditorAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      title: const _GrandPrixName(),
      actions: [const _SaveButton(), const GapHorizontal16()],
    );
  }
}

class _GrandPrixName extends StatelessWidget {
  const _GrandPrixName();

  @override
  Widget build(BuildContext context) {
    final String? grandPrixName = context.select((
      SeasonGrandPrixResultsEditorCubit cubit,
    ) {
      final SeasonGrandPrixResultsEditorState state = cubit.state;

      return state is SeasonGrandPrixResultsEditorStateLoaded
          ? state.grandPrixName
          : null;
    });

    return Text(grandPrixName ?? '--');
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton();

  @override
  Widget build(BuildContext context) {
    final bool canSave = context.select(
      (SeasonGrandPrixResultsEditorCubit cubit) => cubit.state.canSave,
    );

    return FilledButton(
      onPressed:
          canSave
              ? context.read<SeasonGrandPrixResultsEditorCubit>().submit
              : null,
      child: Text(context.str.save),
    );
  }
}
