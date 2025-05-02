import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../dependency_injection.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../service/dialog_service.dart';
import '../cubit/grand_prixes_editor_cubit.dart';
import '../cubit/grand_prixes_editor_state.dart';
import '../new_grand_prix_dialog/new_grand_prix_dialog.dart';
import 'grand_prixes_editor_grand_prixes_list.dart';

class GrandPrixesEditorContent extends StatelessWidget {
  const GrandPrixesEditorContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(appBar: _AppBar(), body: _Body());
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void _addGrandPrix(BuildContext context) {
    getIt<DialogService>().showFullScreenDialog(const NewGrandPrixDialog());
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(context.str.grandPrixesEditorScreenTitle),
      actions: [
        IconButton(
          onPressed: () => _addGrandPrix(context),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final cubitStatus = context.select(
      (GrandPrixesEditorCubit cubit) => cubit.state.status,
    );

    return cubitStatus.isInitial
        ? const Center(child: CircularProgressIndicator())
        : const GrandPrixesEditorGrandPrixesList();
  }
}
