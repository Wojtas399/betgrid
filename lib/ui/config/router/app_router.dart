import 'package:auto_route/auto_route.dart';

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
            AutoRoute(page: HomeRoute.page),
            AutoRoute(page: QualificationsBetRoute.page),
          ],
        ),
      ];
}
