import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import '../../extensions/build_context_extensions.dart';
import '../../service/dialog_service.dart';
import 'component/season_grand_prix_results_editor_content.dart';
import 'cubit/season_grand_prix_results_editor_cubit.dart';
import 'cubit/season_grand_prix_results_editor_state.dart';

@RoutePage()
class SeasonGrandPrixResultsEditorScreen extends StatelessWidget {
  final int season;
  final String seasonGrandPrixId;

  const SeasonGrandPrixResultsEditorScreen({
    super.key,
    required this.season,
    required this.seasonGrandPrixId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => getIt<SeasonGrandPrixResultsEditorCubit>(
            param1: season,
            param2: seasonGrandPrixId,
          )..initialize(),
      child: const _ActionStatusListener(
        child: SeasonGrandPrixResultsEditorContent(),
      ),
    );
  }
}

class _ActionStatusListener extends StatelessWidget {
  final Widget child;

  const _ActionStatusListener({required this.child});

  void _onActionStatusChanged(
    BuildContext context,
    SeasonGrandPrixResultsEditorStateLoaded loadedState,
  ) {
    final SeasonGrandPrixResultsEditorStateActionStatus actionStatus =
        loadedState.actionStatus;
    final DialogService dialogService = getIt<DialogService>();

    switch (actionStatus) {
      case SeasonGrandPrixResultsEditorStateActionStatus.initial:
        break;
      case SeasonGrandPrixResultsEditorStateActionStatus.saving:
        dialogService.showLoadingDialog();
        break;
      case SeasonGrandPrixResultsEditorStateActionStatus.saved:
        dialogService.closeLoadingDialog();
        dialogService.showSnackbarMessage(
          context.str.seasonGrandPrixResultsEditorSuccessfullySavedResults,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<
      SeasonGrandPrixResultsEditorCubit,
      SeasonGrandPrixResultsEditorState
    >(
      listenWhen:
          (prevState, currState) =>
              prevState is SeasonGrandPrixResultsEditorStateLoaded &&
              currState is SeasonGrandPrixResultsEditorStateLoaded &&
              prevState.actionStatus != currState.actionStatus,
      listener:
          (BuildContext context, SeasonGrandPrixResultsEditorState state) =>
              _onActionStatusChanged(
                context,
                state as SeasonGrandPrixResultsEditorStateLoaded,
              ),
      child: child,
    );
  }
}
