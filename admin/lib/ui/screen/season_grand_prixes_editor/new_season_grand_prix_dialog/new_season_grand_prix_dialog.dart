import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../dependency_injection.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../service/dialog_service.dart';
import 'component/new_season_grand_prix_dialog_content.dart';
import 'cubit/new_season_grand_prix_dialog_cubit.dart';
import 'cubit/new_season_grand_prix_dialog_state.dart';

class NewSeasonGrandPrixDialog extends StatelessWidget {
  final int season;

  const NewSeasonGrandPrixDialog({super.key, required this.season});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              getIt<NewSeasonGrandPrixDialogCubit>(param1: season)
                ..initialize(),
      child: const _CubitStatusListener(
        child: NewSeasonGrandPrixDialogContent(),
      ),
    );
  }
}

class _CubitStatusListener extends StatelessWidget {
  final Widget child;

  const _CubitStatusListener({required this.child});

  void _onStatusChanged(
    BuildContext context,
    NewSeasonGrandPrixDialogState state,
  ) {
    final NewSeasonGrandPrixDialogStateStatus status = state.status;
    final dialogService = getIt<DialogService>();
    if (status.isSavingGrandPrix) {
      dialogService.showLoadingDialog();
    } else if (status.isGrandPrixSaved) {
      dialogService.closeLoadingDialog();
      context.maybePop();
      dialogService.showSnackbarMessage(
        context.str.seasonGrandPrixesEditorSuccessfullyAddedGrandPrix,
      );
    } else if (status.isFormNotCompleted) {
      dialogService.showAlertDialog(
        title: context.str.seasonGrandPrixesEditorInvalidFormTitle,
        message: context.str.seasonGrandPrixesEditorInvalidFormMessage,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<
      NewSeasonGrandPrixDialogCubit,
      NewSeasonGrandPrixDialogState
    >(
      listenWhen:
          (prevState, currState) => prevState.status != currState.status,
      listener: _onStatusChanged,
      child: child,
    );
  }
}
