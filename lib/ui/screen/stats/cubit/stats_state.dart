import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../model/driver_details.dart';
import '../stats_model/best_points.dart';
import '../stats_model/players_podium.dart';
import '../stats_model/player_points.dart';
import '../stats_model/points_for_driver.dart';
import '../stats_model/points_history.dart';

part 'stats_state.freezed.dart';

enum StatsType { grouped, individual }

enum StatsStateStatus {
  initial,
  pointsForDriverLoading,
  changingStatsType,
  completed,
  playersDontExist,
}

extension StatsStateStatusExtensions on StatsStateStatus {
  bool get isInitial => this == StatsStateStatus.initial;

  bool get arePointsForDriverLoading =>
      this == StatsStateStatus.pointsForDriverLoading;

  bool get isChangingStatsType => this == StatsStateStatus.changingStatsType;
}

@freezed
class StatsState with _$StatsState {
  const StatsState._();

  const factory StatsState({
    @Default(StatsStateStatus.initial) StatsStateStatus status,
    Stats? stats,
  }) = _StatsState;

  bool get areGroupedStats => stats is GroupedStats;
}

sealed class Stats extends Equatable {
  final BestPoints? bestPoints;
  final PointsHistory? pointsHistory;

  const Stats({this.bestPoints, this.pointsHistory});

  @override
  List<Object?> get props => [bestPoints, pointsHistory];
}

class GroupedStats extends Stats {
  final PlayersPodium? playersPodium;
  final List<DriverDetails>? detailsOfDriversFromSeason;
  final List<PlayerPoints>? playersPointsForDriver;

  const GroupedStats({
    this.playersPodium,
    super.bestPoints,
    super.pointsHistory,
    this.detailsOfDriversFromSeason,
    this.playersPointsForDriver,
  });

  @override
  List<Object?> get props => [
    playersPodium,
    bestPoints,
    pointsHistory,
    detailsOfDriversFromSeason,
    playersPointsForDriver,
  ];

  GroupedStats copyWithPlayersPointsForDriver(
    List<PlayerPoints>? playersPointsForDriver,
  ) {
    return GroupedStats(
      playersPodium: playersPodium,
      bestPoints: bestPoints,
      pointsHistory: pointsHistory,
      detailsOfDriversFromSeason: detailsOfDriversFromSeason,
      playersPointsForDriver:
          playersPointsForDriver ?? this.playersPointsForDriver,
    );
  }
}

class IndividualStats extends Stats {
  final List<PointsForDriver>? pointsForDrivers;

  const IndividualStats({
    super.bestPoints,
    super.pointsHistory,
    this.pointsForDrivers,
  });

  @override
  List<Object?> get props => [bestPoints, pointsHistory, pointsForDrivers];
}
