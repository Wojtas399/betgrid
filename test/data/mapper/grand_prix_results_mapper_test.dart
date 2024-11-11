import 'package:betgrid/data/firebase/model/grand_prix_results_dto.dart';
import 'package:betgrid/data/mapper/grand_prix_results_mapper.dart';
import 'package:betgrid/model/grand_prix_results.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../creator/grand_prix_results_creator.dart';

void main() {
  const String id = 'gpb1';
  const String seasonGrandPrixId = 'gp1';
  final List<String> qualiStandingsBySeasonDriverIds = List.generate(
    20,
    (index) => 'd$index',
  );
  const String p1SeasonDriverId = 'd1';
  const String p2SeasonDriverId = 'd2';
  const String p3SeasonDriverId = 'd3';
  const String p10SeasonDriverId = 'd4';
  const String fastestLapSeasonDriverId = 'd1';
  const List<String> dnfSeasonDriverIds = ['d10', 'd11', 'd12'];
  const bool wasThereSafetyCar = true;
  const bool wasThereRedFlag = false;
  final mapper = GrandPrixResultsMapper();

  test(
    'mapFromDto, '
    'should map GrandPrixResultsDto model to GrandPrixResults model',
    () {
      final creator = GrandPrixResultsCreator(
        id: id,
        seasonGrandPrixId: seasonGrandPrixId,
        qualiStandingsBySeasonDriverIds: qualiStandingsBySeasonDriverIds,
        p1SeasonDriverId: p1SeasonDriverId,
        p2SeasonDriverId: p2SeasonDriverId,
        p3SeasonDriverId: p3SeasonDriverId,
        p10SeasonDriverId: p10SeasonDriverId,
        fastestLapSeasonDriverId: fastestLapSeasonDriverId,
        dnfSeasonDriverIds: dnfSeasonDriverIds,
        wasThereSafetyCar: wasThereSafetyCar,
        wasThereRedFlag: wasThereRedFlag,
      );
      final GrandPrixResultsDto grandPrixResultsDto = creator.createDto();
      final GrandPrixResults expectedGrandPrixResults = creator.createEntity();

      final GrandPrixResults grandPrixResults = mapper.mapFromDto(
        grandPrixResultsDto,
      );

      expect(grandPrixResults, expectedGrandPrixResults);
    },
  );

  test(
    'mapFromDto, '
    'should set raceResults as null if p1SeasonDriverId is null',
    () {
      final GrandPrixResultsDto grandPrixResultsDto = GrandPrixResultsDto(
        id: id,
        grandPrixId: seasonGrandPrixId,
        qualiStandingsBySeasonDriverIds: qualiStandingsBySeasonDriverIds,
        p1SeasonDriverId: null,
        p2SeasonDriverId: p2SeasonDriverId,
        p3SeasonDriverId: p3SeasonDriverId,
        p10SeasonDriverId: p10SeasonDriverId,
        fastestLapSeasonDriverId: fastestLapSeasonDriverId,
        dnfSeasonDriverIds: dnfSeasonDriverIds,
        wasThereSafetyCar: wasThereSafetyCar,
        wasThereRedFlag: wasThereRedFlag,
      );
      final GrandPrixResults expectedGrandPrixResults = GrandPrixResults(
        id: id,
        seasonGrandPrixId: seasonGrandPrixId,
        qualiStandingsBySeasonDriverIds: qualiStandingsBySeasonDriverIds,
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
    'should set raceResults as null if p2SeasonDriverId is null',
    () {
      final GrandPrixResultsDto grandPrixResultsDto = GrandPrixResultsDto(
        id: id,
        grandPrixId: seasonGrandPrixId,
        qualiStandingsBySeasonDriverIds: qualiStandingsBySeasonDriverIds,
        p1SeasonDriverId: p1SeasonDriverId,
        p2SeasonDriverId: null,
        p3SeasonDriverId: p3SeasonDriverId,
        p10SeasonDriverId: p10SeasonDriverId,
        fastestLapSeasonDriverId: fastestLapSeasonDriverId,
        dnfSeasonDriverIds: dnfSeasonDriverIds,
        wasThereSafetyCar: wasThereSafetyCar,
        wasThereRedFlag: wasThereRedFlag,
      );
      final GrandPrixResults expectedGrandPrixResults = GrandPrixResults(
        id: id,
        seasonGrandPrixId: seasonGrandPrixId,
        qualiStandingsBySeasonDriverIds: qualiStandingsBySeasonDriverIds,
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
    'should set raceResults as null if p3SeasonDriverId is null',
    () {
      final GrandPrixResultsDto grandPrixResultsDto = GrandPrixResultsDto(
        id: id,
        grandPrixId: seasonGrandPrixId,
        qualiStandingsBySeasonDriverIds: qualiStandingsBySeasonDriverIds,
        p1SeasonDriverId: p1SeasonDriverId,
        p2SeasonDriverId: p2SeasonDriverId,
        p3SeasonDriverId: null,
        p10SeasonDriverId: p10SeasonDriverId,
        fastestLapSeasonDriverId: fastestLapSeasonDriverId,
        dnfSeasonDriverIds: dnfSeasonDriverIds,
        wasThereSafetyCar: wasThereSafetyCar,
        wasThereRedFlag: wasThereRedFlag,
      );
      final GrandPrixResults expectedGrandPrixResults = GrandPrixResults(
        id: id,
        seasonGrandPrixId: seasonGrandPrixId,
        qualiStandingsBySeasonDriverIds: qualiStandingsBySeasonDriverIds,
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
    'should set raceResults as null if p10SeasonDriverId is null',
    () {
      final GrandPrixResultsDto grandPrixResultsDto = GrandPrixResultsDto(
        id: id,
        grandPrixId: seasonGrandPrixId,
        qualiStandingsBySeasonDriverIds: qualiStandingsBySeasonDriverIds,
        p1SeasonDriverId: p1SeasonDriverId,
        p2SeasonDriverId: p2SeasonDriverId,
        p3SeasonDriverId: p3SeasonDriverId,
        p10SeasonDriverId: null,
        fastestLapSeasonDriverId: fastestLapSeasonDriverId,
        dnfSeasonDriverIds: dnfSeasonDriverIds,
        wasThereSafetyCar: wasThereSafetyCar,
        wasThereRedFlag: wasThereRedFlag,
      );
      final GrandPrixResults expectedGrandPrixResults = GrandPrixResults(
        id: id,
        seasonGrandPrixId: seasonGrandPrixId,
        qualiStandingsBySeasonDriverIds: qualiStandingsBySeasonDriverIds,
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
    'should set raceResults as null if fastestLapSeasonDriverId is null',
    () {
      final GrandPrixResultsDto grandPrixResultsDto = GrandPrixResultsDto(
        id: id,
        grandPrixId: seasonGrandPrixId,
        qualiStandingsBySeasonDriverIds: qualiStandingsBySeasonDriverIds,
        p1SeasonDriverId: p1SeasonDriverId,
        p2SeasonDriverId: p2SeasonDriverId,
        p3SeasonDriverId: p3SeasonDriverId,
        p10SeasonDriverId: p10SeasonDriverId,
        fastestLapSeasonDriverId: null,
        dnfSeasonDriverIds: dnfSeasonDriverIds,
        wasThereSafetyCar: wasThereSafetyCar,
        wasThereRedFlag: wasThereRedFlag,
      );
      final GrandPrixResults expectedGrandPrixResults = GrandPrixResults(
        id: id,
        seasonGrandPrixId: seasonGrandPrixId,
        qualiStandingsBySeasonDriverIds: qualiStandingsBySeasonDriverIds,
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
    'should set raceResults as null if dnfSeasonDriverIds param is null',
    () {
      final GrandPrixResultsDto grandPrixResultsDto = GrandPrixResultsDto(
        id: id,
        grandPrixId: seasonGrandPrixId,
        qualiStandingsBySeasonDriverIds: qualiStandingsBySeasonDriverIds,
        p1SeasonDriverId: p1SeasonDriverId,
        p2SeasonDriverId: p2SeasonDriverId,
        p3SeasonDriverId: p3SeasonDriverId,
        p10SeasonDriverId: p10SeasonDriverId,
        fastestLapSeasonDriverId: fastestLapSeasonDriverId,
        dnfSeasonDriverIds: null,
        wasThereSafetyCar: wasThereSafetyCar,
        wasThereRedFlag: wasThereRedFlag,
      );
      final GrandPrixResults expectedGrandPrixResults = GrandPrixResults(
        id: id,
        seasonGrandPrixId: seasonGrandPrixId,
        qualiStandingsBySeasonDriverIds: qualiStandingsBySeasonDriverIds,
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
    'should set raceResults as null if wasThereSafetyCar is null',
    () {
      final GrandPrixResultsDto grandPrixResultsDto = GrandPrixResultsDto(
        id: id,
        grandPrixId: seasonGrandPrixId,
        qualiStandingsBySeasonDriverIds: qualiStandingsBySeasonDriverIds,
        p1SeasonDriverId: p1SeasonDriverId,
        p2SeasonDriverId: p2SeasonDriverId,
        p3SeasonDriverId: p3SeasonDriverId,
        p10SeasonDriverId: p10SeasonDriverId,
        fastestLapSeasonDriverId: fastestLapSeasonDriverId,
        dnfSeasonDriverIds: dnfSeasonDriverIds,
        wasThereSafetyCar: null,
        wasThereRedFlag: wasThereRedFlag,
      );
      final GrandPrixResults expectedGrandPrixResults = GrandPrixResults(
        id: id,
        seasonGrandPrixId: seasonGrandPrixId,
        qualiStandingsBySeasonDriverIds: qualiStandingsBySeasonDriverIds,
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
    'should set raceResults as null if wasThereRedFlag is null',
    () {
      final GrandPrixResultsDto grandPrixResultsDto = GrandPrixResultsDto(
        id: id,
        grandPrixId: seasonGrandPrixId,
        qualiStandingsBySeasonDriverIds: qualiStandingsBySeasonDriverIds,
        p1SeasonDriverId: p1SeasonDriverId,
        p2SeasonDriverId: p2SeasonDriverId,
        p3SeasonDriverId: p3SeasonDriverId,
        p10SeasonDriverId: p10SeasonDriverId,
        fastestLapSeasonDriverId: fastestLapSeasonDriverId,
        dnfSeasonDriverIds: dnfSeasonDriverIds,
        wasThereSafetyCar: wasThereSafetyCar,
        wasThereRedFlag: null,
      );
      final GrandPrixResults expectedGrandPrixResults = GrandPrixResults(
        id: id,
        seasonGrandPrixId: seasonGrandPrixId,
        qualiStandingsBySeasonDriverIds: qualiStandingsBySeasonDriverIds,
        raceResults: null,
      );

      final GrandPrixResults grandPrixResults = mapper.mapFromDto(
        grandPrixResultsDto,
      );

      expect(grandPrixResults, expectedGrandPrixResults);
    },
  );
}
