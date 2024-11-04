import 'package:freezed_annotation/freezed_annotation.dart';

part 'driver_personal_data_dto.freezed.dart';
part 'driver_personal_data_dto.g.dart';

@freezed
class DriverPersonalDataDto with _$DriverPersonalDataDto {
  const factory DriverPersonalDataDto({
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,
    required String name,
    required String surname,
  }) = _DriverPersonalDataDto;

  factory DriverPersonalDataDto.fromJson(Map<String, Object?> json) =>
      _$DriverPersonalDataDtoFromJson(json);

  factory DriverPersonalDataDto.fromFirebase({
    required String id,
    required Map<String, Object?> json,
  }) =>
      DriverPersonalDataDto.fromJson(json).copyWith(id: id);
}
