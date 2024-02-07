import 'package:freezed_annotation/freezed_annotation.dart';

part 'grand_prix_dto.freezed.dart';
part 'grand_prix_dto.g.dart';

@freezed
class GrandPrixDto with _$GrandPrixDto {
  const factory GrandPrixDto({
    required String id,
    required String name,
    required DateTime startDate,
    required DateTime endDate,
  }) = _GrandPrixDto;

  factory GrandPrixDto.fromJson(Map<String, Object?> json) =>
      _$GrandPrixDtoFromJson(json);
}
