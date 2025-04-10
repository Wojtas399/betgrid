import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../model/driver_details.dart';
import '../../../../use_case/get_details_of_all_drivers_from_season_use_case.dart';
import '../../../common_cubit/season_cubit.dart';
import '../../../extensions/list_of_driver_details_extensions.dart';
import '../stats_creator/create_best_points.dart';
import '../stats_creator/create_logged_user_points_for_drivers_stats.dart';
import '../stats_creator/create_players_podium_stats.dart';
import '../stats_creator/create_points_for_driver_stats.dart';
import '../stats_creator/create_points_history_stats.dart';
import '../stats_model/best_points.dart';
import '../stats_model/players_podium.dart';
import '../stats_model/points_for_driver.dart';
import '../stats_model/points_history.dart';
import 'stats_state.dart';

@injectable
class StatsCubit extends Cubit<StatsState> {
  final GetDetailsOfAllDriversFromSeasonUseCase
  _getDetailsOfAllDriversFromSeasonUseCase;
  final CreatePlayersPodiumStats _createPlayersPodiumStats;
  final CreatePointsHistoryStats _createPointsHistoryStats;
  final CreatePointsForDriverStats _createPointsForDriverStats;
  final CreateBestPoints _createBestPoints;
  final CreateLoggedUserPointsForDriversStats
  _createLoggedUserPointsForDriversStats;
  final SeasonCubit _seasonCubit;
  StreamSubscription<_ListenedStatsParams>? _listener;

  StatsCubit(
    this._getDetailsOfAllDriversFromSeasonUseCase,
    this._createPlayersPodiumStats,
    this._createPointsHistoryStats,
    this._createPointsForDriverStats,
    this._createBestPoints,
    this._createLoggedUserPointsForDriversStats,
    @factoryParam this._seasonCubit,
  ) : super(const StatsState());

  @override
  Future<void> close() {
    _listener?.cancel();
    return super.close();
  }

  void initialize() {
    _listener ??= _getListenedParams(
      StatsType.grouped,
    ).listen(_manageListenedParams);
  }

  void onStatsTypeChanged(StatsType type) {
    emit(state.copyWith(status: StatsStateStatus.changingStatsType));
    _listener?.cancel();
    _listener = _getListenedParams(type).listen(_manageListenedParams);
  }

  Future<void> onDriverChanged(String seasonDriverId) async {
    final Stats? stats = state.stats;
    if (stats is GroupedStats) {
      emit(state.copyWith(status: StatsStateStatus.pointsForDriverLoading));
      final playersPointsForDriver$ = _createPointsForDriverStats(
        season: _seasonCubit.state,
        seasonDriverId: seasonDriverId,
      );
      await for (final playersPointsForDriver in playersPointsForDriver$) {
        emit(
          state.copyWith(
            status: StatsStateStatus.completed,
            stats: stats.copyWithPlayersPointsForDriver(playersPointsForDriver),
          ),
        );
      }
    }
  }

  Stream<_ListenedStatsParams> _getListenedParams(StatsType statsType) {
    return switch (statsType) {
      StatsType.grouped => _getListenedGroupedStatsParams(statsType),
      StatsType.individual => _getListenedIndividualStatsParams(statsType),
    };
  }

  void _manageListenedParams(_ListenedStatsParams params) {
    switch (params) {
      case _ListenedGroupedStatsParams():
        _manageListenedGroupedStatsParams(params);
      case _ListenedIndividualStatsParams():
        _manageListenedIndividualStatsParams(params);
    }
  }

  Stream<_ListenedStatsParams> _getListenedGroupedStatsParams(
    StatsType statsType,
  ) {
    final currentSeason = _seasonCubit.state;
    return Rx.combineLatest4(
      _createPlayersPodiumStats(season: currentSeason),
      _createBestPoints(statsType: statsType, season: currentSeason),
      _createPointsHistoryStats(statsType: statsType, season: currentSeason),
      _getDetailsOfAllDriversFromSeasonUseCase(currentSeason),
      (
        PlayersPodium? playersPodium,
        BestPoints? bestPoints,
        PointsHistory? pointsHistory,
        List<DriverDetails> detailsOfDriversFromSeason,
      ) => _ListenedGroupedStatsParams(
        playersPodium: playersPodium,
        bestPoints: bestPoints,
        pointsHistory: pointsHistory,
        detailsOfDriversFromSeason: detailsOfDriversFromSeason,
      ),
    );
  }

  Stream<_ListenedStatsParams> _getListenedIndividualStatsParams(
    StatsType statsType,
  ) {
    final currentSeason = _seasonCubit.state;
    return Rx.combineLatest3(
      _createBestPoints(statsType: statsType, season: currentSeason),
      _createPointsHistoryStats(statsType: statsType, season: currentSeason),
      _createLoggedUserPointsForDriversStats(season: currentSeason),
      (
        BestPoints? bestPoints,
        PointsHistory? pointsHistory,
        List<PointsForDriver>? pointsForDrivers,
      ) => _ListenedIndividualStatsParams(
        bestPoints: bestPoints,
        pointsHistory: pointsHistory,
        pointsForDrivers: pointsForDrivers,
      ),
    );
  }

  void _manageListenedGroupedStatsParams(_ListenedGroupedStatsParams params) {
    final sortedDetailsOfDriversFromSeason = [
      ...params.detailsOfDriversFromSeason,
    ]..sortByTeamAndSurname();
    final List<DriverDetails> drivers =
        sortedDetailsOfDriversFromSeason
            .where((DriverDetails driverDetails) => driverDetails.number > 0)
            .toList();
    final List<DriverDetails> reserveDrivers =
        sortedDetailsOfDriversFromSeason
            .where((DriverDetails driverDetails) => driverDetails.number == 0)
            .toList();

    emit(
      state.copyWith(
        status: StatsStateStatus.completed,
        stats: GroupedStats(
          playersPodium: params.playersPodium,
          bestPoints: params.bestPoints,
          pointsHistory: params.pointsHistory,
          detailsOfDriversFromSeason: [...drivers, ...reserveDrivers],
          playersPointsForDriver: [],
        ),
      ),
    );
  }

  void _manageListenedIndividualStatsParams(
    _ListenedIndividualStatsParams params,
  ) {
    emit(
      state.copyWith(
        status: StatsStateStatus.completed,
        stats: IndividualStats(
          bestPoints: params.bestPoints,
          pointsHistory: params.pointsHistory,
          pointsForDrivers: params.pointsForDrivers,
        ),
      ),
    );
  }
}

sealed class _ListenedStatsParams extends Equatable {
  const _ListenedStatsParams();
}

class _ListenedGroupedStatsParams extends _ListenedStatsParams {
  final PlayersPodium? playersPodium;
  final BestPoints? bestPoints;
  final PointsHistory? pointsHistory;
  final Iterable<DriverDetails> detailsOfDriversFromSeason;

  const _ListenedGroupedStatsParams({
    required this.playersPodium,
    required this.bestPoints,
    required this.pointsHistory,
    required this.detailsOfDriversFromSeason,
  });

  @override
  List<Object?> get props => [
    playersPodium,
    bestPoints,
    pointsHistory,
    detailsOfDriversFromSeason,
  ];
}

class _ListenedIndividualStatsParams extends _ListenedStatsParams {
  final BestPoints? bestPoints;
  final PointsHistory? pointsHistory;
  final List<PointsForDriver>? pointsForDrivers;

  const _ListenedIndividualStatsParams({
    required this.bestPoints,
    required this.pointsHistory,
    required this.pointsForDrivers,
  });

  @override
  List<Object?> get props => [bestPoints, pointsHistory, pointsForDrivers];
}
