import 'package:freezed_annotation/freezed_annotation.dart';

part 'grand_prix_result_dto.g.dart';
part 'grand_prix_result_dto.freezed.dart';

@freezed
class GrandPrixResultDto with _$GrandPrixResultDto {
  const factory GrandPrixResultDto({
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,
    required String grandPrixId,
    List<String>? qualiStandingsByDriverIds,
    String? p1DriverId,
    String? p2DriverId,
    String? p3DriverId,
    String? p10DriverId,
    String? fastestLapDriverId,
    List<String>? dnfDriverIds,
    bool? wasThereSafetyCar,
    bool? wasThereRedFlag,
  }) = _GrandPrixResultDto;

  factory GrandPrixResultDto.fromJson(Map<String, Object?> json) =>
      _$GrandPrixResultDtoFromJson(json);

  factory GrandPrixResultDto.fromIdAndJson(
    String id,
    Map<String, Object?> json,
  ) =>
      GrandPrixResultDto.fromJson(json).copyWith(id: id);
}
