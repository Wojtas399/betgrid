import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../model/driver_details.dart';
import '../stats_model/best_points.dart';
import '../stats_model/players_podium.dart';
import '../stats_model/points_by_driver.dart';
import '../stats_model/points_history.dart';

part 'stats_state.freezed.dart';

enum StatsType {
  grouped,
  individual,
}

enum StatsStateStatus {
  initial,
  pointsForDriverLoading,
  noData,
  changingStatsType,
  completed,
  playersDontExist,
}

extension StatsStateStatusExtensions on StatsStateStatus {
  bool get isInitial => this == StatsStateStatus.initial;

  bool get arePointsForDriverLoading =>
      this == StatsStateStatus.pointsForDriverLoading;

  bool get isNoData => this == StatsStateStatus.noData;

  bool get isChangingStatsType => this == StatsStateStatus.changingStatsType;
}

@freezed
class StatsState with _$StatsState {
  const factory StatsState({
    @Default(StatsType.grouped) StatsType type,
    @Default(StatsStateStatus.initial) StatsStateStatus status,
    PlayersPodium? playersPodium,
    PointsHistory? pointsHistory,
    List<DriverDetails>? detailsOfDriversFromSeason,
    List<PointsByDriverPlayerPoints>? pointsByDriver,
    BestPoints? bestPoints,
  }) = _StatsState;
}
