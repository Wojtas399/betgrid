import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter/material.dart';

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
            AutoRoute(page: SeasonGrandPrixesResultsRoute.page),
            AutoRoute(page: EditorsRoute.page),
          ],
        ),
        AutoRoute(page: DriversEditorRoute.page),
        AutoRoute(page: SeasonDriversEditorRoute.page),
        AutoRoute(page: TeamsEditorRoute.page),
        AutoRoute(page: SeasonTeamsEditorRoute.page),
        AutoRoute(page: GrandPrixesEditorRoute.page),
        AutoRoute(page: SeasonGrandPrixesEditorRoute.page),
        AutoRoute(page: SeasonGrandPrixResultsEditorRoute.page),
      ],
    ),
  ];
}
