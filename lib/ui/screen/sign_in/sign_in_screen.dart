import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repository/auth/auth_repository.dart';
import '../../../dependency_injection.dart';
import '../../../model/auth_state.dart';
import '../../config/router/app_router.dart';
import 'sign_in_app_bar.dart';
import 'sign_in_content.dart';

@RoutePage()
class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  void _manageAuthProviderState(
    AuthState authState,
    BuildContext context,
  ) {
    if (authState is AuthStateUserIsSignedIn) {
      context.replaceRoute(const HomeRoute());
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    getIt.get<AuthRepository>().authState$.listen(
          (AuthState authState) => _manageAuthProviderState(authState, context),
        );

    return const Scaffold(
      appBar: SignInAppBar(),
      body: SignInContent(),
    );
  }
}
