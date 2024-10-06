import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/repository/driver/driver_repository.dart';
import '../../../../model/driver.dart';
import '../stats_creator/create_players_podium_stats.dart';
import '../stats_creator/create_points_for_driver_stats.dart';
import '../stats_creator/create_points_history_stats.dart';
import '../stats_model/players_podium.dart';
import '../stats_model/points_history.dart';
import 'stats_state.dart';

@injectable
class StatsCubit extends Cubit<StatsState> {
  final DriverRepository _driverRepository;
  final CreatePlayersPodiumStats _createPlayersPodiumStats;
  final CreatePointsHistoryStats _createPointsHistoryStats;
  final CreatePointsForDriverStats _createPointsForDriverStats;

  StatsCubit(
    this._driverRepository,
    this._createPlayersPodiumStats,
    this._createPointsHistoryStats,
    this._createPointsForDriverStats,
  ) : super(const StatsState());

  Future<void> initialize() async {
    final listenedParams$ = Rx.combineLatest3(
      _createPlayersPodiumStats(),
      _createPointsHistoryStats(),
      _driverRepository.getAllDrivers(),
      (
        PlayersPodium? playersPodium,
        PointsHistory? pointsHistory,
        List<Driver> allDrivers,
      ) =>
          _ListenedParams(
        playersPodium: playersPodium,
        pointsHistory: pointsHistory,
        allDrivers: allDrivers,
      ),
    );
    await for (final params in listenedParams$) {
      if (params.noData) {
        emit(state.copyWith(
          status: StatsStateStatus.noData,
        ));
      } else {
        final sortedDrivers = [...params.allDrivers];
        sortedDrivers.sort(_sortDriversByTeam);
        emit(state.copyWith(
          status: StatsStateStatus.completed,
          playersPodium: params.playersPodium,
          pointsHistory: params.pointsHistory,
          pointsByDriver: [],
          allDrivers: sortedDrivers,
        ));
      }
    }
  }

  Future<void> onDriverChanged(String driverId) async {
    emit(state.copyWith(
      status: StatsStateStatus.pointsForDriverLoading,
    ));
    final pointsByDriverData$ = _createPointsForDriverStats(driverId: driverId);
    await for (final pointsByDriverData in pointsByDriverData$) {
      emit(state.copyWith(
        status: StatsStateStatus.completed,
        pointsByDriver: pointsByDriverData,
      ));
    }
  }

  int _sortDriversByTeam(Driver d1, Driver d2) =>
      d1.team.toString().compareTo(d2.team.toString());
}

class _ListenedParams extends Equatable {
  final PlayersPodium? playersPodium;
  final PointsHistory? pointsHistory;
  final Iterable<Driver> allDrivers;

  const _ListenedParams({
    required this.playersPodium,
    required this.pointsHistory,
    required this.allDrivers,
  });

  @override
  List<Object?> get props => [
        playersPodium,
        pointsHistory,
        allDrivers,
      ];

  bool get noData =>
      playersPodium == null && pointsHistory == null && allDrivers.isEmpty;
}
