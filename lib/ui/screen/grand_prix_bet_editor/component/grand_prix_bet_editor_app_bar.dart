import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/gap/gap_horizontal.dart';
import '../../../extensions/build_context_extensions.dart';
import '../cubit/grand_prix_bet_editor_cubit.dart';
import '../cubit/grand_prix_bet_editor_state.dart';

class GrandPrixBetEditorAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const GrandPrixBetEditorAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final GrandPrixBetEditorStateStatus cubitStatus = context.select(
      (GrandPrixBetEditorCubit cubit) => cubit.state.status,
    );

    return AppBar(
      centerTitle: false,
      title: Text(context.str.grandPrixBetEditorScreenTitle),
      actions: cubitStatus.isInitial
          ? null
          : [
              const _SaveButton(),
              const GapHorizontal16(),
            ],
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton();

  @override
  Widget build(BuildContext context) {
    final bool canSave = context.select(
      (GrandPrixBetEditorCubit cubit) => cubit.state.canSave,
    );

    return FilledButton(
      onPressed:
          canSave ? context.read<GrandPrixBetEditorCubit>().submit : null,
      child: Text(context.str.save),
    );
  }
}
