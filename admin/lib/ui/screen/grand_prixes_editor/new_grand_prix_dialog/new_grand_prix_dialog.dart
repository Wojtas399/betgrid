import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../dependency_injection.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../service/dialog_service.dart';
import 'component/new_grand_prix_dialog_content.dart';
import 'cubit/new_grand_prix_dialog_cubit.dart';
import 'cubit/new_grand_prix_dialog_state.dart';

class NewGrandPrixDialog extends StatelessWidget {
  const NewGrandPrixDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<NewGrandPrixDialogCubit>(),
      child: const _CubitStatusListener(child: NewGrandPrixDialogContent()),
    );
  }
}

class _CubitStatusListener extends StatelessWidget {
  final Widget child;

  const _CubitStatusListener({required this.child});

  void _onStatusChanged(BuildContext context, NewGrandPrixDialogState state) {
    final dialogService = getIt<DialogService>();
    final status = state.status;
    if (status.isLoading) {
      dialogService.showLoadingDialog();
    } else if (status.hasNewGrandPrixBeenAdded) {
      dialogService.closeLoadingDialog();
      context.maybePop();
      dialogService.showSnackbarMessage(
        context.str.grandPrixesEditorSuccessfullyAddedGrandPrix,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NewGrandPrixDialogCubit, NewGrandPrixDialogState>(
      listenWhen:
          (prevState, currState) => prevState.status != currState.status,
      listener: _onStatusChanged,
      child: child,
    );
  }
}
