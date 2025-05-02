import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../dependency_injection.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../service/dialog_service.dart';
import 'component/new_season_driver_dialog_content.dart';
import 'cubit/new_season_driver_dialog_cubit.dart';
import 'cubit/new_season_driver_dialog_state.dart';

class NewSeasonDriverDialog extends StatelessWidget {
  final int season;

  const NewSeasonDriverDialog({super.key, required this.season});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              getIt<NewSeasonDriverDialogCubit>(param1: season)..initialize(),
      child: const _CubitStatusListener(child: NewSeasonDriverDialogContent()),
    );
  }
}

class _CubitStatusListener extends StatelessWidget {
  final Widget child;

  const _CubitStatusListener({required this.child});

  void _onStatusChanged(
    BuildContext context,
    NewSeasonDriverDialogState state,
  ) {
    final NewSeasonDriverDialogStateStatus status = state.status;
    final dialogService = getIt<DialogService>();
    if (status.isAddingDriverToSeason) {
      dialogService.showLoadingDialog();
    } else if (status.hasNewDriverBeenAddedToSeason) {
      dialogService.closeLoadingDialog();
      context.maybePop();
      dialogService.showSnackbarMessage(
        context.str.seasonDriversEditorSuccessfullyAddedDriver,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NewSeasonDriverDialogCubit, NewSeasonDriverDialogState>(
      listenWhen:
          (prevState, currState) => prevState.status != currState.status,
      listener: _onStatusChanged,
      child: child,
    );
  }
}
