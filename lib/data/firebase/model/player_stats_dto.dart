import 'package:freezed_annotation/freezed_annotation.dart';

import 'player_stats_points_for_driver_dto.dart';
import 'player_stats_points_for_gp_dto.dart';

part 'player_stats_dto.freezed.dart';
part 'player_stats_dto.g.dart';

@freezed
class PlayerStatsDto with _$PlayerStatsDto {
  const PlayerStatsDto._();

  const factory PlayerStatsDto({
    required String playerId,
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(0)
    int season,
    required PlayerStatsPointsForGpDto bestGpPoints,
    required PlayerStatsPointsForGpDto bestQualiPoints,
    required PlayerStatsPointsForGpDto bestRacePoints,
    required List<PlayerStatsPointsForDriverDto> pointsForDrivers,
  }) = _PlayerStatsDto;

  factory PlayerStatsDto.fromJson(Map<String, Object?> json) =>
      _$PlayerStatsDtoFromJson(json);

  factory PlayerStatsDto.fromFirebase({
    required String playerId,
    required int season,
    required Map<String, Object?> json,
  }) =>
      PlayerStatsDto.fromJson(json).copyWith(
        playerId: playerId,
        season: season,
      );

  String get id => '$playerId-$season';
}
