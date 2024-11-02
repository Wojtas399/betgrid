import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../model/driver.dart';
import '../../../../model/grand_prix_bet_points.dart';

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

  @Assert('qualiBets == null || qualiBets.length == 20')
  @Assert('racePodiumBets == null || racePodiumBets.length == 3')
  const factory GrandPrixBetState({
    @Default(GrandPrixBetStateStatus.loading) GrandPrixBetStateStatus status,
    bool? canEdit,
    String? grandPrixId,
    String? grandPrixName,
    String? playerUsername,
    bool? isPlayerIdSameAsLoggedUserId,
    List<SingleDriverBet>? qualiBets,
    List<SingleDriverBet>? racePodiumBets,
    SingleDriverBet? raceP10Bet,
    SingleDriverBet? raceFastestLapBet,
    MultipleDriversBet? raceDnfDriversBet,
    BooleanBet? raceSafetyCarBet,
    BooleanBet? raceRedFlagBet,
    GrandPrixBetPoints? grandPrixBetPoints,
  }) = _GrandPrixBetState;
}

enum BetStatus { pending, win, loss }

abstract class Bet extends Equatable {
  final BetStatus status;

  const Bet({
    required this.status,
  });
}

class SingleDriverBet extends Bet {
  final Driver? betDriver;
  final Driver? resultDriver;
  final double? points;

  const SingleDriverBet({
    required super.status,
    required this.betDriver,
    required this.resultDriver,
    required this.points,
  });

  @override
  List<Object?> get props => [
        status,
        betDriver,
        resultDriver,
        points,
      ];
}

class MultipleDriversBet extends Bet {
  final List<Driver?>? betDrivers;
  final List<Driver?>? resultDrivers;
  final double? points;

  const MultipleDriversBet({
    required super.status,
    required this.betDrivers,
    required this.resultDrivers,
    required this.points,
  });

  @override
  List<Object?> get props => [
        status,
        betDrivers,
        resultDrivers,
        points,
      ];
}

class BooleanBet extends Bet {
  final bool? betValue;
  final bool? resultValue;
  final double? points;

  const BooleanBet({
    required super.status,
    required this.betValue,
    required this.resultValue,
    required this.points,
  });

  @override
  List<Object?> get props => [
        status,
        betValue,
        resultValue,
        points,
      ];
}
