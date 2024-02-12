import 'package:freezed_annotation/freezed_annotation.dart';

part 'grand_prix_bet_dto.freezed.dart';
part 'grand_prix_bet_dto.g.dart';

@freezed
class GrandPrixBetDto with _$GrandPrixBetDto {
  const factory GrandPrixBetDto({
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,
    required String grandPrixId,
    required List<String?> qualiStandingsByDriverIds,
    String? p1DriverId,
    String? p2DriverId,
    String? p3DriverId,
    String? p10DriverId,
    String? fastestLapDriverId,
    bool? willBeDnf,
    bool? willBeSafetyCar,
    bool? willBeRedFlag,
  }) = _GrandPrixBetDto;

  factory GrandPrixBetDto.fromJson(Map<String, Object?> json) =>
      _$GrandPrixBetDtoFromJson(json);

  factory GrandPrixBetDto.fromIdAndJson(String id, Map<String, Object?>? json) {
    if (json == null) throw Exception('Grand prix bet document data was null');
    return GrandPrixBetDto.fromJson(json).copyWith(id: id);
  }
}
