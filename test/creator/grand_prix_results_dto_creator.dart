import 'package:betgrid/firebase/model/grand_prix_result_dto/grand_prix_results_dto.dart';

GrandPrixResultsDto createGrandPrixResultsDto({
  String id = '',
  String grandPrixId = '',
  List<String>? qualiStandingsByDriverIds,
  String? p1DriverId,
  String? p2DriverId,
  String? p3DriverId,
  String? p10DriverId,
  String? fastestLapDriverId,
  List<String>? dnfDriverIds,
  bool? wasThereSafetyCar,
  bool? wasThereRedFlag,
}) =>
    GrandPrixResultsDto(
      id: id,
      grandPrixId: grandPrixId,
      qualiStandingsByDriverIds: qualiStandingsByDriverIds,
      p1DriverId: p1DriverId,
      p2DriverId: p2DriverId,
      p3DriverId: p3DriverId,
      p10DriverId: p10DriverId,
      fastestLapDriverId: fastestLapDriverId,
      dnfDriverIds: dnfDriverIds,
      wasThereSafetyCar: wasThereSafetyCar,
      wasThereRedFlag: wasThereRedFlag,
    );
