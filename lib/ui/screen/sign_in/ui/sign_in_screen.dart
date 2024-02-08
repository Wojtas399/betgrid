import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../view_model/sign_in_state.dart';
import '../view_model/sign_in_view_model.dart';
import 'sign_in_app_bar.dart';
import 'sign_in_content.dart';

@RoutePage()
class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  void _manageViewModelState(SignInState state, BuildContext context) {
    if (state is SignInStateUserIsSignedIn) {
      //TODO: Navigate to home screen
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
