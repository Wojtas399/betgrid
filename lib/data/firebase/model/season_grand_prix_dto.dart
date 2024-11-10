import 'package:freezed_annotation/freezed_annotation.dart';

part 'season_grand_prix_dto.freezed.dart';
part 'season_grand_prix_dto.g.dart';

@freezed
class SeasonGrandPrixDto with _$SeasonGrandPrixDto {
  const factory SeasonGrandPrixDto({
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,
    required int season,
    required String grandPrixId,
    required int roundNumber,
    required DateTime startDate,
    required DateTime endDate,
  }) = _SeasonGrandPrixDto;

  factory SeasonGrandPrixDto.fromJson(Map<String, Object?> json) =>
      _$SeasonGrandPrixDtoFromJson(json);

  factory SeasonGrandPrixDto.fromFirebase({
    required String id,
    required Map<String, Object?> json,
  }) =>
      SeasonGrandPrixDto.fromJson(json).copyWith(id: id);
}
