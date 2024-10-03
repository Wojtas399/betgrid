import 'package:freezed_annotation/freezed_annotation.dart';

import '../quali_bet_points_dto.dart';
import '../race_bet_points_dto.dart';

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
    @JsonKey(
      name: 'qualiBetPoints',
      toJson: _mapQualiBetPointsToJson,
    )
    QualiBetPointsDto? qualiBetPointsDto,
    @JsonKey(
      name: 'raceBetPoints',
      toJson: _mapRaceBetPointsToJson,
    )
    RaceBetPointsDto? raceBetPointsDto,
  }) = _GrandPrixBetPointsDto;

  factory GrandPrixBetPointsDto.fromJson(Map<String, Object?> json) =>
      _$GrandPrixBetPointsDtoFromJson(json);

  factory GrandPrixBetPointsDto.fromFirebase({
    required String id,
    required String playerId,
    required Map<String, Object?> json,
  }) =>
      GrandPrixBetPointsDto.fromJson(json).copyWith(
        id: id,
        playerId: playerId,
      );
}

Map<String, Object?>? _mapQualiBetPointsToJson(QualiBetPointsDto? dto) =>
    dto?.toJson();

Map<String, Object?>? _mapRaceBetPointsToJson(RaceBetPointsDto? dto) =>
    dto?.toJson();
