import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import '../../extensions/build_context_extensions.dart';
import '../../service/dialog_service.dart';
import 'component/season_teams_editor_content.dart';
import 'cubit/season_teams_editor_cubit.dart';
import 'cubit/season_teams_editor_state.dart';

@RoutePage()
class SeasonTeamsEditorScreen extends StatelessWidget {
  const SeasonTeamsEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SeasonTeamsEditorCubit>()..initialize(),
      child: const _CubitStatusListener(child: SeasonTeamsEditorContent()),
    );
  }
}

class _CubitStatusListener extends StatelessWidget {
  final Widget child;

  const _CubitStatusListener({required this.child});

  void _onStatusChanged(
    SeasonTeamsEditorStateStatus status,
    BuildContext context,
  ) {
    final dialogService = getIt<DialogService>();
    if (status.isLoading) {
      dialogService.showLoadingDialog();
    } else if (status.hasSeasonTeamBeenDeleted) {
      dialogService.closeLoadingDialog();
      dialogService.showSnackbarMessage(
        context.str.seasonTeamsEditorSuccessfullyDeletedSeasonTeam,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SeasonTeamsEditorCubit, SeasonTeamsEditorState>(
      listenWhen:
          (prevState, currState) => prevState.status != currState.status,
      listener: (_, state) {
        _onStatusChanged(state.status, context);
      },
      child: child,
    );
  }
}
