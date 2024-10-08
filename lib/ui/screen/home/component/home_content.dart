import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/router/app_router.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../service/dialog_service.dart';
import '../../required_data_completion/ui/required_data_completion_screen.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import 'home_app_bar.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  void _onCubitStatusChanged(HomeStateStatus status) async {
    if (status.isLoggedUserDataNotCompleted) {
      await showFullScreenDialog(const RequiredDataCompletionScreen());
    }
  }

  @override
  Widget build(BuildContext context) => BlocListener<HomeCubit, HomeState>(
        listenWhen: (
          HomeState previousState,
          HomeState currentState,
        ) =>
            currentState.status != previousState.status,
        listener: (_, HomeState state) => _onCubitStatusChanged(state.status),
        child: AutoTabsRouter.tabBar(
          routes: const [
            StatsRoute(),
            BetsRoute(),
            PlayersRoute(),
          ],
          builder: (context, child, _) {
            final tabsRouter = AutoTabsRouter.of(context);
            return Scaffold(
              appBar: HomeAppBar(
                title: tabsRouter.current.title(context),
              ),
              body: SafeArea(
                child: child,
              ),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: tabsRouter.activeIndex,
                onTap: tabsRouter.setActiveIndex,
                selectedItemColor: context.colorScheme.primary,
                items: [
                  BottomNavigationBarItem(
                    label: context.str.statsScreenTitle,
                    icon: const Icon(Icons.bar_chart),
                  ),
                  BottomNavigationBarItem(
                    label: context.str.betsScreenTitle,
                    icon: const Icon(Icons.list),
                  ),
                  BottomNavigationBarItem(
                    label: context.str.playersScreenTitle,
                    icon: const Icon(Icons.people),
                  ),
                ],
              ),
            );
          },
        ),
      );
}
