import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/router/app_router.dart';
import '../../../service/dialog_service.dart';
import '../controller/sign_in_controller.dart';
import '../state/sign_in_state.dart';
import 'sign_in_app_bar.dart';
import 'sign_in_content.dart';

@RoutePage()
class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  void _manageViewModelState(
    AsyncValue<SignInState> asyncState,
    BuildContext context,
  ) {
    if (asyncState.isLoading) {
      showLoadingDialog();
    } else if (asyncState.hasValue) {
      switch (asyncState.value!) {
        case SignInStateUserIsSignedIn():
          closeLoadingDialog();
          context.replaceRoute(const HomeRoute());
        case SignInStateComplete():
          closeLoadingDialog();
        case _:
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      signInControllerProvider,
      (previousState, nextState) {
        _manageViewModelState(nextState, context);
      },
    );

    return const Scaffold(
      appBar: SignInAppBar(),
      body: SignInContent(),
    );
  }
}
