import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/repository/auth/auth_repository.dart';
import '../../../../data/repository/driver/driver_repository.dart';
import '../../../../data/repository/grand_prix/grand_prix_repository.dart';
import '../../../../data/repository/grand_prix_bet/grand_prix_bet_repository.dart';
import '../../../../data/repository/grand_prix_bet_points/grand_prix_bet_points_repository.dart';
import '../../../../data/repository/grand_prix_result/grand_prix_results_repository.dart';
import '../../../../data/repository/player/player_repository.dart';
import '../../../../model/driver.dart';
import '../../../../model/grand_prix.dart';
import '../../../../model/grand_prix_bet.dart';
import '../../../../model/grand_prix_bet_points.dart';
import '../../../../model/grand_prix_results.dart';
import '../../../../model/player.dart';
import 'grand_prix_bet_state.dart';

@injectable
class GrandPrixBetCubit extends Cubit<GrandPrixBetState> {
  final AuthRepository _authRepository;
  final GrandPrixRepository _grandPrixRepository;
  final PlayerRepository _playerRepository;
  final GrandPrixBetRepository _grandPrixBetRepository;
  final GrandPrixResultsRepository _grandPrixResultsRepository;
  final GrandPrixBetPointsRepository _grandPrixBetPointsRepository;
  final DriverRepository _driverRepository;

  GrandPrixBetCubit(
    this._authRepository,
    this._grandPrixRepository,
    this._playerRepository,
    this._grandPrixBetRepository,
    this._grandPrixResultsRepository,
    this._grandPrixBetPointsRepository,
    this._driverRepository,
  ) : super(const GrandPrixBetState());

  Future<void> initialize({
    required String playerId,
    required String grandPrixId,
  }) async {
    final Stream<_ListenedParams> listenedParams$ =
        _getListenedParams(playerId, grandPrixId);
    await for (final listenedParams in listenedParams$) {
      emit(state.copyWith(
        status: GrandPrixBetStateStatus.completed,
        playerUsername: listenedParams.playerUsername,
        grandPrixName: listenedParams.grandPrixName,
        isPlayerIdSameAsLoggedUserId: listenedParams.loggedUserId == playerId,
        grandPrixBet: listenedParams.grandPrixBet,
        grandPrixResults: listenedParams.grandPrixResults,
        grandPrixBetPoints: listenedParams.grandPrixBetPoints,
        allDrivers: listenedParams.allDrivers,
      ));
    }
  }

  Stream<_ListenedParams> _getListenedParams(
    String playerId,
    String grandPrixId,
  ) =>
      Rx.combineLatest7(
        _authRepository.loggedUserId$,
        _getPlayerUsername(playerId),
        _getGrandPrixName(grandPrixId),
        _grandPrixBetRepository.getBetByGrandPrixIdAndPlayerId(
          playerId: playerId,
          grandPrixId: grandPrixId,
        ),
        _grandPrixResultsRepository.getResultForGrandPrix(
          grandPrixId: grandPrixId,
        ),
        _grandPrixBetPointsRepository.getPointsForPlayerByGrandPrixId(
          playerId: playerId,
          grandPrixId: grandPrixId,
        ),
        _driverRepository.getAllDrivers(),
        (
          String? loggedUserId,
          String? playerUsername,
          String? grandPrixName,
          GrandPrixBet? grandPrixBet,
          GrandPrixResults? grandPrixResults,
          GrandPrixBetPoints? grandPrixBetPoints,
          List<Driver> allDrivers,
        ) =>
            _ListenedParams(
          loggedUserId: loggedUserId,
          playerUsername: playerUsername,
          grandPrixName: grandPrixName,
          grandPrixBet: grandPrixBet,
          grandPrixResults: grandPrixResults,
          grandPrixBetPoints: grandPrixBetPoints,
          allDrivers: allDrivers,
        ),
      );

  Stream<String?> _getPlayerUsername(String playerId) => _playerRepository
      .getPlayerById(playerId: playerId)
      .map((Player? player) => player?.username);

  Stream<String?> _getGrandPrixName(String grandPrixId) => _grandPrixRepository
      .getGrandPrixById(grandPrixId: grandPrixId)
      .map((GrandPrix? grandPrix) => grandPrix?.name);
}

class _ListenedParams extends Equatable {
  final String? loggedUserId;
  final String? playerUsername;
  final String? grandPrixName;
  final GrandPrixBet? grandPrixBet;
  final GrandPrixResults? grandPrixResults;
  final GrandPrixBetPoints? grandPrixBetPoints;
  final List<Driver> allDrivers;

  const _ListenedParams({
    this.loggedUserId,
    this.playerUsername,
    this.grandPrixName,
    this.grandPrixBet,
    this.grandPrixResults,
    this.grandPrixBetPoints,
    this.allDrivers = const [],
  });

  @override
  List<Object?> get props => [
        loggedUserId,
        playerUsername,
        grandPrixName,
        grandPrixBet,
        grandPrixResults,
        grandPrixBetPoints,
        allDrivers,
      ];
}
