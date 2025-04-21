import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../../../dependency_injection.dart';
import '../../component/text_component.dart';
import '../../config/router/app_router.dart';
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
      child: const _SplashCubitListener(child: _Body()),
    );
  }
}

class _SplashCubitListener extends StatelessWidget {
  final Widget child;

  const _SplashCubitListener({required this.child});

  void _onStateChanged(BuildContext context, SplashState state) {
    if (state is SplashStateNewAppVersionAvailable) {
      print('PUSH TO NEW APP VERSION SCREEN');
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

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return const Material(
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DisplayLarge(
                'Bet',
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              DisplayLarge(
                'Grid',
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          SizedBox(height: 32),
          TitleLarge('Ładowanie...', color: Colors.white),
          SizedBox(height: 16),
          _ProgressIndicator(),
        ],
      ),
    );
  }
}

class _ProgressIndicator extends StatelessWidget {
  const _ProgressIndicator();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SplashCubit>().state;

    return state is SplashStateLoading
        ? TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: state.progress),
          duration: const Duration(milliseconds: 300),
          builder:
              (_, double value, _) =>
                  CircularProgressIndicator(color: Colors.red, value: value),
        )
        : const SizedBox();
  }
}
