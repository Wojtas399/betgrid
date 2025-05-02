import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../dependency_injection.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../service/dialog_service.dart';
import '../cubit/teams_editor_cubit.dart';
import '../cubit/teams_editor_state.dart';
import '../new_team_dialog/new_team_dialog.dart';
import 'teams_editor_teams_list.dart';

class TeamsEditorContent extends StatelessWidget {
  const TeamsEditorContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(appBar: _AppBar(), body: _Body());
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void _addTeam(BuildContext context) {
    getIt<DialogService>().showFullScreenDialog(const NewTeamDialog());
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(context.str.teamsEditorScreenTitle),
      actions: [
        IconButton(
          onPressed: () => _addTeam(context),
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
      (TeamsEditorCubit cubit) => cubit.state.status,
    );

    return cubitStatus.isInitial
        ? const Center(child: CircularProgressIndicator())
        : const TeamsEditorTeamsList();
  }
}
