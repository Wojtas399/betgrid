import 'package:freezed_annotation/freezed_annotation.dart';

part 'grand_prix_results_dto.freezed.dart';
part 'grand_prix_results_dto.g.dart';

@freezed
class GrandPrixResultsDto with _$GrandPrixResultsDto {
  const factory GrandPrixResultsDto({
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,
    required String seasonGrandPrixId,
    List<String?>? qualiStandingsBySeasonDriverIds,
    String? p1SeasonDriverId,
    String? p2SeasonDriverId,
    String? p3SeasonDriverId,
    String? p10SeasonDriverId,
    String? fastestLapSeasonDriverId,
    List<String>? dnfSeasonDriverIds,
    bool? wasThereSafetyCar,
    bool? wasThereRedFlag,
  }) = _GrandPrixResultsDto;

  factory GrandPrixResultsDto.fromJson(Map<String, Object?> json) =>
      _$GrandPrixResultsDtoFromJson(json);

  factory GrandPrixResultsDto.fromFirebase({
    required String id,
    required Map<String, Object?> json,
  }) =>
      GrandPrixResultsDto.fromJson(json).copyWith(id: id);
}
