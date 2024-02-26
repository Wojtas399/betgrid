import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/user.dart' as user;
import '../../config/router/app_router.dart';
import '../../extensions/build_context_extensions.dart';
import '../../provider/all_grand_prix_bets_initialization_provider.dart';
import '../../provider/logged_user_data_notifier_provider.dart';
import '../../service/dialog_service.dart';
import '../required_data_completion/ui/required_data_completion_screen.dart';
import 'home_app_bar.dart';

@RoutePage()
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _onLoggedUserDataChanged(AsyncValue<user.User?> asyncValue) async {
    if (asyncValue is AsyncData && asyncValue.value == null) {
      await showFullScreenDialog(const RequiredDataCompletionScreen());
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      loggedUserDataNotifierProvider,
      (previous, next) {
        _onLoggedUserDataChanged(next);
      },
    );
    ref.read(allGrandPrixBetsInitializationProvider);

    return AutoTabsRouter.pageView(
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
    );
  }
}
