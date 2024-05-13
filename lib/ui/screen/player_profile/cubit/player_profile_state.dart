import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../model/player.dart';
import '../../../../use_case/get_grand_prixes_with_points_use_case.dart';

part 'player_profile_state.freezed.dart';

enum PlayerProfileStateStatus {
  loading,
  completed,
}

@freezed
class PlayerProfileState with _$PlayerProfileState {
  const PlayerProfileState._();

  const factory PlayerProfileState({
    @Default(PlayerProfileStateStatus.loading) PlayerProfileStateStatus status,
    Player? player,
    double? totalPoints,
    @Default([]) List<GrandPrixWithPoints> grandPrixesWithPoints,
  }) = _PlayerProfileState;

  bool get isLoading => status == PlayerProfileStateStatus.loading;
}
