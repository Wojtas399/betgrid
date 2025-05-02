import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../config/router/app_router.dart';
import '../../extensions/build_context_extensions.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => AutoTabsRouter.tabBar(
    routes: const [SeasonGrandPrixesResultsRoute(), EditorsRoute()],
    builder: (context, child, animation) {
      final tabsRouter = AutoTabsRouter.of(context);

      return Scaffold(
        appBar: AppBar(title: Text(context.str.homeScreenTitle)),
        body: SafeArea(child: child),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: tabsRouter.activeIndex,
          onTap: tabsRouter.setActiveIndex,
          selectedItemColor: context.colorScheme.primary,
          items: [
            BottomNavigationBarItem(
              label: context.str.seasonGrandPrixesResultsScreenTitle,
              icon: const Icon(Icons.menu_rounded),
            ),
            BottomNavigationBarItem(
              label: context.str.editorsScreenTitle,
              icon: const Icon(Icons.edit),
            ),
          ],
        ),
      );
    },
  );
}
