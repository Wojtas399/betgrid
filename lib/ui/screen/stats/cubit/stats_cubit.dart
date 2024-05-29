import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/repository/driver/driver_repository.dart';
import '../../../../model/driver.dart';
import '../stats_maker/players_podium_maker.dart';
import '../stats_maker/points_for_driver_maker.dart';
import '../stats_maker/points_history_maker.dart';
import '../stats_model/players_podium.dart';
import '../stats_model/points_history.dart';
import 'stats_state.dart';

@injectable
class StatsCubit extends Cubit<StatsState> {
  final DriverRepository _driverRepository;
  final PlayersPodiumMaker _playersPodiumMaker;
  final PointsHistoryMaker _pointsHistoryMaker;
  final PointsForDriverMaker _pointsForDriverMaker;

  StatsCubit(
    this._driverRepository,
    this._playersPodiumMaker,
    this._pointsHistoryMaker,
    this._pointsForDriverMaker,
  ) : super(const StatsState());

  Future<void> initialize() async {
    final listenedParams$ = Rx.combineLatest3(
      _playersPodiumMaker(),
      _pointsHistoryMaker(),
      _driverRepository.getAllDrivers(),
      (playersPodium, pointsHistory, allDrivers) => _ListenedParams(
        playersPodium: playersPodium,
        pointsHistory: pointsHistory,
        allDrivers: allDrivers,
      ),
    );
    await for (final params in listenedParams$) {
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

  Future<void> onDriverChanged(String driverId) async {
    emit(state.copyWith(
      status: StatsStateStatus.pointsForDriverLoading,
    ));
    final pointsByDriverData$ = _pointsForDriverMaker(driverId: driverId);
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
}
