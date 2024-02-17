import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

@freezed
class UserDto with _$UserDto {
  const factory UserDto({
    @JsonKey(includeToJson: false, includeFromJson: false)
    @Default('')
    String id,
    required String nick,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, Object?> json) =>
      _$UserDtoFromJson(json);

  factory UserDto.fromIdAndJson(String id, Map<String, Object?> json) =>
      UserDto.fromJson(json).copyWith(id: id);
}
