import 'package:betgrid/ui/screen/stats/stats_maker/players_podium_maker.dart';
import 'package:betgrid/ui/screen/stats/stats_model/players_podium.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../creator/grand_prix_bet_points_creator.dart';
import '../../../creator/player_creator.dart';

void main() {
  const maker = PlayersPodiumMaker();

  test(
    'prepareStats, '
    'list of players is empty, '
    'should throw exception',
    () {
      const String expectedException =
          '[PlayersPodiumMaker] List of players is empty';

      Object? exception;
      try {
        maker.prepareStats(
          players: [],
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
    'list of grand prix bets points is empty, '
    'should return null',
    () {
      final players = [
        createPlayer(id: 'p1'),
      ];

      final playersPodium = maker.prepareStats(
        players: players,
        grandPrixBetsPoints: [],
      );

      expect(playersPodium, null);
    },
  );

  test(
    'prepareStats, '
    'there is only 1 player, '
    'should sum player total points for each grand prix and should return '
    'only p1 position',
    () {
      final players = [
        createPlayer(id: 'p1'),
      ];
      final grandPrixBetsPoints = [
        createGrandPrixBetPoints(playerId: 'p1', totalPoints: 15),
        createGrandPrixBetPoints(playerId: 'p2', totalPoints: 12.5),
        createGrandPrixBetPoints(playerId: 'p1', totalPoints: 10),
        createGrandPrixBetPoints(playerId: 'p2', totalPoints: 7.5),
      ];
      final expectedPlayersPodium = PlayersPodium(
        p1Player: PlayersPodiumPlayer(
          player: createPlayer(id: 'p1'),
          points: 25,
        ),
      );

      final playersPodium = maker.prepareStats(
        players: players,
        grandPrixBetsPoints: grandPrixBetsPoints,
      );

      expect(playersPodium, expectedPlayersPodium);
    },
  );

  test(
    'prepareStats, '
    'there are only 2 players, '
    'should sum each player total points for each grand prix and should return '
    'p1 and p2 positions',
    () {
      final players = [
        createPlayer(id: 'p1'),
        createPlayer(id: 'p2'),
      ];
      final grandPrixBetsPoints = [
        createGrandPrixBetPoints(playerId: 'p1', totalPoints: 15),
        createGrandPrixBetPoints(playerId: 'p2', totalPoints: 12.5),
        createGrandPrixBetPoints(playerId: 'p1', totalPoints: 10),
        createGrandPrixBetPoints(playerId: 'p2', totalPoints: 7.5),
      ];
      final expectedPlayersPodium = PlayersPodium(
        p1Player: PlayersPodiumPlayer(
          player: createPlayer(id: 'p1'),
          points: 25,
        ),
        p2Player: PlayersPodiumPlayer(
          player: createPlayer(id: 'p2'),
          points: 20,
        ),
      );

      final playersPodium = maker.prepareStats(
        players: players,
        grandPrixBetsPoints: grandPrixBetsPoints,
      );

      expect(playersPodium, expectedPlayersPodium);
    },
  );

  test(
    'prepareStats, '
    'should sum each player total points for each grand prix and should return '
    'top 3 players',
    () {
      final players = [
        createPlayer(id: 'p1'),
        createPlayer(id: 'p2'),
        createPlayer(id: 'p3'),
        createPlayer(id: 'p4'),
      ];
      final grandPrixBetsPoints = [
        createGrandPrixBetPoints(playerId: 'p1', totalPoints: 15),
        createGrandPrixBetPoints(playerId: 'p2', totalPoints: 12.5),
        createGrandPrixBetPoints(playerId: 'p3', totalPoints: 22.22),
        createGrandPrixBetPoints(playerId: 'p4', totalPoints: 14.99),
        createGrandPrixBetPoints(playerId: 'p1', totalPoints: 10),
        createGrandPrixBetPoints(playerId: 'p2', totalPoints: 7.5),
        createGrandPrixBetPoints(playerId: 'p3', totalPoints: 17.22),
        createGrandPrixBetPoints(playerId: 'p4', totalPoints: 9.99),
      ];
      final expectedPlayersPodium = PlayersPodium(
        p1Player: PlayersPodiumPlayer(
          player: createPlayer(id: 'p3'),
          points: 39.44,
        ),
        p2Player: PlayersPodiumPlayer(
          player: createPlayer(id: 'p1'),
          points: 25,
        ),
        p3Player: PlayersPodiumPlayer(
          player: createPlayer(id: 'p4'),
          points: 24.98,
        ),
      );

      final playersPodium = maker.prepareStats(
        players: players,
        grandPrixBetsPoints: grandPrixBetsPoints,
      );

      expect(playersPodium, expectedPlayersPodium);
    },
  );
}
