import 'package:freezed_annotation/freezed_annotation.dart';

part 'team_dto.freezed.dart';
part 'team_dto.g.dart';

@freezed
class TeamDto with _$TeamDto {
  const factory TeamDto({
    @JsonKey(includeToJson: false, includeFromJson: false)
    @Default('')
    String id,
    required String name,
    required String hexColor,
  }) = _TeamDto;

  factory TeamDto.fromJson(Map<String, Object?> json) =>
      _$TeamDtoFromJson(json);

  factory TeamDto.fromFirebase({
    required String id,
    required Map<String, Object?> json,
  }) =>
      TeamDto.fromJson(json).copyWith(id: id);
}
