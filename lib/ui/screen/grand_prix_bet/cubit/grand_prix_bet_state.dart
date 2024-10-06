import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../model/driver.dart';
import '../../../../model/grand_prix_bet.dart';
import '../../../../model/grand_prix_bet_points.dart';
import '../../../../model/grand_prix_results.dart';

part 'grand_prix_bet_state.freezed.dart';

enum GrandPrixBetStateStatus {
  loading,
  completed,
  loggedUserDoesNotExist,
}

extension GrandPrixBetStateStatusExtensions on GrandPrixBetStateStatus {
  bool get isLoading => this == GrandPrixBetStateStatus.loading;
}

@freezed
class GrandPrixBetState with _$GrandPrixBetState {
  const GrandPrixBetState._();

  const factory GrandPrixBetState({
    @Default(GrandPrixBetStateStatus.loading) GrandPrixBetStateStatus status,
    String? grandPrixName,
    String? playerUsername,
    bool? isPlayerIdSameAsLoggedUserId,
    GrandPrixBet? grandPrixBet,
    GrandPrixResults? grandPrixResults,
    GrandPrixBetPoints? grandPrixBetPoints,
    List<Driver>? allDrivers,
  }) = _GrandPrixBetState;

  Driver? getDriverById(String driverId) => allDrivers?.firstWhereOrNull(
        (element) => element.id == driverId,
      );
}
