import 'package:equatable/equatable.dart';

abstract class Notification extends Equatable {
  const Notification();

  @override
  List<Object?> get props => [];
}

class EmptyNotification extends Notification {
  const EmptyNotification();
}

class SeasonGpBetNotification extends Notification {
  final int season;
  final String seasonGrandPrixId;

  const SeasonGpBetNotification({
    required this.season,
    required this.seasonGrandPrixId,
  });

  @override
  List<Object?> get props => [season, seasonGrandPrixId];
}
