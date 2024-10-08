import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import '../../service/dialog_service.dart';
import 'component/required_data_completion_content.dart';
import 'cubit/required_data_completion_cubit.dart';
import 'cubit/required_data_completion_state.dart';

class RequiredDataCompletionScreen extends StatelessWidget {
  const RequiredDataCompletionScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => getIt.get<RequiredDataCompletionCubit>(),
        child: const _CubitStatusListener(
          child: RequiredDataCompletionContent(),
        ),
      );
}

class _CubitStatusListener extends StatelessWidget {
  final Widget child;

  const _CubitStatusListener({
    required this.child,
  });

  void _onCubiStatusChanged(
    RequiredDataCompletionStateStatus status,
    BuildContext context,
  ) {
    if (status.isLoading) {
      showLoadingDialog();
    } else if (status.hasDataBeenSaved) {
      closeLoadingDialog();
      context.maybePop();
    }
  }

  @override
  Widget build(BuildContext context) =>
      BlocListener<RequiredDataCompletionCubit, RequiredDataCompletionState>(
        listenWhen: (prevState, currState) =>
            prevState.status != currState.status,
        listener: (_, RequiredDataCompletionState state) =>
            _onCubiStatusChanged(state.status, context),
        child: child,
      );
}
