import 'package:freezed_annotation/freezed_annotation.dart';

part 'grand_prix_bet_notifier_state.freezed.dart';

@freezed
class GrandPrixBetNotifierState with _$GrandPrixBetNotifierState {
  const factory GrandPrixBetNotifierState({
    @Default(GrandPrixBetNotifierStatusComplete())
    GrandPrixBetNotifierStatus status,
    List<String?>? qualiStandingsByDriverIds,
    String? p1DriverId,
    String? p2DriverId,
    String? p3DriverId,
    String? p10DriverId,
    String? fastestLapDriverId,
    List<String?>? dnfDriverIds,
    bool? willBeSafetyCar,
    bool? willBeRedFlag,
  }) = _GrandPrixBetNotifierState;
}

sealed class GrandPrixBetNotifierStatus {
  const GrandPrixBetNotifierStatus();
}

class GrandPrixBetNotifierStatusComplete extends GrandPrixBetNotifierStatus {
  const GrandPrixBetNotifierStatusComplete();
}

class GrandPrixBetNotifierStatusSavingData extends GrandPrixBetNotifierStatus {
  const GrandPrixBetNotifierStatusSavingData();
}

class GrandPrixBetNotifierStatusDataSaved extends GrandPrixBetNotifierStatus {
  const GrandPrixBetNotifierStatusDataSaved();
}
