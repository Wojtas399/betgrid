import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_stats_points_for_gp_dto.freezed.dart';
part 'user_stats_points_for_gp_dto.g.dart';

@freezed
class UserStatsPointsForGpDto with _$UserStatsPointsForGpDto {
  const factory UserStatsPointsForGpDto({
    required String seasonGrandPrixId,
    required double points,
  }) = _UserStatsPointsForGpDto;

  factory UserStatsPointsForGpDto.fromJson(Map<String, Object?> json) =>
      _$UserStatsPointsForGpDtoFromJson(json);
}
