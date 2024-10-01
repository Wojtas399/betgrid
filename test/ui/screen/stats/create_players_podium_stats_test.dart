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
import '../../../mock/use_case/mock_get_finished_grand_prixes_use_case.dart';

void main() {
  final playerRepository = MockPlayerRepository();
  final getFinishedGrandPrixesUseCase = MockGetFinishedGrandPrixesUseCase();
  final grandPrixBetPointsRepository = MockGrandPrixBetPointsRepository();
  late CreatePlayersPodiumStats createPlayersPodiumStats;

  setUp(() {
    createPlayersPodiumStats = CreatePlayersPodiumStats(
      playerRepository,
      getFinishedGrandPrixesUseCase,
      grandPrixBetPointsRepository,
    );
  });

  tearDown(() {
    reset(playerRepository);
    reset(getFinishedGrandPrixesUseCase);
    reset(grandPrixBetPointsRepository);
  });

  test(
    'list of all players is empty, '
    'should emit null',
    () async {
      playerRepository.mockGetAllPlayers(players: []);
      getFinishedGrandPrixesUseCase.mock(
        finishedGrandPrixes: [
          GrandPrixCreator(id: 'gp1').createEntity(),
          GrandPrixCreator(id: 'gp2').createEntity(),
        ],
      );

      final Stream<PlayersPodium?> playersPodium$ = createPlayersPodiumStats();

      expect(await playersPodium$.first, null);
      verify(playerRepository.getAllPlayers).called(1);
      verify(getFinishedGrandPrixesUseCase.call).called(1);
    },
  );

  test(
    'list of finished grand prixes is empty, '
    'should emit null',
    () async {
      playerRepository.mockGetAllPlayers(
        players: [
          PlayerCreator(id: 'p1').createEntity(),
          PlayerCreator(id: 'p2').createEntity(),
        ],
      );
      getFinishedGrandPrixesUseCase.mock(finishedGrandPrixes: []);

      final Stream<PlayersPodium?> playersPodium$ = createPlayersPodiumStats();

      expect(await playersPodium$.first, null);
      verify(playerRepository.getAllPlayers).called(1);
      verify(getFinishedGrandPrixesUseCase.call).called(1);
    },
  );

  test(
    'there is only 1 player, '
    'should sum player total points for each grand prix and should emit '
    'only p1 position',
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
          playerId: 'p1',
          totalPoints: 15,
        ).createEntity(),
        GrandPrixBetPointsCreator(
          playerId: 'p2',
          totalPoints: 12.5,
        ).createEntity(),
        GrandPrixBetPointsCreator(
          playerId: 'p1',
          totalPoints: 10,
        ).createEntity(),
        GrandPrixBetPointsCreator(
          playerId: 'p2',
          totalPoints: 7.5,
        ).createEntity(),
      ];
      final PlayersPodium expectedPlayersPodium = PlayersPodium(
        p1Player: PlayersPodiumPlayer(
          player: PlayerCreator(id: 'p1').createEntity(),
          points: 25,
        ),
      );
      playerRepository.mockGetAllPlayers(players: players);
      getFinishedGrandPrixesUseCase.mock(
        finishedGrandPrixes: finishedGrandPrixes,
      );
      grandPrixBetPointsRepository
          .mockGetGrandPrixBetPointsForPlayersAndGrandPrixes(
        grandPrixesBetPoints: grandPrixesBetPoints,
      );

      final Stream<PlayersPodium?> playersPodium$ = createPlayersPodiumStats();

      expect(await playersPodium$.first, expectedPlayersPodium);
      verify(playerRepository.getAllPlayers).called(1);
      verify(getFinishedGrandPrixesUseCase.call).called(1);
      verify(
        () => grandPrixBetPointsRepository
            .getGrandPrixBetPointsForPlayersAndGrandPrixes(
          idsOfPlayers: ['p1'],
          idsOfGrandPrixes: ['gp1', 'gp2'],
        ),
      ).called(1);
    },
  );

  test(
    'there are only 2 players, '
    'should sum each player total points for each grand prix and should return '
    'p1 and p2 positions',
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
          playerId: 'p1',
          totalPoints: 15,
        ).createEntity(),
        GrandPrixBetPointsCreator(
          playerId: 'p2',
          totalPoints: 12.5,
        ).createEntity(),
        GrandPrixBetPointsCreator(
          playerId: 'p1',
          totalPoints: 10,
        ).createEntity(),
        GrandPrixBetPointsCreator(
          playerId: 'p2',
          totalPoints: 7.5,
        ).createEntity(),
      ];
      final PlayersPodium expectedPlayersPodium = PlayersPodium(
        p1Player: PlayersPodiumPlayer(
          player: PlayerCreator(id: 'p1').createEntity(),
          points: 25,
        ),
        p2Player: PlayersPodiumPlayer(
          player: PlayerCreator(id: 'p2').createEntity(),
          points: 20,
        ),
      );
      playerRepository.mockGetAllPlayers(players: players);
      getFinishedGrandPrixesUseCase.mock(
        finishedGrandPrixes: finishedGrandPrixes,
      );
      grandPrixBetPointsRepository
          .mockGetGrandPrixBetPointsForPlayersAndGrandPrixes(
        grandPrixesBetPoints: grandPrixesBetPoints,
      );

      final Stream<PlayersPodium?> playersPodium$ = createPlayersPodiumStats();

      expect(await playersPodium$.first, expectedPlayersPodium);
      verify(playerRepository.getAllPlayers).called(1);
      verify(getFinishedGrandPrixesUseCase.call).called(1);
      verify(
        () => grandPrixBetPointsRepository
            .getGrandPrixBetPointsForPlayersAndGrandPrixes(
          idsOfPlayers: ['p1', 'p2'],
          idsOfGrandPrixes: ['gp1', 'gp2'],
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
          playerId: 'p1',
          totalPoints: 15,
        ).createEntity(),
        GrandPrixBetPointsCreator(
          playerId: 'p2',
          totalPoints: 12.5,
        ).createEntity(),
        GrandPrixBetPointsCreator(
          playerId: 'p3',
          totalPoints: 22.22,
        ).createEntity(),
        GrandPrixBetPointsCreator(
          playerId: 'p4',
          totalPoints: 14.99,
        ).createEntity(),
        GrandPrixBetPointsCreator(
          playerId: 'p1',
          totalPoints: 10,
        ).createEntity(),
        GrandPrixBetPointsCreator(
          playerId: 'p2',
          totalPoints: 7.5,
        ).createEntity(),
        GrandPrixBetPointsCreator(
          playerId: 'p3',
          totalPoints: 17.22,
        ).createEntity(),
        GrandPrixBetPointsCreator(
          playerId: 'p4',
          totalPoints: 9.99,
        ).createEntity(),
      ];
      final PlayersPodium expectedPlayersPodium = PlayersPodium(
        p1Player: PlayersPodiumPlayer(
          player: PlayerCreator(id: 'p3').createEntity(),
          points: 39.44,
        ),
        p2Player: PlayersPodiumPlayer(
          player: PlayerCreator(id: 'p1').createEntity(),
          points: 25,
        ),
        p3Player: PlayersPodiumPlayer(
          player: PlayerCreator(id: 'p4').createEntity(),
          points: 24.98,
        ),
      );
      playerRepository.mockGetAllPlayers(players: players);
      getFinishedGrandPrixesUseCase.mock(
        finishedGrandPrixes: finishedGrandPrixes,
      );
      grandPrixBetPointsRepository
          .mockGetGrandPrixBetPointsForPlayersAndGrandPrixes(
        grandPrixesBetPoints: grandPrixesBetPoints,
      );

      final Stream<PlayersPodium?> playersPodium$ = createPlayersPodiumStats();

      expect(await playersPodium$.first, expectedPlayersPodium);
      verify(playerRepository.getAllPlayers).called(1);
      verify(getFinishedGrandPrixesUseCase.call).called(1);
      verify(
        () => grandPrixBetPointsRepository
            .getGrandPrixBetPointsForPlayersAndGrandPrixes(
          idsOfPlayers: ['p1', 'p2', 'p3', 'p4'],
          idsOfGrandPrixes: ['gp1', 'gp2'],
        ),
      ).called(1);
    },
  );
}
