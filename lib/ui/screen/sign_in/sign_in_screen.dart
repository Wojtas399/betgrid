import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import '../../config/router/app_router.dart';
import 'cubit/sign_in_cubit.dart';
import 'cubit/sign_in_state.dart';
import 'sign_in_app_bar.dart';
import 'sign_in_body.dart';

@RoutePage()
class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => getIt.get<SignInCubit>()..initialize(),
        child: const _Content(),
      );
}

class _Content extends StatelessWidget {
  const _Content();

  void _onAuthStateChanged(
    bool isUserAlreadySignedIn,
    BuildContext context,
  ) {
    if (isUserAlreadySignedIn) {
      context.replaceRoute(const HomeRoute());
    }
  }

  @override
  Widget build(BuildContext context) => BlocListener<SignInCubit, SignInState>(
        listenWhen: (prevState, currState) =>
            prevState.isUserAlreadySignedIn != currState.isUserAlreadySignedIn,
        listener: (_, SignInState state) =>
            _onAuthStateChanged(state.isUserAlreadySignedIn, context),
        child: const Scaffold(
          appBar: SignInAppBar(),
          body: SignInBody(),
        ),
      );
}
