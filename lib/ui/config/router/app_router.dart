import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../model/player.dart';
import '../../extensions/build_context_extensions.dart';
import '../../screen/screens.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
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
                  page: BetsRoute.page,
                  title: (context, _) => context.str.betsScreenTitle,
                ),
                AutoRoute(
                  page: PlayersRoute.page,
                  title: (context, _) => context.str.playersScreenTitle,
                ),
              ],
            ),
            AutoRoute(page: GrandPrixBetRoute.page),
            AutoRoute(page: ProfileRoute.page),
            AutoRoute(page: PlayerProfileRoute.page),
          ],
        ),
      ];
}
