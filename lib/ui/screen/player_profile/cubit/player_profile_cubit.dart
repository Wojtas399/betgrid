import 'package:equatable/equatable.dart';
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

  PlayerProfileCubit(
    this._playerRepository,
    this._getPlayerPointsUseCase,
    this._getGrandPrixesWithPointsUseCase,
    this._dateService,
  ) : super(const PlayerProfileState());

  Future<void> initialize({
    required String playerId,
  }) async {
    final Stream<_ListenedParams> listenedParams$ =
        _getListenedParams(playerId);
    await for (final listenedParams in listenedParams$) {
      emit(state.copyWith(
        status: PlayerProfileStateStatus.completed,
        player: listenedParams.player,
        totalPoints: listenedParams.totalPoints,
        grandPrixesWithPoints: listenedParams.grandPrixWithPoints,
      ));
    }
  }

  Stream<_ListenedParams> _getListenedParams(String playerId) {
    final int currentYear = _dateService.getNow().year;
    return Rx.combineLatest3(
      _playerRepository.getPlayerById(playerId: playerId),
      _getPlayerPointsUseCase(
        playerId: playerId,
        season: currentYear,
      ),
      _getGrandPrixesWithPointsUseCase(
        playerId: playerId,
        season: currentYear,
      ),
      (
        Player? player,
        double? totalPoints,
        List<GrandPrixWithPoints> grandPrixesWithPoints,
      ) =>
          _ListenedParams(
        player: player,
        totalPoints: totalPoints,
        grandPrixWithPoints: grandPrixesWithPoints,
      ),
    );
  }
}

class _ListenedParams extends Equatable {
  final Player? player;
  final double? totalPoints;
  final List<GrandPrixWithPoints> grandPrixWithPoints;

  const _ListenedParams({
    this.player,
    this.totalPoints,
    this.grandPrixWithPoints = const [],
  });

  @override
  List<Object?> get props => [player, totalPoints, grandPrixWithPoints];
}
