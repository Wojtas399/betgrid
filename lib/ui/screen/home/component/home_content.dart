import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../../../../dependency_injection.dart';
import '../../../service/dialog_service.dart';
import '../../required_data_completion/required_data_completion_screen.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import 'home_loaded_content.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeState state = context.watch<HomeCubit>().state;

    if (state is! HomeStateInitial) {
      FlutterNativeSplash.remove();
    }
    if (state is HomeStateLoggedUserDataNotCompleted) {
      getIt<DialogService>().showFullScreenDialog(
        const RequiredDataCompletionScreen(),
      );
    }

    return switch (state) {
      HomeStateLoaded() => HomeLoadedContent(),
      _ => const _LoadingContent(),
    };
  }
}

class _LoadingContent extends StatelessWidget {
  const _LoadingContent();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
