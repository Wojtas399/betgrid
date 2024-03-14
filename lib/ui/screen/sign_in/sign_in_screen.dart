import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repository/auth/auth_repository.dart';
import '../../../model/auth_state.dart';
import '../../config/router/app_router.dart';
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
    asyncAuthState.when(
      data: (_) {
        closeLoadingDialog();
        context.replaceRoute(const HomeRoute());
      },
      error: (_, __) {
        closeLoadingDialog();
      },
      loading: () {
        showLoadingDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      authStateProvider,
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
