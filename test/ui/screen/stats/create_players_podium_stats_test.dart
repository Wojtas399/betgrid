import 'package:betgrid/model/season_grand_prix_bet_points.dart';
import 'package:betgrid/model/player.dart';
import 'package:betgrid/model/season_grand_prix.dart';
import 'package:betgrid/ui/screen/stats/stats_creator/create_players_podium_stats.dart';
import 'package:betgrid/ui/screen/stats/stats_model/players_podium.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/season_grand_prix_bet_points_creator.dart';
import '../../../creator/player_creator.dart';
import '../../../creator/season_grand_prix_creator.dart';
import '../../../mock/repository/mock_season_grand_prix_bet_points_repository.dart';
import '../../../mock/repository/mock_player_repository.dart';
import '../../../mock/use_case/mock_get_finished_grand_prixes_from_season_use_case.dart';

void main() {
  final playerRepository = MockPlayerRepository();
  final getFinishedGrandPrixesFromSeasonUseCase =
      MockGetFinishedGrandPrixesFromSeasonUseCase();
  final seasonGrandPrixBetPointsRepository =
      MockSeasonGrandPrixBetPointsRepository();
  const int season = 2025;

  late CreatePlayersPodiumStats createPlayersPodiumStats;

  setUp(() {
    createPlayersPodiumStats = CreatePlayersPodiumStats(
      playerRepository,
      getFinishedGrandPrixesFromSeasonUseCase,
      seasonGrandPrixBetPointsRepository,
    );
  });

  tearDown(() {
    verify(playerRepository.getAll).called(1);
    verify(
      () => getFinishedGrandPrixesFromSeasonUseCase.call(season: season),
    ).called(1);
    reset(playerRepository);
    reset(getFinishedGrandPrixesFromSeasonUseCase);
    reset(seasonGrandPrixBetPointsRepository);
  });

  test('should emit null if list of all players is empty', () async {
    playerRepository.mockGetAll(players: []);
    getFinishedGrandPrixesFromSeasonUseCase.mock(
      finishedSeasonGrandPrixes: [
        SeasonGrandPrixCreator(id: 'sgp1').create(),
        SeasonGrandPrixCreator(id: 'sgp2').create(),
      ],
    );

    final Stream<PlayersPodium?> playersPodium$ = createPlayersPodiumStats(
      season: season,
    );

    expect(await playersPodium$.first, null);
  });

  test('should emit null if list of finished grand prixes is empty', () async {
    playerRepository.mockGetAll(
      players: [
        const PlayerCreator(id: 'p1').create(),
        const PlayerCreator(id: 'p2').create(),
      ],
    );
    getFinishedGrandPrixesFromSeasonUseCase.mock(finishedSeasonGrandPrixes: []);

    final Stream<PlayersPodium?> playersPodium$ = createPlayersPodiumStats(
      season: season,
    );

    expect(await playersPodium$.first, null);
  });

  test('should sum player total points for each grand prix and should emit '
      'only p1 position if there is only 1 player', () async {
    final List<Player> players = [const PlayerCreator(id: 'p1').create()];
    final List<SeasonGrandPrix> finishedSeasonGrandPrixes = [
      SeasonGrandPrixCreator(id: 'sgp1').create(),
      SeasonGrandPrixCreator(id: 'sgp2').create(),
    ];
    final List<SeasonGrandPrixBetPoints> grandPrixesBetPoints = [
      SeasonGrandPrixBetPointsCreator(
        playerId: players.first.id,
        totalPoints: 15,
      ).create(),
      SeasonGrandPrixBetPointsCreator(
        playerId: players.first.id,
        totalPoints: 10,
      ).create(),
    ];
    final PlayersPodium expectedPlayersPodium = PlayersPodium(
      p1Player: PlayersPodiumPlayer(player: players.first, points: 25),
    );
    playerRepository.mockGetAll(players: players);
    getFinishedGrandPrixesFromSeasonUseCase.mock(
      finishedSeasonGrandPrixes: finishedSeasonGrandPrixes,
    );
    seasonGrandPrixBetPointsRepository
        .mockGetSeasonGrandPrixBetPointsForPlayersAndSeasonGrandPrixes(
          seasonGrandPrixesBetPoints: grandPrixesBetPoints,
        );

    final Stream<PlayersPodium?> playersPodium$ = createPlayersPodiumStats(
      season: season,
    );

    expect(await playersPodium$.first, expectedPlayersPodium);
    verify(
      () => seasonGrandPrixBetPointsRepository
          .getSeasonGrandPrixBetPointsForPlayersAndSeasonGrandPrixes(
            season: season,
            idsOfPlayers: players.map((player) => player.id).toList(),
            idsOfSeasonGrandPrixes:
                finishedSeasonGrandPrixes.map((gp) => gp.id).toList(),
          ),
    ).called(1);
  });

  test(
    'should sum each player total points for each grand prix and should return '
    'p1 and p2 positions if there are only 2 players',
    () async {
      final List<Player> players = [
        const PlayerCreator(id: 'p1').create(),
        const PlayerCreator(id: 'p2').create(),
      ];
      final List<SeasonGrandPrix> finishedSeasonGrandPrixes = [
        SeasonGrandPrixCreator(id: 'sgp1').create(),
        SeasonGrandPrixCreator(id: 'sgp2').create(),
      ];
      final List<SeasonGrandPrixBetPoints> grandPrixesBetPoints = [
        SeasonGrandPrixBetPointsCreator(
          playerId: players.first.id,
          totalPoints: 15,
        ).create(),
        SeasonGrandPrixBetPointsCreator(
          playerId: players.last.id,
          totalPoints: 12.5,
        ).create(),
        SeasonGrandPrixBetPointsCreator(
          playerId: players.first.id,
          totalPoints: 10,
        ).create(),
        SeasonGrandPrixBetPointsCreator(
          playerId: players.last.id,
          totalPoints: 7.5,
        ).create(),
      ];
      final PlayersPodium expectedPlayersPodium = PlayersPodium(
        p1Player: PlayersPodiumPlayer(player: players.first, points: 25),
        p2Player: PlayersPodiumPlayer(player: players.last, points: 20),
      );
      playerRepository.mockGetAll(players: players);
      getFinishedGrandPrixesFromSeasonUseCase.mock(
        finishedSeasonGrandPrixes: finishedSeasonGrandPrixes,
      );
      seasonGrandPrixBetPointsRepository
          .mockGetSeasonGrandPrixBetPointsForPlayersAndSeasonGrandPrixes(
            seasonGrandPrixesBetPoints: grandPrixesBetPoints,
          );

      final Stream<PlayersPodium?> playersPodium$ = createPlayersPodiumStats(
        season: season,
      );

      expect(await playersPodium$.first, expectedPlayersPodium);
      verify(
        () => seasonGrandPrixBetPointsRepository
            .getSeasonGrandPrixBetPointsForPlayersAndSeasonGrandPrixes(
              season: season,
              idsOfPlayers: players.map((player) => player.id).toList(),
              idsOfSeasonGrandPrixes:
                  finishedSeasonGrandPrixes.map((gp) => gp.id).toList(),
            ),
      ).called(1);
    },
  );

  test(
    'should sum each player total points for each grand prix and should return '
    'top 3 players',
    () async {
      final List<Player> players = [
        const PlayerCreator(id: 'p1').create(),
        const PlayerCreator(id: 'p2').create(),
        const PlayerCreator(id: 'p3').create(),
        const PlayerCreator(id: 'p4').create(),
      ];
      final List<SeasonGrandPrix> finishedSeasonGrandPrixes = [
        SeasonGrandPrixCreator(id: 'sgp1').create(),
        SeasonGrandPrixCreator(id: 'sgp2').create(),
      ];
      final List<SeasonGrandPrixBetPoints> grandPrixesBetPoints = [
        SeasonGrandPrixBetPointsCreator(
          playerId: players.first.id,
          totalPoints: 15,
        ).create(),
        SeasonGrandPrixBetPointsCreator(
          playerId: players[1].id,
          totalPoints: 12.5,
        ).create(),
        SeasonGrandPrixBetPointsCreator(
          playerId: players[2].id,
          totalPoints: 22.22,
        ).create(),
        SeasonGrandPrixBetPointsCreator(
          playerId: players.last.id,
          totalPoints: 14.99,
        ).create(),
        SeasonGrandPrixBetPointsCreator(
          playerId: players.first.id,
          totalPoints: 10,
        ).create(),
        SeasonGrandPrixBetPointsCreator(
          playerId: players[1].id,
          totalPoints: 7.5,
        ).create(),
        SeasonGrandPrixBetPointsCreator(
          playerId: players[2].id,
          totalPoints: 17.22,
        ).create(),
        SeasonGrandPrixBetPointsCreator(
          playerId: players.last.id,
          totalPoints: 9.99,
        ).create(),
      ];
      final PlayersPodium expectedPlayersPodium = PlayersPodium(
        p1Player: PlayersPodiumPlayer(player: players[2], points: 39.44),
        p2Player: PlayersPodiumPlayer(player: players.first, points: 25),
        p3Player: PlayersPodiumPlayer(player: players.last, points: 24.98),
      );
      playerRepository.mockGetAll(players: players);
      getFinishedGrandPrixesFromSeasonUseCase.mock(
        finishedSeasonGrandPrixes: finishedSeasonGrandPrixes,
      );
      seasonGrandPrixBetPointsRepository
          .mockGetSeasonGrandPrixBetPointsForPlayersAndSeasonGrandPrixes(
            seasonGrandPrixesBetPoints: grandPrixesBetPoints,
          );

      final Stream<PlayersPodium?> playersPodium$ = createPlayersPodiumStats(
        season: season,
      );

      expect(await playersPodium$.first, expectedPlayersPodium);
      verify(
        () => seasonGrandPrixBetPointsRepository
            .getSeasonGrandPrixBetPointsForPlayersAndSeasonGrandPrixes(
              season: season,
              idsOfPlayers: players.map((player) => player.id).toList(),
              idsOfSeasonGrandPrixes:
                  finishedSeasonGrandPrixes.map((gp) => gp.id).toList(),
            ),
      ).called(1);
    },
  );
}
