import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../model/driver.dart';
import '../../../../use_case/get_all_drivers_from_season_use_case.dart';
import '../../../extensions/drivers_list_extensions.dart';
import '../stats_creator/create_players_podium_stats.dart';
import '../stats_creator/create_points_for_driver_stats.dart';
import '../stats_creator/create_points_history_stats.dart';
import '../stats_model/players_podium.dart';
import '../stats_model/points_history.dart';
import 'stats_state.dart';

@injectable
class StatsCubit extends Cubit<StatsState> {
  final GetAllDriversFromSeasonUseCase _getAllDriversFromSeasonUseCase;
  final CreatePlayersPodiumStats _createPlayersPodiumStats;
  final CreatePointsHistoryStats _createPointsHistoryStats;
  final CreatePointsForDriverStats _createPointsForDriverStats;

  StatsCubit(
    this._getAllDriversFromSeasonUseCase,
    this._createPlayersPodiumStats,
    this._createPointsHistoryStats,
    this._createPointsForDriverStats,
  ) : super(const StatsState());

  Future<void> initialize() async {
    final listenedParams$ = Rx.combineLatest3(
      _createPlayersPodiumStats(),
      _createPointsHistoryStats(),
      _getAllDriversFromSeasonUseCase(2024),
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
        sortedDrivers.sortByTeamAndSurname();
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
