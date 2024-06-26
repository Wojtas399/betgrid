import 'package:betgrid/firebase/model/grand_prix_bet_dto/grand_prix_bet_dto.dart';

GrandPrixBetDto createGrandPrixBetDto({
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
    GrandPrixBetDto(
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
