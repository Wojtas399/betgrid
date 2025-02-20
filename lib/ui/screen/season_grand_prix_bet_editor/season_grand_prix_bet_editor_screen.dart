import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import '../../extensions/build_context_extensions.dart';
import '../../service/dialog_service.dart';
import 'component/season_grand_prix_bet_editor_content.dart';
import 'cubit/season_grand_prix_bet_editor_cubit.dart';
import 'cubit/season_grand_prix_bet_editor_state.dart';

@RoutePage()
class SeasonGrandPrixBetEditorScreen extends StatelessWidget {
  final int season;
  final String seasonGrandPrixId;

  const SeasonGrandPrixBetEditorScreen({
    super.key,
    required this.season,
    required this.seasonGrandPrixId,
  });

  @override
  Widget build(BuildContext context) => BlocProvider(
    create:
        (_) => getIt<SeasonGrandPrixBetEditorCubit>(
          param1: season,
          param2: seasonGrandPrixId,
        )..initialize(),
    child: const _CubitStatusListener(child: SeasonGrandPrixBetEditorContent()),
  );
}

class _CubitStatusListener extends StatelessWidget {
  final Widget child;

  const _CubitStatusListener({required this.child});

  void _onCubitStatusChanged(
    BuildContext context,
    SeasonGrandPrixBetEditorStateStatus status,
  ) {
    final dialogService = getIt<DialogService>();
    if (status.isSaving) {
      dialogService.showLoadingDialog();
    } else if (status.isSuccessfullySaved) {
      dialogService.closeLoadingDialog();
      dialogService.showSnackbarMessage(
        context.str.grandPrixBetEditorSuccessfullySavedBets,
      );
    }
  }

  @override
  Widget build(BuildContext context) => BlocListener<
    SeasonGrandPrixBetEditorCubit,
    SeasonGrandPrixBetEditorState
  >(
    listenWhen: (prevState, currState) => currState.status != prevState.status,
    listener: (context, state) => _onCubitStatusChanged(context, state.status),
    child: child,
  );
}
