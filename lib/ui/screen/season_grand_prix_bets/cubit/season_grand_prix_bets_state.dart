import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'season_grand_prix_bets_state.freezed.dart';

enum SeasonGrandPrixBetsStateStatus {
  loading,
  completed,
  loggedUserDoesNotExist,
  noBets,
}

extension SeasonGrandPrixBetsStateStatusExtensions
    on SeasonGrandPrixBetsStateStatus {
  bool get isLoading => this == SeasonGrandPrixBetsStateStatus.loading;

  bool get areNoBets => this == SeasonGrandPrixBetsStateStatus.noBets;
}

@freezed
class SeasonGrandPrixBetsState with _$SeasonGrandPrixBetsState {
  const SeasonGrandPrixBetsState._();

  const factory SeasonGrandPrixBetsState({
    @Default(SeasonGrandPrixBetsStateStatus.loading)
    SeasonGrandPrixBetsStateStatus status,
    String? loggedUserId,
    int? season,
    double? totalPoints,
    List<SeasonGrandPrixItemParams>? grandPrixItems,
    Duration? durationToStartNextGp,
  }) = _SeasonGrandPrixBetsState;

  bool get doesOngoingGpExist =>
      grandPrixItems?.any((gp) => gp.status.isOngoing) ?? false;
}

class SeasonGrandPrixItemParams extends Equatable {
  final String seasonGrandPrixId;
  final SeasonGrandPrixStatus status;
  final String grandPrixName;
  final String countryAlpha2Code;
  final int roundNumber;
  final DateTime startDate;
  final DateTime endDate;
  final double? betPoints;

  const SeasonGrandPrixItemParams({
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

abstract class SeasonGrandPrixStatus extends Equatable {
  const SeasonGrandPrixStatus();

  @override
  List<Object?> get props => [];
}

class SeasonGrandPrixStatusOngoing extends SeasonGrandPrixStatus {
  const SeasonGrandPrixStatusOngoing();
}

class SeasonGrandPrixStatusFinished extends SeasonGrandPrixStatus {
  const SeasonGrandPrixStatusFinished();
}

class SeasonGrandPrixStatusNext extends SeasonGrandPrixStatus {
  const SeasonGrandPrixStatusNext();
}

class SeasonGrandPrixStatusUpcoming extends SeasonGrandPrixStatus {
  const SeasonGrandPrixStatusUpcoming();
}

extension SeasonGrandPrixStatusX on SeasonGrandPrixStatus {
  bool get isOngoing => this is SeasonGrandPrixStatusOngoing;

  bool get isNext => this is SeasonGrandPrixStatusNext;

  bool get isFinished => this is SeasonGrandPrixStatusFinished;

  bool get isUpcoming => this is SeasonGrandPrixStatusUpcoming;
}
