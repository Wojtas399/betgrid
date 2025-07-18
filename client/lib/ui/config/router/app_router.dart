import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../screen/screens.dart';

part 'app_router.gr.dart';

@Singleton()
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: NewVersionAvailableRoute.page),
    AutoRoute(page: SignInRoute.page),
    AutoRoute(
      page: HomeBaseRoute.page,
      children: [
        AutoRoute(page: HomeRoute.page),
        AutoRoute(page: SeasonGrandPrixBetRoute.page),
        AutoRoute(page: ProfileRoute.page),
        AutoRoute(page: PlayerProfileRoute.page),
        AutoRoute(page: SeasonTeamDetailsRoute.page),
      ],
    ),
  ];
}
