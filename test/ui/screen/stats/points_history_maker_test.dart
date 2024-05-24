import 'package:betgrid/ui/screen/stats/stats_maker/points_history_maker.dart';
import 'package:betgrid/ui/screen/stats/stats_model/points_history.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../creator/grand_prix_bet_points_creator.dart';
import '../../../creator/grand_prix_creator.dart';
import '../../../creator/player_creator.dart';

void main() {
  const maker = PointsHistoryMaker();

  test(
    'prepareStats, '
    'list of players is empty, '
    'should throw exception',
    () {
      const String expectedException =
          '[PointsHistoryMaker] List of players is empty';

      Object? exception;
      try {
        maker.prepareStats(
          players: [],
          finishedGrandPrixes: [],
          grandPrixBetsPoints: [],
        );
      } catch (e) {
        exception = e;
      }

      expect(exception, expectedException);
    },
  );

  test(
    'prepareStats, '
    'list of finished grand prixes is empty, '
    'should return null',
    () {
      final players = [
        createPlayer(id: 'p1'),
      ];

      final pointsHistory = maker.prepareStats(
        players: players,
        finishedGrandPrixes: [],
        grandPrixBetsPoints: [],
      );

      expect(pointsHistory, null);
    },
  );

  test(
    'prepareStats, '
    'for each player should create cumulative history of points gained for each '
    'grand prix',
    () {
      final players = [
        createPlayer(id: 'p1'),
        createPlayer(id: 'p2'),
        createPlayer(id: 'p3'),
      ];
      final finishedGrandPrixes = [
        createGrandPrix(id: 'gp1', roundNumber: 2),
        createGrandPrix(id: 'gp2', roundNumber: 3),
        createGrandPrix(id: 'gp3', roundNumber: 1),
      ];
      final grandPrixBetsPoints = [
        createGrandPrixBetPoints(
          playerId: 'p1',
          grandPrixId: 'gp1',
          totalPoints: 20,
        ),
        createGrandPrixBetPoints(
          playerId: 'p1',
          grandPrixId: 'gp2',
          totalPoints: 12.2,
        ),
        createGrandPrixBetPoints(
          playerId: 'p1',
          grandPrixId: 'gp3',
          totalPoints: 17,
        ),
        createGrandPrixBetPoints(
          playerId: 'p2',
          grandPrixId: 'gp1',
          totalPoints: 5.5,
        ),
        createGrandPrixBetPoints(
          playerId: 'p2',
          grandPrixId: 'gp2',
          totalPoints: 17,
        ),
        createGrandPrixBetPoints(
          playerId: 'p2',
          grandPrixId: 'gp3',
          totalPoints: 9,
        ),
        createGrandPrixBetPoints(
          playerId: 'p3',
          grandPrixId: 'gp1',
          totalPoints: 15,
        ),
        createGrandPrixBetPoints(
          playerId: 'p3',
          grandPrixId: 'gp2',
          totalPoints: 17,
        ),
      ];
      final PointsHistory expectedPointsHistory = PointsHistory(
        players: players,
        grandPrixes: const [
          PointsHistoryGrandPrix(
            roundNumber: 1,
            playersPoints: [
              PointsHistoryPlayerPoints(
                playerId: 'p1',
                points: 17,
              ),
              PointsHistoryPlayerPoints(
                playerId: 'p2',
                points: 9,
              ),
              PointsHistoryPlayerPoints(
                playerId: 'p3',
                points: 0,
              ),
            ],
          ),
          PointsHistoryGrandPrix(
            roundNumber: 2,
            playersPoints: [
              PointsHistoryPlayerPoints(
                playerId: 'p1',
                points: 37,
              ),
              PointsHistoryPlayerPoints(
                playerId: 'p2',
                points: 14.5,
              ),
              PointsHistoryPlayerPoints(
                playerId: 'p3',
                points: 15,
              ),
            ],
          ),
          PointsHistoryGrandPrix(
            roundNumber: 3,
            playersPoints: [
              PointsHistoryPlayerPoints(
                playerId: 'p1',
                points: 49.2,
              ),
              PointsHistoryPlayerPoints(
                playerId: 'p2',
                points: 31.5,
              ),
              PointsHistoryPlayerPoints(
                playerId: 'p3',
                points: 32,
              ),
            ],
          ),
        ],
      );

      final pointsHistory = maker.prepareStats(
        players: players,
        finishedGrandPrixes: finishedGrandPrixes,
        grandPrixBetsPoints: grandPrixBetsPoints,
      );

      expect(pointsHistory, expectedPointsHistory);
    },
  );
}
