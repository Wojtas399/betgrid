import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../dependency_injection.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../service/dialog_service.dart';
import 'component/new_season_team_dialog_content.dart';
import 'cubit/new_season_team_dialog_cubit.dart';
import 'cubit/new_season_team_dialog_state.dart';

class NewSeasonTeamDialog extends StatelessWidget {
  final int season;

  const NewSeasonTeamDialog({super.key, required this.season});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => getIt<NewSeasonTeamDialogCubit>(param1: season)..initialize(),
      child: const _CubitStatusListener(child: NewSeasonTeamDialogContent()),
    );
  }
}

class _CubitStatusListener extends StatelessWidget {
  final Widget child;

  const _CubitStatusListener({required this.child});

  void _onStatusChanged(BuildContext context, NewSeasonTeamDialogState state) {
    final NewSeasonTeamDialogStateStatus status = state.status;
    final dialogService = getIt<DialogService>();
    if (status.isLoading) {
      dialogService.showLoadingDialog();
    } else if (status.hasNewTeamBeenAddedToSeason) {
      dialogService.closeLoadingDialog();
      context.maybePop();
      dialogService.showSnackbarMessage(
        context.str.seasonTeamsEditorSuccessfullyAddedTeam,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NewSeasonTeamDialogCubit, NewSeasonTeamDialogState>(
      listenWhen:
          (prevState, currState) => prevState.status != currState.status,
      listener: _onStatusChanged,
      child: child,
    );
  }
}
