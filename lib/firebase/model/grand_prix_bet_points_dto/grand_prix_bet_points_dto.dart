import 'package:freezed_annotation/freezed_annotation.dart';

part 'grand_prix_bet_points_dto.freezed.dart';
part 'grand_prix_bet_points_dto.g.dart';

@freezed
class GrandPrixBetPointsDto with _$GrandPrixBetPointsDto {
  const factory GrandPrixBetPointsDto({
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String playerId,
    required String grandPrixId,
    required double totalPoints,
    @JsonKey(name: 'qualiBetPoints') QualiBetPointsDto? qualiBetPointsDto,
    @JsonKey(name: 'raceBetPoints') RaceBetPointsDto? raceBetPointsDto,
  }) = _GrandPrixBetPointsDto;

  factory GrandPrixBetPointsDto.fromJson(Map<String, Object?> json) =>
      _$GrandPrixBetPointsDtoFromJson(json);

  factory GrandPrixBetPointsDto.fromIdPlayerIdAndJson({
    required String id,
    required String playerId,
    required Map<String, Object?> json,
  }) =>
      GrandPrixBetPointsDto.fromJson(json).copyWith(
        id: id,
        playerId: playerId,
      );
}

@freezed
class QualiBetPointsDto with _$QualiBetPointsDto {
  const factory QualiBetPointsDto({
    required double totalPoints,
    required double q3P1Points,
    required double q3P2Points,
    required double q3P3Points,
    required double q3P4Points,
    required double q3P5Points,
    required double q3P6Points,
    required double q3P7Points,
    required double q3P8Points,
    required double q3P9Points,
    required double q3P10Points,
    required double q2P11Points,
    required double q2P12Points,
    required double q2P13Points,
    required double q2P14Points,
    required double q2P15Points,
    required double q1P16Points,
    required double q1P17Points,
    required double q1P18Points,
    required double q1P19Points,
    required double q1P20Points,
    required double q1Points,
    required double q2Points,
    required double q3Points,
    double? q1Multiplier,
    double? q2Multiplier,
    double? q3Multiplier,
    double? multiplier,
  }) = _QualiBetPointsDto;

  factory QualiBetPointsDto.fromJson(Map<String, Object?> json) =>
      _$QualiBetPointsDtoFromJson(json);
}

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
