import 'package:freezed_annotation/freezed_annotation.dart';

part 'race_bet_points_dto.freezed.dart';
part 'race_bet_points_dto.g.dart';

@freezed
class RaceBetPointsDto with _$RaceBetPointsDto {
  const factory RaceBetPointsDto({
    required double totalPoints,
    required double p1Points,
    required double p2Points,
    required double p3Points,
    required double p10Points,
    required double fastestLapPoints,
    required double podiumAndP10Points,
    double? podiumAndP10Multiplier,
    required double dnfPoints,
    required double dnfDriver1Points,
    required double dnfDriver2Points,
    required double dnfDriver3Points,
    double? dnfMultiplier,
    required double safetyCarPoints,
    required double redFlagPoints,
    required double safetyCarAndRedFlagPoints,
  }) = _RaceBetPointsDto;

  factory RaceBetPointsDto.fromJson(Map<String, Object?> json) =>
      _$RaceBetPointsDtoFromJson(json);
}
