import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/repository/auth/auth_repository.dart';
import '../../../../data/repository/player/player_repository.dart';
import '../../../../model/player.dart';
import '../../../../use_case/get_player_points_use_case.dart';
import '../../../service/date_service.dart';
import 'players_state.dart';

@injectable
class PlayersCubit extends Cubit<PlayersState> {
  final AuthRepository _authRepository;
  final PlayerRepository _playerRepository;
  final GetPlayerPointsUseCase _getPlayerPointsUseCase;
  final DateService _dateService;

  PlayersCubit(
    this._authRepository,
    this._playerRepository,
    this._getPlayerPointsUseCase,
    this._dateService,
  ) : super(const PlayersState());

  Future<void> initialize() async {
    final Stream<String?> loggedUserId$ = _authRepository.loggedUserId$;
    await for (final loggedUserId in loggedUserId$) {
      if (loggedUserId != null) {
        await _initializePlayersWithTheirPoints(loggedUserId);
      }
    }
  }

  Future<void> _initializePlayersWithTheirPoints(String loggedUserId) async {
    final Stream<List<PlayerWithPoints>?> playersWithTheirPoints$ =
        _getPlayersWithTheirPoints(loggedUserId);
    await for (final playersWithTheirPoints in playersWithTheirPoints$) {
      emit(state.copyWith(
        status: PlayersStateStatus.completed,
        playersWithTheirPoints: playersWithTheirPoints,
      ));
    }
  }

  Stream<List<PlayerWithPoints>?> _getPlayersWithTheirPoints(
    String loggedUserId,
  ) =>
      _playerRepository
          .getAllPlayers()
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

  Iterable<Player>? _getOnlyOtherPlayers(
    List<Player>? allPlayers,
    String loggedUserId,
  ) =>
      allPlayers?.where((Player player) => player.id != loggedUserId);

  Stream<PlayerWithPoints> _getPointsForPlayer(Player player) async* {
    final int currentYear = _dateService.getNow().year;
    final Stream<double?> points$ = _getPlayerPointsUseCase(
      playerId: player.id,
      season: currentYear,
    );
    await for (final points in points$) {
      if (points != null) {
        yield PlayerWithPoints(
          player: player,
          totalPoints: points,
        );
      }
    }
  }
}
