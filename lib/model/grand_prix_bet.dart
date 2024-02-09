import 'entity.dart';

class GrandPrixBet extends Entity {
  final String grandPrixId;
  final List<String>? qualiStandingsByDriverIds;
  final String? p1DriverId;
  final String? p2DriverId;
  final String? p3DriverId;
  final String? p10DriverId;
  final String? fastestLapDriverId;
  final bool? willBeDnf;
  final bool? willBeSafetyCar;
  final bool? willBeRedFlag;

  const GrandPrixBet({
    required super.id,
    required this.grandPrixId,
    this.qualiStandingsByDriverIds,
    this.p1DriverId,
    this.p2DriverId,
    this.p3DriverId,
    this.p10DriverId,
    this.fastestLapDriverId,
    this.willBeDnf,
    this.willBeSafetyCar,
    this.willBeRedFlag,
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
