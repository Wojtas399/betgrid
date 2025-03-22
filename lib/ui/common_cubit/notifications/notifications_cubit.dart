import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../data/repository/notifications/notifications_repository.dart';
import '../../../data/repository/notifications/notifications_repository_impl.dart';
import '../../../model/notification.dart';
import 'notifications_state.dart';

@injectable
class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepository _notificationsRepository =
      NotificationsRepositoryImpl.instance;
  StreamSubscription<Notification>? _openedNotificationSubscription;

  NotificationsCubit() : super(NotificationsStateInitial());

  @override
  Future<void> close() {
    _openedNotificationSubscription?.cancel();
    return super.close();
  }

  Future<void> initialize() async {
    await _notificationsRepository.initialize();

    _openedNotificationSubscription = _notificationsRepository
        .getOpenedNotification()
        .listen(_manageOpenedNotification);
  }

  void _manageOpenedNotification(Notification notification) {
    if (notification is SeasonGpBetNotification) {
      emit(
        NotificationsStateSeasonGpBetOpened(
          season: notification.season,
          seasonGrandPrixId: notification.seasonGrandPrixId,
        ),
      );
    }
  }
}
