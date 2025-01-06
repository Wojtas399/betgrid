import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_stats_points_for_gp_dto.freezed.dart';
part 'player_stats_points_for_gp_dto.g.dart';

@freezed
class PlayerStatsPointsForGpDto with _$PlayerStatsPointsForGpDto {
  const factory PlayerStatsPointsForGpDto({
    required String seasonGrandPrixId,
    required double points,
  }) = _PlayerStatsPointsForGpDto;

  factory PlayerStatsPointsForGpDto.fromJson(Map<String, Object?> json) =>
      _$PlayerStatsPointsForGpDtoFromJson(json);
}
