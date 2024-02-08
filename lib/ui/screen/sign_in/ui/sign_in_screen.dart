import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/router/app_router.dart';
import '../../../service/dialog_service.dart';
import '../view_model/sign_in_state.dart';
import '../view_model/sign_in_view_model.dart';
import 'sign_in_app_bar.dart';
import 'sign_in_content.dart';

@RoutePage()
class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  void _manageViewModelState(SignInState state, BuildContext context) {
    switch (state) {
      case SignInStateInitial():
        break;
      case SignInStateLoading():
        showLoadingDialog();
      case SignInStateUserIsSignedIn():
        closeLoadingDialog();
        context.replaceRoute(const HomeRoute());
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      signInViewModelProvider,
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
