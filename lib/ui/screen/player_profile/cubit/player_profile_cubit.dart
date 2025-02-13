import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/repository/player/player_repository.dart';
import '../../../../model/player.dart';
import '../../../../use_case/get_grand_prixes_with_points_use_case.dart';
import '../../../../use_case/get_player_points_use_case.dart';
import '../../../common_cubit/season_cubit.dart';
import 'player_profile_state.dart';

@injectable
class PlayerProfileCubit extends Cubit<PlayerProfileState> {
  final PlayerRepository _playerRepository;
  final GetPlayerPointsUseCase _getPlayerPointsUseCase;
  final GetGrandPrixesWithPointsUseCase _getGrandPrixesWithPointsUseCase;
  final SeasonCubit _seasonCubit;
  final String _playerId;
  StreamSubscription<_ListenedParams>? _listener;

  PlayerProfileCubit(
    this._playerRepository,
    this._getPlayerPointsUseCase,
    this._getGrandPrixesWithPointsUseCase,
    @factoryParam this._seasonCubit,
    @factoryParam this._playerId,
  ) : super(const PlayerProfileState());

  @override
  Future<void> close() {
    _listener?.cancel();
    return super.close();
  }

  void initialize() {
    _listener ??= _getListenedParams().listen(
      (_ListenedParams listenedParams) {
        emit(state.copyWith(
          status: PlayerProfileStateStatus.completed,
          player: listenedParams.player,
          season: _seasonCubit.state,
          totalPoints: listenedParams.totalPoints,
          grandPrixesWithPoints: listenedParams.grandPrixesWithPoints,
        ));
      },
    );
  }

  Stream<_ListenedParams> _getListenedParams() {
    return Rx.combineLatest3(
      _playerRepository.getById(_playerId),
      _getPlayerPointsUseCase(
        playerId: _playerId,
        season: _seasonCubit.state,
      ),
      _getGrandPrixesWithPointsUseCase(
        playerId: _playerId,
        season: _seasonCubit.state,
      ),
      (
        Player? player,
        double? totalPoints,
        List<GrandPrixWithPoints> grandPrixesWithPoints,
      ) =>
          (
        player: player,
        totalPoints: totalPoints,
        grandPrixesWithPoints: grandPrixesWithPoints,
      ),
    );
  }
}

typedef _ListenedParams = ({
  Player? player,
  double? totalPoints,
  List<GrandPrixWithPoints> grandPrixesWithPoints,
});
