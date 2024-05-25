import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../model/driver.dart';
import '../stats_model/players_podium.dart';
import '../stats_model/points_by_driver.dart';
import '../stats_model/points_history.dart';

part 'stats_state.freezed.dart';

enum StatsStateStatus {
  loading,
  pointsForDriverLoading,
  completed,
  playersDontExist,
}

@freezed
class StatsState with _$StatsState {
  const StatsState._();

  const factory StatsState({
    @Default(StatsStateStatus.loading) StatsStateStatus status,
    PlayersPodium? playersPodium,
    PointsHistory? pointsHistory,
    List<Driver>? allDrivers,
    List<PointsByDriverPlayerPoints>? pointsByDriver,
  }) = _StatsState;

  bool get isLoading => status == StatsStateStatus.loading;

  bool get arePointsForDriverLoading =>
      status == StatsStateStatus.pointsForDriverLoading;
}
