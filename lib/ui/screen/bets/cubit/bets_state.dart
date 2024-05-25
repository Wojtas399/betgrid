import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../use_case/get_grand_prixes_with_points_use_case.dart';

part 'bets_state.freezed.dart';

enum BetsStateStatus {
  loading,
  completed,
  loggedUserDoesNotExist,
}

@freezed
class BetsState with _$BetsState {
  const factory BetsState({
    @Default(BetsStateStatus.loading) BetsStateStatus status,
    @Default('') String loggedUserId,
    @Default(0.0) double totalPoints,
    @Default([]) List<GrandPrixWithPoints> grandPrixesWithPoints,
  }) = _BetsState;
}
