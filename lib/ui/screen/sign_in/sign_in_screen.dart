import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/router/app_router.dart';
import '../../provider/auth/auth_provider.dart';
import '../../provider/auth/auth_state.dart';
import '../../service/dialog_service.dart';
import 'sign_in_app_bar.dart';
import 'sign_in_content.dart';

@RoutePage()
class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  void _manageAuthProviderState(
    AsyncValue<AuthState> asyncAuthState,
    BuildContext context,
  ) {
    if (asyncAuthState.isLoading) {
      showLoadingDialog();
    } else if (asyncAuthState.hasValue) {
      switch (asyncAuthState.value!) {
        case AuthStateUserIsSignedIn():
          closeLoadingDialog();
          context.replaceRoute(const HomeRoute());
        case AuthStateComplete():
          closeLoadingDialog();
        case _:
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      authProvider,
      (previousState, nextState) {
        _manageAuthProviderState(nextState, context);
      },
    );

    return const Scaffold(
      appBar: SignInAppBar(),
      body: SignInContent(),
    );
  }
}
