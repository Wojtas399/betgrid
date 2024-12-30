import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../model/driver_details.dart';
import '../../../../use_case/get_details_of_all_drivers_from_season_use_case.dart';
import '../../../extensions/list_of_driver_details_extensions.dart';
import '../stats_creator/create_players_podium_stats.dart';
import '../stats_creator/create_points_for_driver_stats.dart';
import '../stats_creator/create_points_history_stats.dart';
import '../stats_model/players_podium.dart';
import '../stats_model/points_history.dart';
import 'stats_state.dart';

@injectable
class StatsCubit extends Cubit<StatsState> {
  final GetDetailsOfAllDriversFromSeasonUseCase
      _getDetailsOfAllDriversFromSeasonUseCase;
  final CreatePlayersPodiumStats _createPlayersPodiumStats;
  final CreatePointsHistoryStats _createPointsHistoryStats;
  final CreatePointsForDriverStats _createPointsForDriverStats;
  StreamSubscription<_ListenedParams>? _listener;

  StatsCubit(
    this._getDetailsOfAllDriversFromSeasonUseCase,
    this._createPlayersPodiumStats,
    this._createPointsHistoryStats,
    this._createPointsForDriverStats,
  ) : super(const StatsState());

  @override
  Future<void> close() {
    _listener?.cancel();
    return super.close();
  }

  void initialize() {
    _listener ??= _getListenedParams().listen(_manageListenedParams);
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

  Stream<_ListenedParams> _getListenedParams() {
    return Rx.combineLatest3(
      _createPlayersPodiumStats(),
      _createPointsHistoryStats(),
      _getDetailsOfAllDriversFromSeasonUseCase(2024),
      (
        PlayersPodium? playersPodium,
        PointsHistory? pointsHistory,
        List<DriverDetails> detailsOfDriversFromSeason,
      ) =>
          _ListenedParams(
        playersPodium: playersPodium,
        pointsHistory: pointsHistory,
        detailsOfDriversFromSeason: detailsOfDriversFromSeason,
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
      ));
    }
  }
}

class _ListenedParams extends Equatable {
  final PlayersPodium? playersPodium;
  final PointsHistory? pointsHistory;
  final Iterable<DriverDetails> detailsOfDriversFromSeason;

  const _ListenedParams({
    required this.playersPodium,
    required this.pointsHistory,
    required this.detailsOfDriversFromSeason,
  });

  @override
  List<Object?> get props => [
        playersPodium,
        pointsHistory,
        detailsOfDriversFromSeason,
      ];

  bool get noData =>
      playersPodium == null &&
      pointsHistory == null &&
      detailsOfDriversFromSeason.isEmpty;
}
