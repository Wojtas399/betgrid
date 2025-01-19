import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../model/driver_details.dart';
import '../../../../use_case/get_details_of_all_drivers_from_season_use_case.dart';
import '../../../extensions/list_of_driver_details_extensions.dart';
import '../../../service/date_service.dart';
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
  final DateService _dateService;
  final GetDetailsOfAllDriversFromSeasonUseCase
      _getDetailsOfAllDriversFromSeasonUseCase;
  final CreatePlayersPodiumStats _createPlayersPodiumStats;
  final CreatePointsHistoryStats _createPointsHistoryStats;
  final CreatePointsForDriverStats _createPointsForDriverStats;
  final CreateBestPoints _createBestPoints;
  final CreateLoggedUserPointsForDriversStats
      _createLoggedUserPointsForDriversStats;
  StreamSubscription<_ListenedStatsParams>? _listener;

  StatsCubit(
    this._dateService,
    this._getDetailsOfAllDriversFromSeasonUseCase,
    this._createPlayersPodiumStats,
    this._createPointsHistoryStats,
    this._createPointsForDriverStats,
    this._createBestPoints,
    this._createLoggedUserPointsForDriversStats,
  ) : super(const StatsState());

  @override
  Future<void> close() {
    _listener?.cancel();
    return super.close();
  }

  void initialize() {
    _listener ??= _getListenedParams(StatsType.grouped).listen(
      _manageListenedParams,
    );
  }

  void onStatsTypeChanged(StatsType type) {
    emit(state.copyWith(
      status: StatsStateStatus.changingStatsType,
    ));
    _listener?.cancel();
    _listener = _getListenedParams(type).listen(_manageListenedParams);
  }

  Future<void> onDriverChanged(String seasonDriverId) async {
    final Stats? stats = state.stats;
    if (stats is GroupedStats) {
      emit(state.copyWith(
        status: StatsStateStatus.pointsForDriverLoading,
      ));
      final playersPointsForDriver$ = _createPointsForDriverStats(
        season: _getCurrentSeason(),
        seasonDriverId: seasonDriverId,
      );
      await for (final playersPointsForDriver in playersPointsForDriver$) {
        emit(state.copyWith(
          status: StatsStateStatus.completed,
          stats: stats.copyWithPlayersPointsForDriver(
            playersPointsForDriver,
          ),
        ));
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
    if (params.noData) {
      emit(state.copyWith(
        status: StatsStateStatus.noData,
      ));
    } else {
      switch (params) {
        case _ListenedGroupedStatsParams():
          _manageListenedGroupedStatsParams(params);
        case _ListenedIndividualStatsParams():
          _manageListenedIndividualStatsParams(params);
      }
    }
  }

  Stream<_ListenedStatsParams> _getListenedGroupedStatsParams(
    StatsType statsType,
  ) {
    final currentSeason = _getCurrentSeason();
    return Rx.combineLatest4(
      _createPlayersPodiumStats(season: currentSeason),
      _createBestPoints(
        statsType: statsType,
        season: currentSeason,
      ),
      _createPointsHistoryStats(
        statsType: statsType,
        season: currentSeason,
      ),
      _getDetailsOfAllDriversFromSeasonUseCase(currentSeason),
      (
        PlayersPodium? playersPodium,
        BestPoints? bestPoints,
        PointsHistory? pointsHistory,
        List<DriverDetails> detailsOfDriversFromSeason,
      ) =>
          _ListenedGroupedStatsParams(
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
    final currentSeason = _getCurrentSeason();
    return Rx.combineLatest3(
      _createBestPoints(
        statsType: statsType,
        season: currentSeason,
      ),
      _createPointsHistoryStats(
        statsType: statsType,
        season: currentSeason,
      ),
      _createLoggedUserPointsForDriversStats(season: currentSeason),
      (
        BestPoints? bestPoints,
        PointsHistory? pointsHistory,
        List<PointsForDriver>? pointsForDrivers,
      ) =>
          _ListenedIndividualStatsParams(
        bestPoints: bestPoints,
        pointsHistory: pointsHistory,
        pointsForDrivers: pointsForDrivers,
      ),
    );
  }

  void _manageListenedGroupedStatsParams(
    _ListenedGroupedStatsParams params,
  ) {
    final sortedDetailsOfDriversFromSeason = [
      ...params.detailsOfDriversFromSeason,
    ]..sortByTeamAndSurname();
    emit(state.copyWith(
      status: StatsStateStatus.completed,
      stats: GroupedStats(
        playersPodium: params.playersPodium,
        bestPoints: params.bestPoints,
        pointsHistory: params.pointsHistory,
        detailsOfDriversFromSeason: sortedDetailsOfDriversFromSeason,
        playersPointsForDriver: [],
      ),
    ));
  }

  void _manageListenedIndividualStatsParams(
    _ListenedIndividualStatsParams params,
  ) {
    emit(state.copyWith(
      status: StatsStateStatus.completed,
      stats: IndividualStats(
        bestPoints: params.bestPoints,
        pointsHistory: params.pointsHistory,
        pointsForDrivers: params.pointsForDrivers,
      ),
    ));
  }

  int _getCurrentSeason() {
    return _dateService.getNow().year;
  }
}

sealed class _ListenedStatsParams extends Equatable {
  const _ListenedStatsParams();

  bool get noData;
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

  @override
  bool get noData =>
      playersPodium == null &&
      bestPoints == null &&
      pointsHistory == null &&
      detailsOfDriversFromSeason.isEmpty;
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
  List<Object?> get props => [
        bestPoints,
        pointsHistory,
        pointsForDrivers,
      ];

  @override
  bool get noData =>
      bestPoints == null &&
      pointsHistory == null &&
      (pointsForDrivers == null || pointsForDrivers!.isEmpty);
}
