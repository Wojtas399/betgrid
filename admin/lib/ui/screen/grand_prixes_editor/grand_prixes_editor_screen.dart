import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import '../../extensions/build_context_extensions.dart';
import '../../service/dialog_service.dart';
import 'component/grand_prixes_editor_content.dart';
import 'cubit/grand_prixes_editor_cubit.dart';
import 'cubit/grand_prixes_editor_state.dart';

@RoutePage()
class GrandPrixesEditorScreen extends StatelessWidget {
  const GrandPrixesEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<GrandPrixesEditorCubit>()..initialize(),
      child: const _CubitStatusListener(child: GrandPrixesEditorContent()),
    );
  }
}

class _CubitStatusListener extends StatelessWidget {
  final Widget child;

  const _CubitStatusListener({required this.child});

  void _onStatusChanged(BuildContext context, GrandPrixesEditorState state) {
    final DialogService dialogService = getIt<DialogService>();
    final status = state.status;
    if (status.isLoading) {
      dialogService.showLoadingDialog();
    } else if (status.hasGrandPrixBeenDeleted) {
      dialogService.closeLoadingDialog();
      dialogService.showSnackbarMessage(
        context.str.grandPrixesEditorSuccessfullyDeletedGrandPrix,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GrandPrixesEditorCubit, GrandPrixesEditorState>(
      listenWhen:
          (prevState, currState) => prevState.status != currState.status,
      listener: (context, state) => _onStatusChanged(context, state),
      child: child,
    );
  }
}
