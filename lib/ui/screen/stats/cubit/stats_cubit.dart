import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/repository/driver/driver_repository.dart';
import '../../../../data/repository/grand_prix/grand_prix_repository.dart';
import '../../../../data/repository/grand_prix_bet/grand_prix_bet_repository.dart';
import '../../../../data/repository/grand_prix_bet_points/grand_prix_bet_points_repository.dart';
import '../../../../data/repository/grand_prix_result/grand_prix_results_repository.dart';
import '../../../../data/repository/player/player_repository.dart';
import '../../../../model/driver.dart';
import '../../../../model/grand_prix.dart';
import '../../../../model/grand_prix_results.dart';
import '../../../../model/player.dart';
import '../../../service/date_service.dart';
import '../stats_maker/players_podium_maker.dart';
import '../stats_maker/points_for_driver_maker.dart';
import '../stats_maker/points_history_maker.dart';
import '../stats_model/players_podium.dart';
import '../stats_model/points_by_driver.dart';
import '../stats_model/points_history.dart';
import 'stats_state.dart';

@injectable
class StatsCubit extends Cubit<StatsState> {
  final PlayerRepository _playerRepository;
  final GrandPrixRepository _grandPrixRepository;
  final GrandPrixBetRepository _grandPrixBetRepository;
  final GrandPrixResultsRepository _grandPrixResultsRepository;
  final GrandPrixBetPointsRepository _grandPrixBetPointsRepository;
  final DriverRepository _driverRepository;
  final DateService _dateService;
  final PlayersPodiumMaker _playersPodiumMaker;
  final PointsHistoryMaker _pointsHistoryMaker;
  final PointsForDriverMaker _pointsForDriverMaker;

  StatsCubit(
    this._playerRepository,
    this._grandPrixRepository,
    this._grandPrixBetRepository,
    this._grandPrixResultsRepository,
    this._grandPrixBetPointsRepository,
    this._dateService,
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
    final Stream<List<Player>?> allPlayers$ = _playerRepository.getAllPlayers();
    await for (final allPlayers in allPlayers$) {
      if (allPlayers == null || allPlayers.isEmpty) {
        emit(state.copyWith(
          status: StatsStateStatus.playersDontExist,
        ));
      } else {
        await _initializePointsByDriverStats(driverId, allPlayers);
      }
    }
  }

  Future<void> _initializePointsByDriverStats(
    String driverId,
    List<Player> players,
  ) async {
    final pointsByDriverData$ = _createPointsByDriverData(driverId, players);
    await for (final pointsByDriverData in pointsByDriverData$) {
      emit(state.copyWith(
        status: StatsStateStatus.completed,
        pointsByDriver: pointsByDriverData,
      ));
    }
  }

  int _sortDriversByTeam(Driver d1, Driver d2) =>
      d1.team.toString().compareTo(d2.team.toString());

  Stream<List<PointsByDriverPlayerPoints>?> _createPointsByDriverData(
    String driverId,
    List<Player> players,
  ) =>
      _getFinishedGrandPrixes()
          .map((finishedGps) => finishedGps.map((gp) => gp.id).toList())
          .switchMap(
            (finishedGpsIds) => _grandPrixResultsRepository
                .getGrandPrixResultsForGrandPrixes(
                  idsOfGrandPrixes: finishedGpsIds,
                )
                .switchMap(
                  (gpsResults) => _calculatePlayersPointsForDriver(
                    driverId,
                    players,
                    finishedGpsIds,
                    gpsResults,
                  ),
                ),
          );

  Stream<Iterable<GrandPrix>> _getFinishedGrandPrixes() =>
      _grandPrixRepository.getAllGrandPrixes().map(
        (List<GrandPrix>? allGrandPrixes) {
          if (allGrandPrixes == null) return [];
          final now = _dateService.getNow();
          return allGrandPrixes.where((gp) => gp.startDate.isBefore(now));
        },
      );

  Stream<List<PointsByDriverPlayerPoints>?> _calculatePlayersPointsForDriver(
    String driverId,
    List<Player> players,
    List<String> grandPrixesIds,
    List<GrandPrixResults?> grandPrixesResults,
  ) {
    final playersIds = players.map((Player player) => player.id).toList();
    return Rx.combineLatest2(
      _grandPrixBetPointsRepository
          .getGrandPrixBetPointsForPlayersAndGrandPrixes(
        idsOfPlayers: playersIds,
        idsOfGrandPrixes: grandPrixesIds,
      ),
      _grandPrixBetRepository.getGrandPrixBetsForPlayersAndGrandPrixes(
        idsOfPlayers: playersIds,
        idsOfGrandPrixes: grandPrixesIds,
      ),
      (gpsBetPoints, gpsBets) => _pointsForDriverMaker.prepareStats(
        driverId: driverId,
        players: players,
        grandPrixesIds: grandPrixesIds,
        grandPrixesResults: grandPrixesResults,
        grandPrixesBetPoints: gpsBetPoints,
        grandPrixesBets: gpsBets,
      ),
    );
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
}
