import 'package:freezed_annotation/freezed_annotation.dart';

part 'grand_prix_basic_info_dto.freezed.dart';
part 'grand_prix_basic_info_dto.g.dart';

@freezed
class GrandPrixBasicInfoDto with _$GrandPrixBasicInfoDto {
  const factory GrandPrixBasicInfoDto({
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,
    required String name,
    required String countryAlpha2Code,
  }) = _GrandPrixBasicInfoDto;

  factory GrandPrixBasicInfoDto.fromJson(Map<String, Object?> json) =>
      _$GrandPrixBasicInfoDtoFromJson(json);

  factory GrandPrixBasicInfoDto.fromFirebase({
    required String id,
    required Map<String, Object?> json,
  }) =>
      GrandPrixBasicInfoDto.fromJson(json).copyWith(id: id);
}
