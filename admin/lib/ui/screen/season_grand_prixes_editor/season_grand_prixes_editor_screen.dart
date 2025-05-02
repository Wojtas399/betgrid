import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import '../../extensions/build_context_extensions.dart';
import '../../service/dialog_service.dart';
import 'component/season_grand_prixes_editor_content.dart';
import 'cubit/season_grand_prixes_editor_cubit.dart';
import 'cubit/season_grand_prixes_editor_state.dart';

@RoutePage()
class SeasonGrandPrixesEditorScreen extends StatelessWidget {
  const SeasonGrandPrixesEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              getIt<SeasonGrandPrixesEditorCubit>()
                ..initializeSeason()
                ..initializeGrandPrixes(),
      child: const _CubitStatusListener(
        child: SeasonGrandPrixesEditorContent(),
      ),
    );
  }
}

class _CubitStatusListener extends StatelessWidget {
  final Widget child;

  const _CubitStatusListener({required this.child});

  void _onStatusChanged(
    BuildContext context,
    SeasonGrandPrixesEditorState state,
  ) {
    final dialogService = getIt<DialogService>();
    final status = state.status;
    if (status.isDeletingGrandPrixFromSeason) {
      dialogService.showLoadingDialog();
    } else if (status.hasGrandPrixBeenDeletedFromSeason) {
      dialogService.closeLoadingDialog();
      dialogService.showSnackbarMessage(
        context
            .str
            .seasonGrandPrixesEditorSuccessfullyDeletedGrandPrixFromSeason,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<
      SeasonGrandPrixesEditorCubit,
      SeasonGrandPrixesEditorState
    >(
      listenWhen:
          (prevState, currState) => prevState.status != currState.status,
      listener: _onStatusChanged,
      child: child,
    );
  }
}
