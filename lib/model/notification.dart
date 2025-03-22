import 'package:equatable/equatable.dart';

abstract class Notification extends Equatable {
  const Notification();
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
