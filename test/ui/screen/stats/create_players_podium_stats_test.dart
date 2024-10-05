import 'package:betgrid/model/grand_prix.dart';
import 'package:betgrid/model/grand_prix_bet_points.dart';
import 'package:betgrid/model/player.dart';
import 'package:betgrid/ui/screen/stats/stats_creator/create_players_podium_stats.dart';
import 'package:betgrid/ui/screen/stats/stats_model/players_podium.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/grand_prix_bet_points_creator.dart';
import '../../../creator/grand_prix_creator.dart';
import '../../../creator/player_creator.dart';
import '../../../mock/data/repository/mock_grand_prix_bet_points_repository.dart';
import '../../../mock/data/repository/mock_player_repository.dart';
import '../../../mock/use_case/mock_get_finished_grand_prixes_from_current_season_use_case.dart';

void main() {
  final playerRepository = MockPlayerRepository();
  final getFinishedGrandPrixesFromCurrentSeasonUseCase =
      MockGetFinishedGrandPrixesFromCurrentSeasonUseCase();
  final grandPrixBetPointsRepository = MockGrandPrixBetPointsRepository();
  late CreatePlayersPodiumStats createPlayersPodiumStats;

  setUp(() {
    createPlayersPodiumStats = CreatePlayersPodiumStats(
      playerRepository,
      getFinishedGrandPrixesFromCurrentSeasonUseCase,
      grandPrixBetPointsRepository,
    );
  });

  tearDown(() {
    reset(playerRepository);
    reset(getFinishedGrandPrixesFromCurrentSeasonUseCase);
    reset(grandPrixBetPointsRepository);
  });

  test(
    'should emit null if list of all players is empty',
    () async {
      playerRepository.mockGetAllPlayers(players: []);
      getFinishedGrandPrixesFromCurrentSeasonUseCase.mock(
        finishedGrandPrixes: [
          GrandPrixCreator(id: 'gp1').createEntity(),
          GrandPrixCreator(id: 'gp2').createEntity(),
        ],
      );

      final Stream<PlayersPodium?> playersPodium$ = createPlayersPodiumStats();

      expect(await playersPodium$.first, null);
      verify(playerRepository.getAllPlayers).called(1);
      verify(getFinishedGrandPrixesFromCurrentSeasonUseCase.call).called(1);
    },
  );

  test(
    'should emit null if list of finished grand prixes is empty',
    () async {
      playerRepository.mockGetAllPlayers(
        players: [
          PlayerCreator(id: 'p1').createEntity(),
          PlayerCreator(id: 'p2').createEntity(),
        ],
      );
      getFinishedGrandPrixesFromCurrentSeasonUseCase
          .mock(finishedGrandPrixes: []);

      final Stream<PlayersPodium?> playersPodium$ = createPlayersPodiumStats();

      expect(await playersPodium$.first, null);
      verify(playerRepository.getAllPlayers).called(1);
      verify(getFinishedGrandPrixesFromCurrentSeasonUseCase.call).called(1);
    },
  );

  test(
    'should sum player total points for each grand prix and should emit '
    'only p1 position if there is only 1 player',
    () async {
      final List<Player> players = [
        PlayerCreator(id: 'p1').createEntity(),
      ];
      final List<GrandPrix> finishedGrandPrixes = [
        GrandPrixCreator(id: 'gp1').createEntity(),
        GrandPrixCreator(id: 'gp2').createEntity(),
      ];
      final List<GrandPrixBetPoints> grandPrixesBetPoints = [
        GrandPrixBetPointsCreator(
          playerId: players.first.id,
          totalPoints: 15,
        ).createEntity(),
        GrandPrixBetPointsCreator(
          playerId: players.first.id,
          totalPoints: 10,
        ).createEntity(),
      ];
      final PlayersPodium expectedPlayersPodium = PlayersPodium(
        p1Player: PlayersPodiumPlayer(
          player: players.first,
          points: 25,
        ),
      );
      playerRepository.mockGetAllPlayers(players: players);
      getFinishedGrandPrixesFromCurrentSeasonUseCase.mock(
        finishedGrandPrixes: finishedGrandPrixes,
      );
      grandPrixBetPointsRepository
          .mockGetGrandPrixBetPointsForPlayersAndGrandPrixes(
        grandPrixesBetPoints: grandPrixesBetPoints,
      );

      final Stream<PlayersPodium?> playersPodium$ = createPlayersPodiumStats();

      expect(await playersPodium$.first, expectedPlayersPodium);
      verify(playerRepository.getAllPlayers).called(1);
      verify(getFinishedGrandPrixesFromCurrentSeasonUseCase.call).called(1);
      verify(
        () => grandPrixBetPointsRepository
            .getGrandPrixBetPointsForPlayersAndGrandPrixes(
          idsOfPlayers: players.map((player) => player.id).toList(),
          idsOfGrandPrixes: finishedGrandPrixes.map((gp) => gp.id).toList(),
        ),
      ).called(1);
    },
  );

  test(
    'should sum each player total points for each grand prix and should return '
    'p1 and p2 positions if there are only 2 players',
    () async {
      final List<Player> players = [
        PlayerCreator(id: 'p1').createEntity(),
        PlayerCreator(id: 'p2').createEntity(),
      ];
      final List<GrandPrix> finishedGrandPrixes = [
        GrandPrixCreator(id: 'gp1').createEntity(),
        GrandPrixCreator(id: 'gp2').createEntity(),
      ];
      final List<GrandPrixBetPoints> grandPrixesBetPoints = [
        GrandPrixBetPointsCreator(
          playerId: players.first.id,
          totalPoints: 15,
        ).createEntity(),
        GrandPrixBetPointsCreator(
          playerId: players.last.id,
          totalPoints: 12.5,
        ).createEntity(),
        GrandPrixBetPointsCreator(
          playerId: players.first.id,
          totalPoints: 10,
        ).createEntity(),
        GrandPrixBetPointsCreator(
          playerId: players.last.id,
          totalPoints: 7.5,
        ).createEntity(),
      ];
      final PlayersPodium expectedPlayersPodium = PlayersPodium(
        p1Player: PlayersPodiumPlayer(
          player: players.first,
          points: 25,
        ),
        p2Player: PlayersPodiumPlayer(
          player: players.last,
          points: 20,
        ),
      );
      playerRepository.mockGetAllPlayers(players: players);
      getFinishedGrandPrixesFromCurrentSeasonUseCase.mock(
        finishedGrandPrixes: finishedGrandPrixes,
      );
      grandPrixBetPointsRepository
          .mockGetGrandPrixBetPointsForPlayersAndGrandPrixes(
        grandPrixesBetPoints: grandPrixesBetPoints,
      );

      final Stream<PlayersPodium?> playersPodium$ = createPlayersPodiumStats();

      expect(await playersPodium$.first, expectedPlayersPodium);
      verify(playerRepository.getAllPlayers).called(1);
      verify(getFinishedGrandPrixesFromCurrentSeasonUseCase.call).called(1);
      verify(
        () => grandPrixBetPointsRepository
            .getGrandPrixBetPointsForPlayersAndGrandPrixes(
          idsOfPlayers: players.map((player) => player.id).toList(),
          idsOfGrandPrixes: finishedGrandPrixes.map((gp) => gp.id).toList(),
        ),
      ).called(1);
    },
  );

  test(
    'should sum each player total points for each grand prix and should return '
    'top 3 players',
    () async {
      final List<Player> players = [
        PlayerCreator(id: 'p1').createEntity(),
        PlayerCreator(id: 'p2').createEntity(),
        PlayerCreator(id: 'p3').createEntity(),
        PlayerCreator(id: 'p4').createEntity(),
      ];
      final List<GrandPrix> finishedGrandPrixes = [
        GrandPrixCreator(id: 'gp1').createEntity(),
        GrandPrixCreator(id: 'gp2').createEntity(),
      ];
      final List<GrandPrixBetPoints> grandPrixesBetPoints = [
        GrandPrixBetPointsCreator(
          playerId: players.first.id,
          totalPoints: 15,
        ).createEntity(),
        GrandPrixBetPointsCreator(
          playerId: players[1].id,
          totalPoints: 12.5,
        ).createEntity(),
        GrandPrixBetPointsCreator(
          playerId: players[2].id,
          totalPoints: 22.22,
        ).createEntity(),
        GrandPrixBetPointsCreator(
          playerId: players.last.id,
          totalPoints: 14.99,
        ).createEntity(),
        GrandPrixBetPointsCreator(
          playerId: players.first.id,
          totalPoints: 10,
        ).createEntity(),
        GrandPrixBetPointsCreator(
          playerId: players[1].id,
          totalPoints: 7.5,
        ).createEntity(),
        GrandPrixBetPointsCreator(
          playerId: players[2].id,
          totalPoints: 17.22,
        ).createEntity(),
        GrandPrixBetPointsCreator(
          playerId: players.last.id,
          totalPoints: 9.99,
        ).createEntity(),
      ];
      final PlayersPodium expectedPlayersPodium = PlayersPodium(
        p1Player: PlayersPodiumPlayer(
          player: players[2],
          points: 39.44,
        ),
        p2Player: PlayersPodiumPlayer(
          player: players.first,
          points: 25,
        ),
        p3Player: PlayersPodiumPlayer(
          player: players.last,
          points: 24.98,
        ),
      );
      playerRepository.mockGetAllPlayers(players: players);
      getFinishedGrandPrixesFromCurrentSeasonUseCase.mock(
        finishedGrandPrixes: finishedGrandPrixes,
      );
      grandPrixBetPointsRepository
          .mockGetGrandPrixBetPointsForPlayersAndGrandPrixes(
        grandPrixesBetPoints: grandPrixesBetPoints,
      );

      final Stream<PlayersPodium?> playersPodium$ = createPlayersPodiumStats();

      expect(await playersPodium$.first, expectedPlayersPodium);
      verify(playerRepository.getAllPlayers).called(1);
      verify(getFinishedGrandPrixesFromCurrentSeasonUseCase.call).called(1);
      verify(
        () => grandPrixBetPointsRepository
            .getGrandPrixBetPointsForPlayersAndGrandPrixes(
          idsOfPlayers: players.map((player) => player.id).toList(),
          idsOfGrandPrixes: finishedGrandPrixes.map((gp) => gp.id).toList(),
        ),
      ).called(1);
    },
  );
}
