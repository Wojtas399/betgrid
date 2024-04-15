import 'package:betgrid/model/grand_prix_bet.dart';

GrandPrixBet createGrandPrixBet({
  String id = '',
  String playerId = '',
  String grandPrixId = '',
  List<String?>? qualiStandingsByDriverIds,
  String? p1DriverId,
  String? p2DriverId,
  String? p3DriverId,
  String? p10DriverId,
  String? fastestLapDriverId,
  List<String?> dnfDriverIds = const [null, null, null],
  bool? willBeSafetyCar,
  bool? willBeRedFlag,
}) =>
    GrandPrixBet(
      id: id,
      playerId: playerId,
      grandPrixId: grandPrixId,
      qualiStandingsByDriverIds:
          qualiStandingsByDriverIds ?? List.generate(20, (index) => null),
      p1DriverId: p1DriverId,
      p2DriverId: p2DriverId,
      p3DriverId: p3DriverId,
      p10DriverId: p10DriverId,
      fastestLapDriverId: fastestLapDriverId,
      dnfDriverIds: dnfDriverIds,
      willBeSafetyCar: willBeSafetyCar,
      willBeRedFlag: willBeRedFlag,
    );
