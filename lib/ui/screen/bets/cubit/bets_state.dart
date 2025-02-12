import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

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
  const BetsState._();

  const factory BetsState({
    @Default(BetsStateStatus.loading) BetsStateStatus status,
    String? loggedUserId,
    int? season,
    double? totalPoints,
    List<GrandPrixItemParams>? grandPrixItems,
    Duration? durationToStartNextGp,
  }) = _BetsState;

  bool get doesOngoingGpExist =>
      grandPrixItems?.any((gp) => gp.status.isOngoing) ?? false;
}

class GrandPrixItemParams extends Equatable {
  final String seasonGrandPrixId;
  final GrandPrixStatus status;
  final String grandPrixName;
  final String countryAlpha2Code;
  final int roundNumber;
  final DateTime startDate;
  final DateTime endDate;
  final double? betPoints;

  const GrandPrixItemParams({
    required this.seasonGrandPrixId,
    required this.status,
    required this.grandPrixName,
    required this.countryAlpha2Code,
    required this.roundNumber,
    required this.startDate,
    required this.endDate,
    this.betPoints,
  });

  @override
  List<Object?> get props => [
        seasonGrandPrixId,
        status,
        grandPrixName,
        countryAlpha2Code,
        roundNumber,
        startDate,
        endDate,
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
  const GrandPrixStatusNext();
}

class GrandPrixStatusUpcoming extends GrandPrixStatus {
  const GrandPrixStatusUpcoming();
}

extension GrandPrixStatusX on GrandPrixStatus {
  bool get isOngoing => this is GrandPrixStatusOngoing;

  bool get isNext => this is GrandPrixStatusNext;

  bool get isFinished => this is GrandPrixStatusFinished;

  bool get isUpcoming => this is GrandPrixStatusUpcoming;
}
