import 'entity.dart';

class GrandPrixBet extends Entity {
  final String grandPrixId;
  final List<String?> qualiStandingsByDriverIds;
  final String? p1DriverId;
  final String? p2DriverId;
  final String? p3DriverId;
  final String? p10DriverId;
  final String? fastestLapDriverId;
  final List<String?> dnfDriverIds;
  final bool? willBeSafetyCar;
  final bool? willBeRedFlag;

  const GrandPrixBet({
    required super.id,
    required this.grandPrixId,
    required this.qualiStandingsByDriverIds,
    this.p1DriverId,
    this.p2DriverId,
    this.p3DriverId,
    this.p10DriverId,
    this.fastestLapDriverId,
    required this.dnfDriverIds,
    this.willBeSafetyCar,
    this.willBeRedFlag,
  })  : assert(qualiStandingsByDriverIds.length == 20),
        assert(dnfDriverIds.length == 3);

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
        dnfDriverIds,
        willBeSafetyCar,
        willBeRedFlag,
      ];
}
