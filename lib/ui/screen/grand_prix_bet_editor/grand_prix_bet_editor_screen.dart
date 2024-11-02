import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import '../../extensions/build_context_extensions.dart';
import '../../service/dialog_service.dart';
import 'component/grand_prix_bet_editor_content.dart';
import 'cubit/grand_prix_bet_editor_cubit.dart';
import 'cubit/grand_prix_bet_editor_state.dart';

@RoutePage()
class GrandPrixBetEditorScreen extends StatelessWidget {
  final String grandPrixId;

  const GrandPrixBetEditorScreen({
    super.key,
    required this.grandPrixId,
  });

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => getIt.get<GrandPrixBetEditorCubit>()
          ..initialize(
            grandPrixId: grandPrixId,
          ),
        child: const _CubitStatusListener(
          child: GrandPrixBetEditorContent(),
        ),
      );
}

class _CubitStatusListener extends StatelessWidget {
  final Widget child;

  const _CubitStatusListener({
    required this.child,
  });

  void _onCubitStatusChanged(
    BuildContext context,
    GrandPrixBetEditorStateStatus status,
  ) {
    final dialogService = getIt<DialogService>();
    if (status == GrandPrixBetEditorStateStatus.saving) {
      dialogService.showLoadingDialog();
    } else if (status == GrandPrixBetEditorStateStatus.successfullySaved) {
      dialogService.closeLoadingDialog();
      dialogService.showSnackbarMessage(
        context.str.grandPrixBetEditorSuccessfullySavedBets,
      );
      context.maybePop();
    }
  }

  @override
  Widget build(BuildContext context) =>
      BlocListener<GrandPrixBetEditorCubit, GrandPrixBetEditorState>(
        listenWhen: (prevState, currState) =>
            currState.status != prevState.status,
        listener: (context, state) =>
            _onCubitStatusChanged(context, state.status),
        child: child,
      );
}
