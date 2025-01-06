import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_stats_points_for_driver_dto.freezed.dart';
part 'player_stats_points_for_driver_dto.g.dart';

@freezed
class PlayerStatsPointsForDriverDto with _$PlayerStatsPointsForDriverDto {
  const factory PlayerStatsPointsForDriverDto({
    required String seasonDriverId,
    required double points,
  }) = _PlayerStatsPointsForDriverDto;

  factory PlayerStatsPointsForDriverDto.fromJson(Map<String, Object?> json) =>
      _$PlayerStatsPointsForDriverDtoFromJson(json);
}
