import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../model/driver_details.dart';
import '../stats_model/players_podium.dart';
import '../stats_model/points_by_driver.dart';
import '../stats_model/points_history.dart';

part 'stats_state.freezed.dart';

enum StatsType {
  grouped,
  individual,
}

enum StatsStateStatus {
  loading,
  pointsForDriverLoading,
  noData,
  completed,
  playersDontExist,
}

extension StatsStateStatusExtensions on StatsStateStatus {
  bool get isLoading => this == StatsStateStatus.loading;

  bool get arePointsForDriverLoading =>
      this == StatsStateStatus.pointsForDriverLoading;

  bool get isNoData => this == StatsStateStatus.noData;
}

@freezed
class StatsState with _$StatsState {
  const factory StatsState({
    @Default(StatsType.grouped) StatsType type,
    @Default(StatsStateStatus.loading) StatsStateStatus status,
    PlayersPodium? playersPodium,
    PointsHistory? pointsHistory,
    List<DriverDetails>? detailsOfDriversFromSeason,
    List<PointsByDriverPlayerPoints>? pointsByDriver,
  }) = _StatsState;
}
