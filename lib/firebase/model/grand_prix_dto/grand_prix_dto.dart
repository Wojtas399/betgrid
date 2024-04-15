import 'package:freezed_annotation/freezed_annotation.dart';

part 'grand_prix_dto.freezed.dart';
part 'grand_prix_dto.g.dart';

@freezed
class GrandPrixDto with _$GrandPrixDto {
  const factory GrandPrixDto({
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,
    required int roundNumber,
    required String name,
    required String countryAlpha2Code,
    required DateTime startDate,
    required DateTime endDate,
  }) = _GrandPrixDto;

  factory GrandPrixDto.fromJson(Map<String, Object?> json) =>
      _$GrandPrixDtoFromJson(json);

  factory GrandPrixDto.fromIdAndJson(String id, Map<String, Object?> json) =>
      GrandPrixDto.fromJson(json).copyWith(id: id);
}
