import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import '../../extensions/build_context_extensions.dart';
import '../../service/dialog_service.dart';
import 'component/drivers_editor_content.dart';
import 'cubit/drivers_editor_cubit.dart';
import 'cubit/drivers_editor_state.dart';

@RoutePage()
class DriversEditorScreen extends StatelessWidget {
  const DriversEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<DriversEditorCubit>()..initialize(),
      child: const _CubitStatusListener(child: DriversEditorContent()),
    );
  }
}

class _CubitStatusListener extends StatelessWidget {
  const _CubitStatusListener({required this.child});

  final Widget child;

  void _onStatusChanged(BuildContext context, DriversEditorState state) {
    final DialogService dialogService = getIt<DialogService>();
    final status = state.status;
    if (status.isLoading) {
      dialogService.showLoadingDialog();
    } else if (status.isDriverDeleted) {
      dialogService.closeLoadingDialog();
      dialogService.showSnackbarMessage(
        context.str.driversEditorSuccessfullyDeletedDriver,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DriversEditorCubit, DriversEditorState>(
      listenWhen:
          (prevState, currState) => prevState.status != currState.status,
      listener: (context, state) => _onStatusChanged(context, state),
      child: child,
    );
  }
}
