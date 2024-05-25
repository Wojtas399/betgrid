import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../model/player.dart';

part 'players_state.freezed.dart';

enum PlayersStateStatus {
  loading,
  completed,
  loggedUserDoesNotExist,
}

@freezed
class PlayersState with _$PlayersState {
  const PlayersState._();

  const factory PlayersState({
    @Default(PlayersStateStatus.loading) PlayersStateStatus status,
    List<PlayerWithPoints>? playersWithTheirPoints,
  }) = _PlayersState;

  bool get isLoading => status == PlayersStateStatus.loading;
}

class PlayerWithPoints extends Equatable {
  final Player player;
  final double totalPoints;

  const PlayerWithPoints({
    required this.player,
    required this.totalPoints,
  });

  @override
  List<Object?> get props => [
        player,
        totalPoints,
      ];
}
