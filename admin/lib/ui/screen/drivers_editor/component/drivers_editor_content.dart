import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../dependency_injection.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../service/dialog_service.dart';
import '../cubit/drivers_editor_cubit.dart';
import '../cubit/drivers_editor_state.dart';
import '../new_driver_dialog/new_driver_dialog.dart';
import 'drivers_editor_drivers_list.dart';

class DriversEditorContent extends StatelessWidget {
  const DriversEditorContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(appBar: _AppBar(), body: _Body());
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void _addDriver(BuildContext context) {
    getIt<DialogService>().showFullScreenDialog(const NewDriverDialog());
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(context.str.driversEditorScreenTitle),
      actions: [
        IconButton(
          onPressed: () => _addDriver(context),
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
      (DriversEditorCubit cubit) => cubit.state.status,
    );

    return cubitStatus.isInitial
        ? const Center(child: CircularProgressIndicator())
        : const DriversEditorDriversList();
  }
}
