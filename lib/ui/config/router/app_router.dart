import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../extensions/build_context_extensions.dart';
import '../../screen/screens.dart';

part 'app_router.gr.dart';

@Singleton()
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SignInRoute.page, initial: true),
    AutoRoute(
      page: HomeBaseRoute.page,
      children: [
        AutoRoute(
          page: HomeRoute.page,
          children: [
            AutoRoute(
              page: StatsRoute.page,
              title: (context, _) => context.str.statsScreenTitle,
            ),
            AutoRoute(
              page: SeasonGrandPrixBetsRoute.page,
              title: (context, _) => context.str.seasonGrandPrixBetsScreenTitle,
            ),
            AutoRoute(
              page: PlayersRoute.page,
              title: (context, _) => context.str.playersScreenTitle,
            ),
          ],
        ),
        AutoRoute(page: SeasonGrandPrixBetRoute.page),
        AutoRoute(page: ProfileRoute.page),
        AutoRoute(page: PlayerProfileRoute.page),
      ],
    ),
  ];
}
