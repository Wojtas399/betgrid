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
import '../stats_creator/create_players_podium_stats.dart';
import '../stats_creator/create_points_for_driver_stats.dart';
import '../stats_creator/create_points_history_stats.dart';
import '../stats_model/best_points.dart';
import '../stats_model/players_podium.dart';
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
  StreamSubscription<_ListenedParams>? _listener;

  StatsCubit(
    this._dateService,
    this._getDetailsOfAllDriversFromSeasonUseCase,
    this._createPlayersPodiumStats,
    this._createPointsHistoryStats,
    this._createPointsForDriverStats,
    this._createBestPoints,
  ) : super(const StatsState());

  @override
  Future<void> close() {
    _listener?.cancel();
    return super.close();
  }

  void initialize() {
    _listener ??= _getListenedParams(state.type).listen(_manageListenedParams);
  }

  void onStatsTypeChanged(StatsType type) {
    emit(state.copyWith(
      type: type,
      status: StatsStateStatus.changingStatsType,
    ));
    _listener?.cancel();
    _listener = _getListenedParams(type).listen(_manageListenedParams);
  }

  Future<void> onDriverChanged(String seasonDriverId) async {
    emit(state.copyWith(
      status: StatsStateStatus.pointsForDriverLoading,
    ));
    final pointsByDriverData$ = _createPointsForDriverStats(
      seasonDriverId: seasonDriverId,
    );
    await for (final pointsByDriverData in pointsByDriverData$) {
      emit(state.copyWith(
        status: StatsStateStatus.completed,
        pointsByDriver: pointsByDriverData,
      ));
    }
  }

  Stream<_ListenedParams> _getListenedParams(StatsType statsType) {
    final currentSeason = _dateService.getNow().year;
    return Rx.combineLatest4(
      _createPlayersPodiumStats(season: currentSeason),
      _createPointsHistoryStats(
        statsType: statsType,
        season: currentSeason,
      ),
      _getDetailsOfAllDriversFromSeasonUseCase(currentSeason),
      _createBestPoints(
        statsType: statsType,
        season: currentSeason,
      ),
      (
        PlayersPodium? playersPodium,
        PointsHistory? pointsHistory,
        List<DriverDetails> detailsOfDriversFromSeason,
        BestPoints? bestPoints,
      ) =>
          _ListenedParams(
        playersPodium: playersPodium,
        pointsHistory: pointsHistory,
        detailsOfDriversFromSeason: detailsOfDriversFromSeason,
        bestPoints: bestPoints,
      ),
    );
  }

  void _manageListenedParams(_ListenedParams params) {
    if (params.noData) {
      emit(state.copyWith(
        status: StatsStateStatus.noData,
      ));
    } else {
      final sortedDetailsOfDriversFromSeason = [
        ...params.detailsOfDriversFromSeason,
      ];
      sortedDetailsOfDriversFromSeason.sortByTeamAndSurname();
      emit(state.copyWith(
        status: StatsStateStatus.completed,
        playersPodium: params.playersPodium,
        pointsHistory: params.pointsHistory,
        pointsByDriver: [],
        detailsOfDriversFromSeason: sortedDetailsOfDriversFromSeason,
        bestPoints: params.bestPoints,
      ));
    }
  }
}

class _ListenedParams extends Equatable {
  final PlayersPodium? playersPodium;
  final PointsHistory? pointsHistory;
  final Iterable<DriverDetails> detailsOfDriversFromSeason;
  final BestPoints? bestPoints;

  const _ListenedParams({
    required this.playersPodium,
    required this.pointsHistory,
    required this.detailsOfDriversFromSeason,
    required this.bestPoints,
  });

  @override
  List<Object?> get props => [
        playersPodium,
        pointsHistory,
        detailsOfDriversFromSeason,
        bestPoints,
      ];

  bool get noData =>
      playersPodium == null &&
      pointsHistory == null &&
      detailsOfDriversFromSeason.isEmpty &&
      bestPoints == null;
}
