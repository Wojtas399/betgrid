import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../dependency_injection.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../service/dialog_service.dart';
import '../cubit/season_grand_prix_bet_state.dart';
import '../editor/component/season_grand_prix_bet_editor_app_bar.dart';
import '../editor/cubit/season_grand_prix_bet_editor_cubit.dart';
import '../cubit/season_grand_prix_bet_cubit.dart';
import '../editor/component/season_grand_prix_bet_editor_body.dart';
import '../editor/cubit/season_grand_prix_bet_editor_state.dart';

class SeasonGrandPrixBetEditorContent extends StatelessWidget {
  const SeasonGrandPrixBetEditorContent({super.key});

  @override
  Widget build(BuildContext context) {
    final SeasonGrandPrixBetState state =
        context.read<SeasonGrandPrixBetCubit>().state;

    int? season;
    String? seasonGrandPrixId;
    if (state is SeasonGrandPrixBetStateEditor) {
      season = state.season;
      seasonGrandPrixId = state.seasonGrandPrixId;
    }

    return season != null && seasonGrandPrixId != null
        ? BlocProvider(
          create:
              (_) => getIt<SeasonGrandPrixBetEditorCubit>(
                param1: season,
                param2: seasonGrandPrixId,
              )..initialize(),
          child: const _EditorCubitStatusListener(
            child: Scaffold(
              appBar: SeasonGrandPrixBetEditorAppBar(),
              body: SafeArea(child: SeasonGrandPrixBetEditorBody()),
            ),
          ),
        )
        : const Placeholder();
  }
}

class _EditorCubitStatusListener extends StatelessWidget {
  final Widget child;

  const _EditorCubitStatusListener({required this.child});

  void _onStatusChanged(
    BuildContext context,
    SeasonGrandPrixBetEditorState state,
  ) {
    final SeasonGrandPrixBetEditorStateStatus status = state.status;
    final seasonGrandPrixBetCubit = context.read<SeasonGrandPrixBetCubit>();
    final dialogService = getIt<DialogService>();

    if (status.isSaving) {
      dialogService.showLoadingDialog();
      seasonGrandPrixBetCubit.onSaveStarted();
    } else if (status.isSuccessfullySaved) {
      dialogService.closeLoadingDialog();
      dialogService.showSnackbarMessage(
        context.str.grandPrixBetEditorSuccessfullySavedBets,
      );
      seasonGrandPrixBetCubit.onSaveFinished();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<
      SeasonGrandPrixBetEditorCubit,
      SeasonGrandPrixBetEditorState
    >(
      listenWhen:
          (prevState, currState) => prevState.status != currState.status,
      listener: _onStatusChanged,
      child: child,
    );
  }
}
