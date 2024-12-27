import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../model/grand_prix.dart';

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
    List<GrandPrixItemParams>? grandPrixItems,
  }) = _BetsState;
}

class GrandPrixItemParams extends Equatable {
  final GrandPrixStatus status;
  final GrandPrix grandPrix;
  final double? betPoints;

  const GrandPrixItemParams({
    required this.status,
    required this.grandPrix,
    this.betPoints,
  });

  @override
  List<Object?> get props => [
        status,
        grandPrix,
        betPoints,
      ];
}

abstract class GrandPrixStatus extends Equatable {
  const GrandPrixStatus();

  @override
  List<Object?> get props => [];
}

class GrandPrixStatusOngoing extends GrandPrixStatus {
  const GrandPrixStatusOngoing();
}

class GrandPrixStatusFinished extends GrandPrixStatus {
  const GrandPrixStatusFinished();
}

class GrandPrixStatusNext extends GrandPrixStatus {
  final Duration durationToStart;

  const GrandPrixStatusNext({required this.durationToStart});

  @override
  List<Object?> get props => [durationToStart];
}

class GrandPrixStatusUpcoming extends GrandPrixStatus {
  const GrandPrixStatusUpcoming();
}

extension GrandPrixStatusX on GrandPrixStatus {
  bool get isOngoing => this is GrandPrixStatusOngoing;

  bool get isNext => this is GrandPrixStatusNext;
}
