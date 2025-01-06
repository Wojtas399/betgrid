import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_stats_points_for_driver_dto.freezed.dart';
part 'user_stats_points_for_driver_dto.g.dart';

@freezed
class UserStatsPointsForDriverDto with _$UserStatsPointsForDriverDto {
  const factory UserStatsPointsForDriverDto({
    required String seasonDriverId,
    required double points,
  }) = _UserStatsPointsForDriverDto;

  factory UserStatsPointsForDriverDto.fromJson(Map<String, Object?> json) =>
      _$UserStatsPointsForDriverDtoFromJson(json);
}
