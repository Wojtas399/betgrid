import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import '../../extensions/build_context_extensions.dart';
import '../../service/dialog_service.dart';
import 'component/season_drivers_editor_content.dart';
import 'cubit/season_drivers_editor_cubit.dart';
import 'cubit/season_drivers_editor_state.dart';

@RoutePage()
class SeasonDriversEditorScreen extends StatelessWidget {
  const SeasonDriversEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              getIt<SeasonDriversEditorCubit>()
                ..initializeDriversListener()
                ..initializeSeason(),
      child: const _CubitStatusListener(child: SeasonDriversEditorContent()),
    );
  }
}

class _CubitStatusListener extends StatelessWidget {
  final Widget child;

  const _CubitStatusListener({required this.child});

  void _onStatusChanged(BuildContext context, SeasonDriversEditorState state) {
    final cubitStatus = state.status;
    final dialogService = getIt<DialogService>();
    if (cubitStatus.isDeletingDriverFromSeason) {
      dialogService.showLoadingDialog();
    } else if (cubitStatus.hasDriverBeenDeletedFromSeason) {
      dialogService.closeLoadingDialog();
      dialogService.showSnackbarMessage(
        context.str.seasonDriversEditorSuccessfullyDeletedSeasonDriver,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SeasonDriversEditorCubit, SeasonDriversEditorState>(
      listenWhen:
          (prevState, currState) => prevState.status != currState.status,
      listener: _onStatusChanged,
      child: child,
    );
  }
}
