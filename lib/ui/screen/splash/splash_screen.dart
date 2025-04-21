import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../../../dependency_injection.dart';
import '../../config/router/app_router.dart';
import 'component/splash_content.dart';
import 'cubit/splash_cubit.dart';
import 'cubit/splash_state.dart';

@RoutePage()
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();

    return BlocProvider(
      create: (_) => getIt<SplashCubit>()..init(),
      child: const _SplashCubitListener(child: SplashContent()),
    );
  }
}

class _SplashCubitListener extends StatelessWidget {
  final Widget child;

  const _SplashCubitListener({required this.child});

  void _onStateChanged(BuildContext context, SplashState state) {
    if (state is SplashStateNewAppVersionAvailable) {
      context.pushRoute(const NewVersionAvailableRoute());
    } else if (state is SplashStateLoaded) {
      context.pushRoute(
        state.isLoggedIn ? const HomeRoute() : const SignInRoute(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: _onStateChanged,
      child: child,
    );
  }
}
