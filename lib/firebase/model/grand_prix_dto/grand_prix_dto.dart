import 'package:freezed_annotation/freezed_annotation.dart';

part 'grand_prix_dto.freezed.dart';
part 'grand_prix_dto.g.dart';

@freezed
class GrandPrixDto with _$GrandPrixDto {
  const factory GrandPrixDto({
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,
    required String name,
    required DateTime startDate,
    required DateTime endDate,
  }) = _GrandPrixDto;

  factory GrandPrixDto.fromJson(Map<String, Object?> json) =>
      _$GrandPrixDtoFromJson(json);

  factory GrandPrixDto.fromIdAndJson(String id, Map<String, Object?>? json) {
    if (json == null) throw Exception('Grand Prix document data was null');
    return GrandPrixDto.fromJson(json).copyWith(id: id);
  }
}
