import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/repository/player/player_repository.dart';
import '../../../../model/player.dart';
import '../../../../use_case/get_grand_prixes_with_points_use_case.dart';
import '../../../../use_case/get_player_points_use_case.dart';
import '../../../service/date_service.dart';
import 'player_profile_state.dart';

@injectable
class PlayerProfileCubit extends Cubit<PlayerProfileState> {
  final PlayerRepository _playerRepository;
  final GetPlayerPointsUseCase _getPlayerPointsUseCase;
  final GetGrandPrixesWithPointsUseCase _getGrandPrixesWithPointsUseCase;
  final DateService _dateService;
  final String _playerId;
  StreamSubscription<_ListenedParams>? _listener;

  PlayerProfileCubit(
    this._playerRepository,
    this._getPlayerPointsUseCase,
    this._getGrandPrixesWithPointsUseCase,
    this._dateService,
    @factoryParam this._playerId,
  ) : super(const PlayerProfileState());

  @override
  Future<void> close() {
    _listener?.cancel();
    return super.close();
  }

  void initialize() {
    final int currentYear = _dateService.getNow().year;
    _listener ??= _getListenedParams(currentYear).listen(
      (_ListenedParams listenedParams) {
        emit(state.copyWith(
          status: PlayerProfileStateStatus.completed,
          player: listenedParams.player,
          season: currentYear,
          totalPoints: listenedParams.totalPoints,
          grandPrixesWithPoints: listenedParams.grandPrixesWithPoints,
        ));
      },
    );
  }

  Stream<_ListenedParams> _getListenedParams(int season) {
    return Rx.combineLatest3(
      _playerRepository.getById(_playerId),
      _getPlayerPointsUseCase(
        playerId: _playerId,
        season: season,
      ),
      _getGrandPrixesWithPointsUseCase(
        playerId: _playerId,
        season: season,
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
