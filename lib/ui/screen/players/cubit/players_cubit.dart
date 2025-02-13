import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/repository/auth/auth_repository.dart';
import '../../../../data/repository/player/player_repository.dart';
import '../../../../model/player.dart';
import '../../../../use_case/get_player_points_use_case.dart';
import '../../../common_cubit/season_cubit.dart';
import 'players_state.dart';

@injectable
class PlayersCubit extends Cubit<PlayersState> {
  final AuthRepository _authRepository;
  final PlayerRepository _playerRepository;
  final GetPlayerPointsUseCase _getPlayerPointsUseCase;
  final SeasonCubit _seasonCubit;
  StreamSubscription<List<PlayerWithPoints>?>? _playersWithPointsListener;

  PlayersCubit(
    this._authRepository,
    this._playerRepository,
    this._getPlayerPointsUseCase,
    @factoryParam this._seasonCubit,
  ) : super(const PlayersState());

  @override
  Future<void> close() {
    _playersWithPointsListener?.cancel();
    return super.close();
  }

  void initialize() {
    _playersWithPointsListener ??= _authRepository.loggedUserId$
        .whereNotNull()
        .switchMap(_getPlayersWithTheirPoints)
        .listen(
      (List<PlayerWithPoints>? playersWithPoints) {
        emit(state.copyWith(
          status: PlayersStateStatus.completed,
          playersWithTheirPoints: playersWithPoints,
        ));
      },
    );
  }

  Stream<List<PlayerWithPoints>?> _getPlayersWithTheirPoints(
    String loggedUserId,
  ) {
    return _playerRepository
        .getAll()
        .map(
          (List<Player>? allPlayers) =>
              _getOnlyOtherPlayers(allPlayers, loggedUserId),
        )
        .map(
          (Iterable<Player>? otherPlayers) =>
              otherPlayers?.map(_getPointsForPlayer),
        )
        .switchMap(
          (Iterable<Stream<PlayerWithPoints>>? streams) =>
              streams?.isNotEmpty == true
                  ? Rx.combineLatest(
                      streams!,
                      (List<PlayerWithPoints> values) => values,
                    )
                  : Stream.value(null),
        );
  }

  Iterable<Player>? _getOnlyOtherPlayers(
    List<Player>? allPlayers,
    String loggedUserId,
  ) {
    return allPlayers?.where((Player player) => player.id != loggedUserId);
  }

  Stream<PlayerWithPoints> _getPointsForPlayer(Player player) {
    return _getPlayerPointsUseCase(
      playerId: player.id,
      season: _seasonCubit.state,
    ).whereNotNull().map(
          (double totalPoints) => PlayerWithPoints(
            player: player,
            totalPoints: totalPoints,
          ),
        );
  }
}
