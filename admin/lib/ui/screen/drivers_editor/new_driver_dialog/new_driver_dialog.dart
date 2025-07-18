import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../dependency_injection.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../service/dialog_service.dart';
import 'component/new_driver_dialog_content.dart';
import 'cubit/new_driver_dialog_cubit.dart';
import 'cubit/new_driver_dialog_state.dart';

class NewDriverDialog extends StatelessWidget {
  const NewDriverDialog({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<NewDriverDialogCubit>(),
    child: const _CubitStatusListener(child: NewDriverDialogContent()),
  );
}

class _CubitStatusListener extends StatelessWidget {
  final Widget child;

  const _CubitStatusListener({required this.child});

  void _onStatusChanged(
    NewDriverDialogStateStatus status,
    BuildContext context,
  ) {
    final dialogService = getIt<DialogService>();
    if (status.isLoading) {
      dialogService.showLoadingDialog();
    } else if (status.hasNewDriverPersonalDataBeenAdded) {
      dialogService.closeLoadingDialog();
      context.maybePop();
      dialogService.showSnackbarMessage(
        context.str.driversEditorSuccessfullyAddedDriver,
      );
    }
  }

  @override
  Widget build(BuildContext context) =>
      BlocListener<NewDriverDialogCubit, NewDriverDialogState>(
        listenWhen:
            (prevState, currState) => currState.status != prevState.status,
        listener: (_, state) => _onStatusChanged(state.status, context),
        child: child,
      );
}
