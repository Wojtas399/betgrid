import 'package:equatable/equatable.dart';

import 'driver.dart';

class GrandPrixBet extends Equatable {
  final String id;
  final String grandPrixId;
  final List<String> qualiStandingsByDriverIds;
  final Driver p1DriverId;
  final Driver p2DriverId;
  final Driver p3DriverId;
  final Driver p10DriverId;
  final Driver fastestLapDriverId;
  final bool willBeDnf;
  final bool willBeSafetyCar;
  final bool willBeRedFlag;

  const GrandPrixBet({
    required this.id,
    required this.grandPrixId,
    required this.qualiStandingsByDriverIds,
    required this.p1DriverId,
    required this.p2DriverId,
    required this.p3DriverId,
    required this.p10DriverId,
    required this.fastestLapDriverId,
    required this.willBeDnf,
    required this.willBeSafetyCar,
    required this.willBeRedFlag,
  });

  @override
  List<Object?> get props => [
        id,
        grandPrixId,
        qualiStandingsByDriverIds,
        p1DriverId,
        p2DriverId,
        p3DriverId,
        p10DriverId,
        fastestLapDriverId,
        willBeDnf,
        willBeSafetyCar,
        willBeRedFlag,
      ];
}