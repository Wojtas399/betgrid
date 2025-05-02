import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../dependency_injection.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../service/dialog_service.dart';
import 'component/new_team_dialog_content.dart';
import 'cubit/new_team_dialog_cubit.dart';
import 'cubit/new_team_dialog_state.dart';

class NewTeamDialog extends StatelessWidget {
  const NewTeamDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<NewTeamDialogCubit>(),
      child: const _CubitStatusListener(child: NewTeamDialogContent()),
    );
  }
}

class _CubitStatusListener extends StatelessWidget {
  final Widget child;

  const _CubitStatusListener({required this.child});

  void _onStatusChanged(NewTeamDialogStateStatus status, BuildContext context) {
    final dialogService = getIt<DialogService>();
    if (status.isLoading) {
      dialogService.showLoadingDialog();
    } else if (status.hasNewTeamBasicInfoBeenAdded) {
      dialogService.closeLoadingDialog();
      context.maybePop();
      dialogService.showSnackbarMessage(
        context.str.teamsEditorSuccessfullyAddedTeam,
      );
    }
  }

  @override
  Widget build(BuildContext context) =>
      BlocListener<NewTeamDialogCubit, NewTeamDialogState>(
        listenWhen:
            (prevState, currState) => currState.status != prevState.status,
        listener: (_, state) => _onStatusChanged(state.status, context),
        child: child,
      );
}
