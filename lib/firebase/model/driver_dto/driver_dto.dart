import 'package:freezed_annotation/freezed_annotation.dart';

part 'driver_dto.freezed.dart';
part 'driver_dto.g.dart';

@freezed
class DriverDto with _$DriverDto {
  const factory DriverDto({
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,
    required String name,
    required String surname,
    required int number,
    required TeamDto team,
  }) = _DriverDto;

  factory DriverDto.fromJson(Map<String, Object?> json) =>
      _$DriverDtoFromJson(json);

  factory DriverDto.fromIdAndJson(String id, Map<String, Object?>? json) {
    if (json == null) throw Exception('Driver document data was null');
    return DriverDto.fromJson(json).copyWith(id: id);
  }
}

enum TeamDto {
  mercedes,
  alpine,
  haasF1Team,
  redBullRacing,
  mcLaren,
  astonMartin,
  rb,
  ferrari,
  kickSauber,
  williams,
}
