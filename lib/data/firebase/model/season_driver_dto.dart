import 'package:freezed_annotation/freezed_annotation.dart';

part 'season_driver_dto.freezed.dart';
part 'season_driver_dto.g.dart';

@freezed
class SeasonDriverDto with _$SeasonDriverDto {
  const factory SeasonDriverDto({
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,
    required int season,
    required String driverId,
    required int driverNumber,
    required String teamId,
  }) = _SeasonDriverDto;

  factory SeasonDriverDto.fromJson(Map<String, Object?> json) =>
      _$SeasonDriverDtoFromJson(json);

  factory SeasonDriverDto.fromFirebase({
    required String id,
    required Map<String, Object?> json,
  }) =>
      SeasonDriverDto.fromJson(json).copyWith(id: id);
}
