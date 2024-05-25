import 'package:betgrid/ui/screen/stats/stats_maker/points_for_driver_maker.dart';
import 'package:betgrid/ui/screen/stats/stats_model/points_by_driver.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../creator/grand_prix_bet_creator.dart';
import '../../../creator/grand_prix_bet_points_creator.dart';
import '../../../creator/grand_prix_results_creator.dart';
import '../../../creator/player_creator.dart';
import '../../../creator/quali_bet_points_creator.dart';
import '../../../creator/race_bet_points_creator.dart';

void main() {
  const maker = PointsForDriverMaker();

  test(
    'prepareStats, '
    'list of players is empty, '
    'should throw exception',
    () {
      const String expectedException =
          '[PointsForDriverMaker] List of players is empty';

      Object? exception;
      try {
        maker.prepareStats(
          driverId: 'd1',
          players: [],
          grandPrixesIds: [],
          grandPrixesResults: [],
          grandPrixesBetPoints: [],
          grandPrixesBets: [],
        );
      } catch (e) {
        exception = e;
      }

      expect(exception, expectedException);
    },
  );

  test(
    'prepareStats, '
    'list of ids of grand prixes is empty, '
    'should return null',
    () {
      final players = [
        createPlayer(id: 'p1'),
      ];

      final pointsForDriver = maker.prepareStats(
        driverId: 'd1',
        players: players,
        grandPrixesIds: [],
        grandPrixesResults: [],
        grandPrixesBetPoints: [],
        grandPrixesBets: [],
      );

      expect(pointsForDriver, null);
    },
  );

  test(
    'prepareStats, '
    'for each player should sum points received for driver in every grand prix',
    () {
      const String driverId = 'd1';
      final players = [
        createPlayer(id: 'p1'),
        createPlayer(id: 'p2'),
        createPlayer(id: 'p3'),
      ];
      final grandPrixesIds = ['gp1', 'gp2', 'gp3'];
      final grandPrixesResults = [
        createGrandPrixResults(
          grandPrixId: 'gp1',
          qualiStandingsByDriverIds: [
            driverId,
            'd2',
            'd3',
            'd4',
            'd5',
            'd6',
            'd7',
            'd8',
            'd9',
            'd10',
            'd11',
            'd12',
            'd13',
            'd14',
            'd15',
            'd16',
            'd17',
            'd18',
            'd19',
            'd20',
          ],
          raceResults: createRaceResults(
            p1DriverId: driverId,
            p2DriverId: 'd2',
            p3DriverId: 'd3',
            p10DriverId: 'd10',
            fastestLapDriverId: driverId,
            dnfDriverIds: ['d18', 'd19', 'd20'],
          ),
        ),
        createGrandPrixResults(
          grandPrixId: 'gp2',
          qualiStandingsByDriverIds: [
            'd20',
            'd19',
            'd18',
            'd17',
            'd16',
            'd15',
            'd14',
            'd13',
            'd12',
            'd11',
            'd10',
            driverId,
            'd8',
            'd7',
            'd6',
            'd5',
            'd4',
            'd3',
            'd2',
            'd9',
          ],
          raceResults: createRaceResults(
            p1DriverId: 'd20',
            p2DriverId: 'd19',
            p3DriverId: 'd18',
            p10DriverId: 'd11',
            fastestLapDriverId: 'd20',
            dnfDriverIds: [driverId, 'd2'],
          ),
        ),
        createGrandPrixResults(
          grandPrixId: 'gp3',
          qualiStandingsByDriverIds: [
            'd20',
            'd11',
            'd2',
            'd12',
            'd3',
            'd13',
            'd4',
            'd14',
            'd5',
            'd15',
            'd6',
            'd16',
            'd7',
            'd17',
            'd8',
            'd18',
            'd9',
            'd19',
            'd10',
            driverId,
          ],
          raceResults: createRaceResults(
            p1DriverId: 'd3',
            p2DriverId: 'd2',
            p3DriverId: driverId,
            p10DriverId: 'd4',
            fastestLapDriverId: 'd3',
            dnfDriverIds: [driverId],
          ),
        ),
      ];
      final grandPrixesBetPoints = [
        createGrandPrixBetPoints(
          playerId: 'p1',
          grandPrixId: 'gp1',
          qualiBetPoints: createQualiBetPoints(q3P1Points: 1),
          raceBetPoints: createRaceBetPoints(p1Points: 2, fastestLapPoints: 2),
        ),
        createGrandPrixBetPoints(
          playerId: 'p1',
          grandPrixId: 'gp2',
          qualiBetPoints: createQualiBetPoints(q1P20Points: 1),
          raceBetPoints: createRaceBetPoints(dnfDriver1Points: 2),
        ),
        createGrandPrixBetPoints(
          playerId: 'p1',
          grandPrixId: 'gp3',
          qualiBetPoints: createQualiBetPoints(q3P1Points: 1),
          raceBetPoints: createRaceBetPoints(p3Points: 2),
        ),
        createGrandPrixBetPoints(
          playerId: 'p2',
          grandPrixId: 'gp1',
          qualiBetPoints: createQualiBetPoints(q3P4Points: 2),
          raceBetPoints: createRaceBetPoints(
            p2Points: 2,
            p10Points: 2,
            fastestLapPoints: 2,
          ),
        ),
        createGrandPrixBetPoints(
          playerId: 'p2',
          grandPrixId: 'gp2',
          qualiBetPoints: createQualiBetPoints(q2P12Points: 2),
        ),
        createGrandPrixBetPoints(
          playerId: 'p2',
          grandPrixId: 'gp3',
          qualiBetPoints: createQualiBetPoints(q3P1Points: 1),
          raceBetPoints: createRaceBetPoints(p3Points: 2),
        ),
        createGrandPrixBetPoints(
          playerId: 'p3',
          grandPrixId: 'gp1',
          qualiBetPoints: createQualiBetPoints(q3P10Points: 1),
        ),
        createGrandPrixBetPoints(
          playerId: 'p3',
          grandPrixId: 'gp2',
          qualiBetPoints: createQualiBetPoints(q1P18Points: 1),
        ),
        createGrandPrixBetPoints(
          playerId: 'p3',
          grandPrixId: 'gp3',
          qualiBetPoints: createQualiBetPoints(q3P5Points: 2),
          raceBetPoints: createRaceBetPoints(p2Points: 2, dnfDriver1Points: 2),
        ),
      ];
      final grandPrixesBets = [
        createGrandPrixBet(
          playerId: 'p1',
          grandPrixId: 'gp1',
          dnfDriverIds: [driverId, 'd2', 'd3'],
        ),
        createGrandPrixBet(
          playerId: 'p1',
          grandPrixId: 'gp2',
          dnfDriverIds: [driverId, null, null],
        ),
        createGrandPrixBet(
          playerId: 'p1',
          grandPrixId: 'gp3',
          dnfDriverIds: [driverId, 'd2', null],
        ),
        createGrandPrixBet(
          playerId: 'p2',
          grandPrixId: 'gp1',
          dnfDriverIds: [driverId, 'd2', 'd20'],
        ),
        createGrandPrixBet(
          playerId: 'p2',
          grandPrixId: 'gp2',
          dnfDriverIds: [null, null, null],
        ),
        createGrandPrixBet(
          playerId: 'p2',
          grandPrixId: 'gp3',
          dnfDriverIds: ['d14', 'd15', null],
        ),
        createGrandPrixBet(playerId: 'p3', grandPrixId: 'gp1'),
        createGrandPrixBet(playerId: 'p3', grandPrixId: 'gp2'),
        createGrandPrixBet(
          playerId: 'p3',
          grandPrixId: 'gp3',
          dnfDriverIds: [driverId, 'd15', 'd18'],
        ),
      ];
      final expectedPointsForDriver = [
        PointsByDriverPlayerPoints(
          player: createPlayer(id: 'p1'),
          points: 9,
        ),
        PointsByDriverPlayerPoints(
          player: createPlayer(id: 'p2'),
          points: 6,
        ),
        PointsByDriverPlayerPoints(
          player: createPlayer(id: 'p3'),
          points: 2,
        ),
      ];

      final pointsForDriver = maker.prepareStats(
        driverId: driverId,
        players: players,
        grandPrixesIds: grandPrixesIds,
        grandPrixesResults: grandPrixesResults,
        grandPrixesBetPoints: grandPrixesBetPoints,
        grandPrixesBets: grandPrixesBets,
      );

      expect(pointsForDriver, expectedPointsForDriver);
    },
  );
}
