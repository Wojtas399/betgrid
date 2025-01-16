import 'package:betgrid/model/grand_prix_bet_points.dart';
import 'package:betgrid/model/player.dart';
import 'package:betgrid/model/season_grand_prix.dart';
import 'package:betgrid/ui/screen/stats/stats_creator/create_points_history_stats.dart';
import 'package:betgrid/ui/screen/stats/stats_model/points_history.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/grand_prix_bet_points_creator.dart';
import '../../../creator/player_creator.dart';
import '../../../creator/season_grand_prix_creator.dart';
import '../../../mock/repository/mock_grand_prix_bet_points_repository.dart';
import '../../../mock/repository/mock_player_repository.dart';
import '../../../mock/use_case/mock_get_finished_grand_prixes_from_season_use_case.dart';

void main() {
  final playerRepository = MockPlayerRepository();
  final getFinishedGrandPrixesFromSeasonUseCase =
      MockGetFinishedGrandPrixesFromSeasonUseCase();
  final grandPrixBetPointsRepository = MockGrandPrixBetPointsRepository();
  const season = 2025;

  late CreatePointsHistoryStats createPointsHistoryStats;

  setUp(() {
    createPointsHistoryStats = CreatePointsHistoryStats(
      playerRepository,
      getFinishedGrandPrixesFromSeasonUseCase,
      grandPrixBetPointsRepository,
    );
  });

  tearDown(() {
    reset(playerRepository);
    reset(getFinishedGrandPrixesFromSeasonUseCase);
    reset(grandPrixBetPointsRepository);
  });

  test(
    'should emit null if list of players is empty',
    () async {
      playerRepository.mockGetAllPlayers(players: []);
      getFinishedGrandPrixesFromSeasonUseCase.mock(
        finishedSeasonGrandPrixes: [
          SeasonGrandPrixCreator(id: 'sgp1').create(),
          SeasonGrandPrixCreator(id: 'sgp2').create(),
        ],
      );

      final Stream<PointsHistory?> pointsHistory$ = createPointsHistoryStats(
        season: season,
      );

      expect(await pointsHistory$.first, null);
      verify(playerRepository.getAllPlayers).called(1);
      verify(
        () => getFinishedGrandPrixesFromSeasonUseCase.call(season: 2025),
      ).called(1);
    },
  );

  test(
    'should return null if list of finished grand prixes is empty',
    () async {
      playerRepository.mockGetAllPlayers(
        players: [
          const PlayerCreator(id: 'p1').create(),
          const PlayerCreator(id: 'p2').create(),
        ],
      );
      getFinishedGrandPrixesFromSeasonUseCase.mock(
        finishedSeasonGrandPrixes: [],
      );

      final Stream<PointsHistory?> pointsHistory$ = createPointsHistoryStats(
        season: season,
      );

      expect(await pointsHistory$.first, null);
      verify(playerRepository.getAllPlayers).called(1);
      verify(
        () => getFinishedGrandPrixesFromSeasonUseCase.call(season: 2025),
      ).called(1);
    },
  );

  test(
    'for each player should create cumulative sum of points gained for each '
    'grand prix',
    () async {
      final List<Player> players = [
        const PlayerCreator(id: 'p1').create(),
        const PlayerCreator(id: 'p2').create(),
        const PlayerCreator(id: 'p3').create(),
      ];
      final List<SeasonGrandPrix> finishedSeasonGrandPrixes = [
        SeasonGrandPrixCreator(id: 'sgp1', roundNumber: 2).create(),
        SeasonGrandPrixCreator(id: 'sgp2', roundNumber: 3).create(),
        SeasonGrandPrixCreator(id: 'sgp3', roundNumber: 1).create(),
      ];
      final List<GrandPrixBetPoints> grandPrixesBetPoints = [
        GrandPrixBetPointsCreator(
          playerId: players.first.id,
          seasonGrandPrixId: finishedSeasonGrandPrixes.first.id,
          totalPoints: 20,
        ).create(),
        GrandPrixBetPointsCreator(
          playerId: players.first.id,
          seasonGrandPrixId: finishedSeasonGrandPrixes[1].id,
          totalPoints: 12.2,
        ).create(),
        GrandPrixBetPointsCreator(
          playerId: players.first.id,
          seasonGrandPrixId: finishedSeasonGrandPrixes.last.id,
          totalPoints: 17,
        ).create(),
        GrandPrixBetPointsCreator(
          playerId: players[1].id,
          seasonGrandPrixId: finishedSeasonGrandPrixes.first.id,
          totalPoints: 5.5,
        ).create(),
        GrandPrixBetPointsCreator(
          playerId: players[1].id,
          seasonGrandPrixId: finishedSeasonGrandPrixes[1].id,
          totalPoints: 17,
        ).create(),
        GrandPrixBetPointsCreator(
          playerId: players[1].id,
          seasonGrandPrixId: finishedSeasonGrandPrixes.last.id,
          totalPoints: 9,
        ).create(),
        GrandPrixBetPointsCreator(
          playerId: players.last.id,
          seasonGrandPrixId: finishedSeasonGrandPrixes.first.id,
          totalPoints: 15,
        ).create(),
        GrandPrixBetPointsCreator(
          playerId: players.last.id,
          seasonGrandPrixId: finishedSeasonGrandPrixes[1].id,
          totalPoints: 17,
        ).create(),
      ];
      final PointsHistory expectedPointsHistory = PointsHistory(
        players: players,
        grandPrixes: [
          PointsHistoryGrandPrix(
            roundNumber: 1,
            playersPoints: [
              PointsHistoryPlayerPoints(
                playerId: players.first.id,
                points: 17,
              ),
              PointsHistoryPlayerPoints(
                playerId: players[1].id,
                points: 9,
              ),
              PointsHistoryPlayerPoints(
                playerId: players.last.id,
                points: 0,
              ),
            ],
          ),
          PointsHistoryGrandPrix(
            roundNumber: 2,
            playersPoints: [
              PointsHistoryPlayerPoints(
                playerId: players.first.id,
                points: 37,
              ),
              PointsHistoryPlayerPoints(
                playerId: players[1].id,
                points: 14.5,
              ),
              PointsHistoryPlayerPoints(
                playerId: players.last.id,
                points: 15,
              ),
            ],
          ),
          PointsHistoryGrandPrix(
            roundNumber: 3,
            playersPoints: [
              PointsHistoryPlayerPoints(
                playerId: players.first.id,
                points: 49.2,
              ),
              PointsHistoryPlayerPoints(
                playerId: players[1].id,
                points: 31.5,
              ),
              PointsHistoryPlayerPoints(
                playerId: players.last.id,
                points: 32,
              ),
            ],
          ),
        ],
      );
      playerRepository.mockGetAllPlayers(players: players);
      getFinishedGrandPrixesFromSeasonUseCase.mock(
        finishedSeasonGrandPrixes: finishedSeasonGrandPrixes,
      );
      grandPrixBetPointsRepository
          .mockGetGrandPrixBetPointsForPlayersAndSeasonGrandPrixes(
        grandPrixesBetPoints: grandPrixesBetPoints,
      );

      final Stream<PointsHistory?> pointsHistory$ = createPointsHistoryStats(
        season: season,
      );

      expect(await pointsHistory$.first, expectedPointsHistory);
      verify(playerRepository.getAllPlayers).called(1);
      verify(
        () => getFinishedGrandPrixesFromSeasonUseCase.call(season: 2025),
      ).called(1);
      verify(
        () => grandPrixBetPointsRepository
            .getGrandPrixBetPointsForPlayersAndSeasonGrandPrixes(
          idsOfPlayers: players.map((player) => player.id).toList(),
          idsOfSeasonGrandPrixes:
              finishedSeasonGrandPrixes.map((gp) => gp.id).toList(),
        ),
      ).called(1);
    },
  );
}
