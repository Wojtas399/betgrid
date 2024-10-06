import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../use_case/get_grand_prixes_with_points_use_case.dart';

part 'bets_state.freezed.dart';

enum BetsStateStatus {
  loading,
  completed,
  loggedUserDoesNotExist,
  noBets,
}

extension BetsStateStatusExtensions on BetsStateStatus {
  bool get isLoading => this == BetsStateStatus.loading;

  bool get areNoBets => this == BetsStateStatus.noBets;
}

@freezed
class BetsState with _$BetsState {
  const factory BetsState({
    @Default(BetsStateStatus.loading) BetsStateStatus status,
    String? loggedUserId,
    double? totalPoints,
    List<GrandPrixWithPoints>? grandPrixesWithPoints,
  }) = _BetsState;
}
