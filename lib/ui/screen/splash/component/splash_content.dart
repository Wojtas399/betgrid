import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/text_component.dart';
import '../cubit/splash_cubit.dart';
import '../cubit/splash_state.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _Logo(),
          SizedBox(height: 32),
          TitleLarge('Ładowanie...'),
          SizedBox(height: 16),
          _ProgressIndicator(),
        ],
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DisplayLarge('Bet', fontWeight: FontWeight.bold),
        DisplayLarge('Grid', color: Colors.red, fontWeight: FontWeight.bold),
      ],
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
