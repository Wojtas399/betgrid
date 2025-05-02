import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../../../dependency_injection.dart';
import '../../common_cubit/season_cubit.dart';
import '../../config/router/app_router.dart';
import '../../service/dialog_service.dart';
import '../required_data_completion/required_data_completion_screen.dart';
import 'component/home_content.dart';
import 'cubit/home_cubit.dart';
import 'cubit/home_state.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create:
        (BuildContext context) =>
            getIt.get<HomeCubit>(param1: context.read<SeasonCubit>())
              ..initialize(),
    child: const _ActionStatusListener(child: HomeContent()),
  );
}

class _ActionStatusListener extends StatelessWidget {
  final Widget child;

  const _ActionStatusListener({required this.child});

  void _onStateChanged(BuildContext context, HomeStateLoaded state) {
    FlutterNativeSplash.remove();
    switch (state.actionStatus) {
      case HomeActionStatus.userDataNotCompleted:
        getIt<DialogService>().showFullScreenDialog(
          const RequiredDataCompletionScreen(),
        );
      case HomeActionStatus.userSignedOut:
        context.router.replaceAll([const SignInRoute()]);
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listenWhen:
          (prev, curr) =>
              prev is HomeStateLoaded
                  ? curr is HomeStateLoaded &&
                      prev.actionStatus != curr.actionStatus
                  : curr is HomeStateLoaded,
      listener: (context, state) => _onStateChanged(context, state.loaded),
      child: child,
    );
  }
}
