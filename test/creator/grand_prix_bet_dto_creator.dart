import 'package:betgrid/firebase/model/grand_prix_bet/grand_prix_bet_dto.dart';

GrandPrixBetDto createGrandPrixBetDto({
  String id = '',
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
    GrandPrixBetDto(
      id: id,
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
