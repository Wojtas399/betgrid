import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../../../dependency_injection.dart';
import '../../config/router/app_router.dart';
import 'component/sign_in_content.dart';
import 'cubit/sign_in_cubit.dart';
import 'cubit/sign_in_state.dart';

@RoutePage()
class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt.get<SignInCubit>()..initialize(),
    child: const _AuthStateListener(child: SignInContent()),
  );
}

class _AuthStateListener extends StatelessWidget {
  final Widget child;

  const _AuthStateListener({required this.child});

  void _onAuthStateChanged(BuildContext context, SignInState state) {
    if (state is SignInStateUserIsAlreadySignedIn) {
      context.replaceRoute(const HomeRoute());
    } else {
      FlutterNativeSplash.remove();
    }
  }

  @override
  Widget build(BuildContext context) => BlocListener<SignInCubit, SignInState>(
    listener: _onAuthStateChanged,
    child: child,
  );
}
