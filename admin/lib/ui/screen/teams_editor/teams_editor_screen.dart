import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import '../../extensions/build_context_extensions.dart';
import '../../service/dialog_service.dart';
import 'component/teams_editor_content.dart';
import 'cubit/teams_editor_cubit.dart';
import 'cubit/teams_editor_state.dart';

@RoutePage()
class TeamsEditorScreen extends StatelessWidget {
  const TeamsEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TeamsEditorCubit>()..initialize(),
      child: const _CubitStatusListener(
        child: Scaffold(body: TeamsEditorContent()),
      ),
    );
  }
}

class _CubitStatusListener extends StatelessWidget {
  const _CubitStatusListener({required this.child});

  final Widget child;

  void _onStatusChanged(BuildContext context, TeamsEditorState state) {
    final DialogService dialogService = getIt<DialogService>();
    final status = state.status;
    if (status.isLoading) {
      dialogService.showLoadingDialog();
    } else if (status.isTeamDeleted) {
      dialogService.closeLoadingDialog();
      dialogService.showSnackbarMessage(
        context.str.teamsEditorSuccessfullyDeletedTeam,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TeamsEditorCubit, TeamsEditorState>(
      listenWhen:
          (prevState, currState) => prevState.status != currState.status,
      listener: _onStatusChanged,
      child: child,
    );
  }
}
