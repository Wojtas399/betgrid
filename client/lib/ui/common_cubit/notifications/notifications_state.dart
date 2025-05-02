import 'package:equatable/equatable.dart';

sealed class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object?> get props => [];
}

class NotificationsStateInitial extends NotificationsState {}

class NotificationsStateSeasonGpBetOpened extends NotificationsState {
  final int season;
  final String seasonGrandPrixId;

  const NotificationsStateSeasonGpBetOpened({
    required this.season,
    required this.seasonGrandPrixId,
  });

  @override
  List<Object?> get props => [season, seasonGrandPrixId];
}
