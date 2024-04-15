import 'package:betgrid/model/grand_prix_results.dart';

GrandPrixResults createGrandPrixResults({
  String id = '',
  String grandPrixId = '',
  List<String>? qualiStandingsByDriverIds,
  RaceResults? raceResults,
}) =>
    GrandPrixResults(
      id: id,
      grandPrixId: grandPrixId,
      qualiStandingsByDriverIds: qualiStandingsByDriverIds,
      raceResults: raceResults,
    );

RaceResults createRaceResults({
  String p1DriverId = '',
  String p2DriverId = '',
  String p3DriverId = '',
  String p10DriverId = '',
  String fastestLapDriverId = '',
  List<String> dnfDriverIds = const [],
  bool wasThereSafetyCar = false,
  bool wasThereRedFlag = false,
}) =>
    RaceResults(
      p1DriverId: p1DriverId,
      p2DriverId: p2DriverId,
      p3DriverId: p3DriverId,
      p10DriverId: p10DriverId,
      fastestLapDriverId: fastestLapDriverId,
      dnfDriverIds: dnfDriverIds,
      wasThereSafetyCar: wasThereSafetyCar,
      wasThereRedFlag: wasThereRedFlag,
    );
