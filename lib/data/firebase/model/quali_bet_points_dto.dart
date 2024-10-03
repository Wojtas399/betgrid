import 'package:freezed_annotation/freezed_annotation.dart';

part 'quali_bet_points_dto.freezed.dart';
part 'quali_bet_points_dto.g.dart';

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
