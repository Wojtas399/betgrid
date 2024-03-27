import 'package:freezed_annotation/freezed_annotation.dart';

part 'grand_prix_results_dto.freezed.dart';
part 'grand_prix_results_dto.g.dart';

@freezed
class GrandPrixResultsDto with _$GrandPrixResultsDto {
  const factory GrandPrixResultsDto({
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,
    required String grandPrixId,
    List<String?>? qualiStandingsByDriverIds,
    String? p1DriverId,
    String? p2DriverId,
    String? p3DriverId,
    String? p10DriverId,
    String? fastestLapDriverId,
    List<String>? dnfDriverIds,
    bool? wasThereSafetyCar,
    bool? wasThereRedFlag,
  }) = _GrandPrixResultsDto;

  factory GrandPrixResultsDto.fromJson(Map<String, Object?> json) =>
      _$GrandPrixResultsDtoFromJson(json);

  factory GrandPrixResultsDto.fromIdAndJson(
    String id,
    Map<String, Object?> json,
  ) =>
      GrandPrixResultsDto.fromJson(json).copyWith(id: id);
}
