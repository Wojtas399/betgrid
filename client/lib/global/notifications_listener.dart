import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../ui/common_cubit/notifications/notifications_cubit.dart';
import '../ui/common_cubit/notifications/notifications_state.dart';
import '../ui/config/router/app_router.dart';

class NotificationsListener extends StatelessWidget {
  final Widget child;

  const NotificationsListener({super.key, required this.child});

  void _manageNotificationsState(
    BuildContext context,
    NotificationsState state,
  ) {
    if (state is NotificationsStateSeasonGpBetOpened) {
      context.pushRoute(
        SeasonGrandPrixBetRoute(
          season: state.season,
          seasonGrandPrixId: state.seasonGrandPrixId,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationsCubit, NotificationsState>(
      listener: _manageNotificationsState,
      child: child,
    );
  }
}
