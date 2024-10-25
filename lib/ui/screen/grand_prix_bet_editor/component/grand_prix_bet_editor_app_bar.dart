import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/gap/gap_horizontal.dart';
import '../../../extensions/build_context_extensions.dart';
import '../cubit/grand_prix_bet_editor_cubit.dart';

class GrandPrixBetEditorAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const GrandPrixBetEditorAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => AppBar(
        centerTitle: false,
        title: Text(context.str.grandPrixBetEditorScreenTitle),
        actions: [
          FilledButton(
            onPressed: context.read<GrandPrixBetEditorCubit>().submit,
            child: Text(context.str.save),
          ),
          const GapHorizontal16(),
        ],
      );
}
