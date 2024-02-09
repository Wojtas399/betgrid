import 'package:betgrid/firebase/model/grand_prix_bet/grand_prix_bet_dto.dart';

GrandPrixBetDto createGrandPrixBetDto({
  String id = '',
  String grandPrixId = '',
  List<String>? qualiStandingsByDriverIds,
  String? p1DriverId,
  String? p2DriverId,
  String? p3DriverId,
  String? p10DriverId,
  String? fastestLapDriverId,
  bool? willBeDnf,
  bool? willBeSafetyCar,
  bool? willBeRedFlag,
}) =>
    GrandPrixBetDto(
      id: id,
      grandPrixId: grandPrixId,
      qualiStandingsByDriverIds: qualiStandingsByDriverIds,
      p1DriverId: p1DriverId,
      p2DriverId: p2DriverId,
      p3DriverId: p3DriverId,
      p10DriverId: p10DriverId,
      fastestLapDriverId: fastestLapDriverId,
      willBeDnf: willBeDnf,
      willBeSafetyCar: willBeSafetyCar,
      willBeRedFlag: willBeRedFlag,
    );
