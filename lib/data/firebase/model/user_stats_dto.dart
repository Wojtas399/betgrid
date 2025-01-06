import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_stats_points_for_driver_dto.dart';
import 'user_stats_points_for_gp_dto.dart';

part 'user_stats_dto.freezed.dart';
part 'user_stats_dto.g.dart';

@freezed
class UserStatsDto with _$UserStatsDto {
  const UserStatsDto._();

  const factory UserStatsDto({
    required String userId,
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(0)
    int season,
    required UserStatsPointsForGpDto bestGpPoints,
    required UserStatsPointsForGpDto bestQualiPoints,
    required UserStatsPointsForGpDto bestRacePoints,
    required List<UserStatsPointsForDriverDto> pointsForDrivers,
  }) = _UserStatsDto;

  factory UserStatsDto.fromJson(Map<String, Object?> json) =>
      _$UserStatsDtoFromJson(json);

  factory UserStatsDto.fromFirebase({
    required String userId,
    required int season,
    required Map<String, Object?> json,
  }) =>
      UserStatsDto.fromJson(json).copyWith(
        userId: userId,
        season: season,
      );

  String get id => '$userId-$season';
}
