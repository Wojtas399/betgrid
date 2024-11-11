import 'package:betgrid/model/grand_prix.dart';
import 'package:betgrid/model/grand_prix_bet_points.dart';
import 'package:betgrid/model/player.dart';
import 'package:betgrid/ui/screen/stats/stats_creator/create_points_history_stats.dart';
import 'package:betgrid/ui/screen/stats/stats_model/points_history.dart';
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
  late CreatePointsHistoryStats createPointsHistoryStats;

  setUp(() {
    createPointsHistoryStats = CreatePointsHistoryStats(
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
    'should emit null if list of players is empty',
    () async {
      playerRepository.mockGetAllPlayers(players: []);
      getFinishedGrandPrixesFromCurrentSeasonUseCase.mock(
        finishedGrandPrixes: [
          GrandPrixCreator(id: 'gp1').createEntity(),
          GrandPrixCreator(id: 'gp2').createEntity(),
        ],
      );

      final Stream<PointsHistory?> pointsHistory$ = createPointsHistoryStats();

      expect(await pointsHistory$.first, null);
      verify(playerRepository.getAllPlayers).called(1);
      verify(getFinishedGrandPrixesFromCurrentSeasonUseCase.call).called(1);
    },
  );

  test(
    'should return null if list of finished grand prixes is empty',
    () async {
      playerRepository.mockGetAllPlayers(
        players: [
          const PlayerCreator(id: 'p1').createEntity(),
          const PlayerCreator(id: 'p2').createEntity(),
        ],
      );
      getFinishedGrandPrixesFromCurrentSeasonUseCase.mock(
        finishedGrandPrixes: [],
      );

      final Stream<PointsHistory?> pointsHistory$ = createPointsHistoryStats();

      expect(await pointsHistory$.first, null);
      verify(playerRepository.getAllPlayers).called(1);
      verify(getFinishedGrandPrixesFromCurrentSeasonUseCase.call).called(1);
    },
  );

  test(
    'for each player should create cumulative sum of points gained for each '
    'grand prix',
    () async {
      final List<Player> players = [
        const PlayerCreator(id: 'p1').createEntity(),
        const PlayerCreator(id: 'p2').createEntity(),
        const PlayerCreator(id: 'p3').createEntity(),
      ];
      final List<GrandPrix> finishedGrandPrixes = [
        GrandPrixCreator(id: 'gp1', roundNumber: 2).createEntity(),
        GrandPrixCreator(id: 'gp2', roundNumber: 3).createEntity(),
        GrandPrixCreator(id: 'gp3', roundNumber: 1).createEntity(),
      ];
      final List<GrandPrixBetPoints> grandPrixesBetPoints = [
        GrandPrixBetPointsCreator(
          playerId: players.first.id,
          seasonGrandPrixId: finishedGrandPrixes.first.id,
          totalPoints: 20,
        ).createEntity(),
        GrandPrixBetPointsCreator(
          playerId: players.first.id,
          seasonGrandPrixId: finishedGrandPrixes[1].id,
          totalPoints: 12.2,
        ).createEntity(),
        GrandPrixBetPointsCreator(
          playerId: players.first.id,
          seasonGrandPrixId: finishedGrandPrixes.last.id,
          totalPoints: 17,
        ).createEntity(),
        GrandPrixBetPointsCreator(
          playerId: players[1].id,
          seasonGrandPrixId: finishedGrandPrixes.first.id,
          totalPoints: 5.5,
        ).createEntity(),
        GrandPrixBetPointsCreator(
          playerId: players[1].id,
          seasonGrandPrixId: finishedGrandPrixes[1].id,
          totalPoints: 17,
        ).createEntity(),
        GrandPrixBetPointsCreator(
          playerId: players[1].id,
          seasonGrandPrixId: finishedGrandPrixes.last.id,
          totalPoints: 9,
        ).createEntity(),
        GrandPrixBetPointsCreator(
          playerId: players.last.id,
          seasonGrandPrixId: finishedGrandPrixes.first.id,
          totalPoints: 15,
        ).createEntity(),
        GrandPrixBetPointsCreator(
          playerId: players.last.id,
          seasonGrandPrixId: finishedGrandPrixes[1].id,
          totalPoints: 17,
        ).createEntity(),
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
      getFinishedGrandPrixesFromCurrentSeasonUseCase.mock(
        finishedGrandPrixes: finishedGrandPrixes,
      );
      grandPrixBetPointsRepository
          .mockGetGrandPrixBetPointsForPlayersAndSeasonGrandPrixes(
        grandPrixesBetPoints: grandPrixesBetPoints,
      );

      final Stream<PointsHistory?> pointsHistory$ = createPointsHistoryStats();

      expect(await pointsHistory$.first, expectedPointsHistory);
      verify(playerRepository.getAllPlayers).called(1);
      verify(getFinishedGrandPrixesFromCurrentSeasonUseCase.call).called(1);
      verify(
        () => grandPrixBetPointsRepository
            .getGrandPrixBetPointsForPlayersAndSeasonGrandPrixes(
          idsOfPlayers: players.map((player) => player.id).toList(),
          idsOfSeasonGrandPrixes:
              finishedGrandPrixes.map((gp) => gp.id).toList(),
        ),
      ).called(1);
    },
  );
}
