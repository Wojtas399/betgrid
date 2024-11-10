import 'package:betgrid/data/firebase/model/grand_prix_results_dto.dart';
import 'package:betgrid/data/mapper/grand_prix_results_mapper.dart';
import 'package:betgrid/model/grand_prix_results.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String id = 'gpb1';
  const String grandPrixId = 'gp1';
  final List<String> qualiStandingsByDriverIds = List.generate(
    20,
    (index) => 'd$index',
  );
  const String p1DriverId = 'd1';
  const String p2DriverId = 'd2';
  const String p3DriverId = 'd3';
  const String p10DriverId = 'd4';
  const String fastestLapDriverId = 'd1';
  const List<String> dnfDriverIds = ['d10', 'd11', 'd12'];
  const bool wasThereSafetyCar = true;
  const bool wasThereRedFlag = false;
  final mapper = GrandPrixResultsMapper();

  test(
    'mapFromDto, '
    'should map GrandPrixResultsDto model to GrandPrixResults model',
    () {
      final GrandPrixResultsDto grandPrixResultsDto = GrandPrixResultsDto(
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
      final GrandPrixResults expectedGrandPrixResults = GrandPrixResults(
        id: id,
        grandPrixId: grandPrixId,
        qualiStandingsBySeasonDriverIds: qualiStandingsByDriverIds,
        raceResults: const RaceResults(
          p1SeasonDriverId: p1DriverId,
          p2SeasonDriverId: p2DriverId,
          p3SeasonDriverId: p3DriverId,
          p10SeasonDriverId: p10DriverId,
          fastestLapSeasonDriverId: fastestLapDriverId,
          dnfSeasonDriverIds: dnfDriverIds,
          wasThereSafetyCar: wasThereSafetyCar,
          wasThereRedFlag: wasThereRedFlag,
        ),
      );

      final GrandPrixResults grandPrixResults = mapper.mapFromDto(
        grandPrixResultsDto,
      );

      expect(grandPrixResults, expectedGrandPrixResults);
    },
  );

  test(
    'mapFromDto, '
    'p1DriverId is null, '
    'should set race results as null',
    () {
      final GrandPrixResultsDto grandPrixResultsDto = GrandPrixResultsDto(
        id: id,
        grandPrixId: grandPrixId,
        qualiStandingsByDriverIds: qualiStandingsByDriverIds,
        p1DriverId: null,
        p2DriverId: p2DriverId,
        p3DriverId: p3DriverId,
        p10DriverId: p10DriverId,
        fastestLapDriverId: fastestLapDriverId,
        dnfDriverIds: dnfDriverIds,
        wasThereSafetyCar: wasThereSafetyCar,
        wasThereRedFlag: wasThereRedFlag,
      );
      final GrandPrixResults expectedGrandPrixResults = GrandPrixResults(
        id: id,
        grandPrixId: grandPrixId,
        qualiStandingsBySeasonDriverIds: qualiStandingsByDriverIds,
        raceResults: null,
      );

      final GrandPrixResults grandPrixResults = mapper.mapFromDto(
        grandPrixResultsDto,
      );

      expect(grandPrixResults, expectedGrandPrixResults);
    },
  );

  test(
    'mapFromDto, '
    'p2DriverId is null, '
    'should set race results as null',
    () {
      final GrandPrixResultsDto grandPrixResultsDto = GrandPrixResultsDto(
        id: id,
        grandPrixId: grandPrixId,
        qualiStandingsByDriverIds: qualiStandingsByDriverIds,
        p1DriverId: p1DriverId,
        p2DriverId: null,
        p3DriverId: p3DriverId,
        p10DriverId: p10DriverId,
        fastestLapDriverId: fastestLapDriverId,
        dnfDriverIds: dnfDriverIds,
        wasThereSafetyCar: wasThereSafetyCar,
        wasThereRedFlag: wasThereRedFlag,
      );
      final GrandPrixResults expectedGrandPrixResults = GrandPrixResults(
        id: id,
        grandPrixId: grandPrixId,
        qualiStandingsBySeasonDriverIds: qualiStandingsByDriverIds,
        raceResults: null,
      );

      final GrandPrixResults grandPrixResults = mapper.mapFromDto(
        grandPrixResultsDto,
      );

      expect(grandPrixResults, expectedGrandPrixResults);
    },
  );

  test(
    'mapFromDto, '
    'p3DriverId is null, '
    'should set race results as null',
    () {
      final GrandPrixResultsDto grandPrixResultsDto = GrandPrixResultsDto(
        id: id,
        grandPrixId: grandPrixId,
        qualiStandingsByDriverIds: qualiStandingsByDriverIds,
        p1DriverId: p1DriverId,
        p2DriverId: p2DriverId,
        p3DriverId: null,
        p10DriverId: p10DriverId,
        fastestLapDriverId: fastestLapDriverId,
        dnfDriverIds: dnfDriverIds,
        wasThereSafetyCar: wasThereSafetyCar,
        wasThereRedFlag: wasThereRedFlag,
      );
      final GrandPrixResults expectedGrandPrixResults = GrandPrixResults(
        id: id,
        grandPrixId: grandPrixId,
        qualiStandingsBySeasonDriverIds: qualiStandingsByDriverIds,
        raceResults: null,
      );

      final GrandPrixResults grandPrixResults = mapper.mapFromDto(
        grandPrixResultsDto,
      );

      expect(grandPrixResults, expectedGrandPrixResults);
    },
  );

  test(
    'mapFromDto, '
    'p10DriverId is null, '
    'should set race results as null',
    () {
      final GrandPrixResultsDto grandPrixResultsDto = GrandPrixResultsDto(
        id: id,
        grandPrixId: grandPrixId,
        qualiStandingsByDriverIds: qualiStandingsByDriverIds,
        p1DriverId: p1DriverId,
        p2DriverId: p2DriverId,
        p3DriverId: p3DriverId,
        p10DriverId: null,
        fastestLapDriverId: fastestLapDriverId,
        dnfDriverIds: dnfDriverIds,
        wasThereSafetyCar: wasThereSafetyCar,
        wasThereRedFlag: wasThereRedFlag,
      );
      final GrandPrixResults expectedGrandPrixResults = GrandPrixResults(
        id: id,
        grandPrixId: grandPrixId,
        qualiStandingsBySeasonDriverIds: qualiStandingsByDriverIds,
        raceResults: null,
      );

      final GrandPrixResults grandPrixResults = mapper.mapFromDto(
        grandPrixResultsDto,
      );

      expect(grandPrixResults, expectedGrandPrixResults);
    },
  );

  test(
    'mapFromDto, '
    'fastestLapDriverId is null, '
    'should set race results as null',
    () {
      final GrandPrixResultsDto grandPrixResultsDto = GrandPrixResultsDto(
        id: id,
        grandPrixId: grandPrixId,
        qualiStandingsByDriverIds: qualiStandingsByDriverIds,
        p1DriverId: p1DriverId,
        p2DriverId: p2DriverId,
        p3DriverId: p3DriverId,
        p10DriverId: p10DriverId,
        fastestLapDriverId: null,
        dnfDriverIds: dnfDriverIds,
        wasThereSafetyCar: wasThereSafetyCar,
        wasThereRedFlag: wasThereRedFlag,
      );
      final GrandPrixResults expectedGrandPrixResults = GrandPrixResults(
        id: id,
        grandPrixId: grandPrixId,
        qualiStandingsBySeasonDriverIds: qualiStandingsByDriverIds,
        raceResults: null,
      );

      final GrandPrixResults grandPrixResults = mapper.mapFromDto(
        grandPrixResultsDto,
      );

      expect(grandPrixResults, expectedGrandPrixResults);
    },
  );

  test(
    'mapFromDto, '
    'dnfDriverIds param is null, '
    'should set race results as null',
    () {
      final GrandPrixResultsDto grandPrixResultsDto = GrandPrixResultsDto(
        id: id,
        grandPrixId: grandPrixId,
        qualiStandingsByDriverIds: qualiStandingsByDriverIds,
        p1DriverId: p1DriverId,
        p2DriverId: p2DriverId,
        p3DriverId: p3DriverId,
        p10DriverId: p10DriverId,
        fastestLapDriverId: fastestLapDriverId,
        dnfDriverIds: null,
        wasThereSafetyCar: wasThereSafetyCar,
        wasThereRedFlag: wasThereRedFlag,
      );
      final GrandPrixResults expectedGrandPrixResults = GrandPrixResults(
        id: id,
        grandPrixId: grandPrixId,
        qualiStandingsBySeasonDriverIds: qualiStandingsByDriverIds,
        raceResults: null,
      );

      final GrandPrixResults grandPrixResults = mapper.mapFromDto(
        grandPrixResultsDto,
      );

      expect(grandPrixResults, expectedGrandPrixResults);
    },
  );

  test(
    'mapFromDto, '
    'wasThereSafetyCar is null, '
    'should set race results as null',
    () {
      final GrandPrixResultsDto grandPrixResultsDto = GrandPrixResultsDto(
        id: id,
        grandPrixId: grandPrixId,
        qualiStandingsByDriverIds: qualiStandingsByDriverIds,
        p1DriverId: p1DriverId,
        p2DriverId: p2DriverId,
        p3DriverId: p3DriverId,
        p10DriverId: p10DriverId,
        fastestLapDriverId: fastestLapDriverId,
        dnfDriverIds: dnfDriverIds,
        wasThereSafetyCar: null,
        wasThereRedFlag: wasThereRedFlag,
      );
      final GrandPrixResults expectedGrandPrixResults = GrandPrixResults(
        id: id,
        grandPrixId: grandPrixId,
        qualiStandingsBySeasonDriverIds: qualiStandingsByDriverIds,
        raceResults: null,
      );

      final GrandPrixResults grandPrixResults = mapper.mapFromDto(
        grandPrixResultsDto,
      );

      expect(grandPrixResults, expectedGrandPrixResults);
    },
  );

  test(
    'mapFromDto, '
    'wasThereRedFlag is null, '
    'should set race results as null',
    () {
      final GrandPrixResultsDto grandPrixResultsDto = GrandPrixResultsDto(
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
        wasThereRedFlag: null,
      );
      final GrandPrixResults expectedGrandPrixResults = GrandPrixResults(
        id: id,
        grandPrixId: grandPrixId,
        qualiStandingsBySeasonDriverIds: qualiStandingsByDriverIds,
        raceResults: null,
      );

      final GrandPrixResults grandPrixResults = mapper.mapFromDto(
        grandPrixResultsDto,
      );

      expect(grandPrixResults, expectedGrandPrixResults);
    },
  );
}
