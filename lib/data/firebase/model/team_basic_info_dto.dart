import 'package:freezed_annotation/freezed_annotation.dart';

part 'team_basic_info_dto.freezed.dart';
part 'team_basic_info_dto.g.dart';

@freezed
class TeamBasicInfoDto with _$TeamBasicInfoDto {
  const factory TeamBasicInfoDto({
    @JsonKey(includeToJson: false, includeFromJson: false)
    @Default('')
    String id,
    required String name,
    required String hexColor,
  }) = _TeamBasicInfoDto;

  factory TeamBasicInfoDto.fromJson(Map<String, Object?> json) =>
      _$TeamBasicInfoDtoFromJson(json);

  factory TeamBasicInfoDto.fromFirebase({
    required String id,
    required Map<String, Object?> json,
  }) =>
      TeamBasicInfoDto.fromJson(json).copyWith(id: id);
}
