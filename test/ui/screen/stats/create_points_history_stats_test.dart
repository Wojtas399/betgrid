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
import '../../../mock/use_case/mock_get_finished_grand_prixes_use_case.dart';

void main() {
  final playerRepository = MockPlayerRepository();
  final getFinishedGrandPrixesUseCase = MockGetFinishedGrandPrixesUseCase();
  final grandPrixBetPointsRepository = MockGrandPrixBetPointsRepository();
  late CreatePointsHistoryStats createPointsHistoryStats;

  setUp(() {
    createPointsHistoryStats = CreatePointsHistoryStats(
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
    'list of players is empty, '
    'should emit null',
    () async {
      playerRepository.mockGetAllPlayers(players: []);
      getFinishedGrandPrixesUseCase.mock(
        finishedGrandPrixes: [
          GrandPrixCreator(id: 'gp1').createEntity(),
          GrandPrixCreator(id: 'gp2').createEntity(),
        ],
      );

      final Stream<PointsHistory?> pointsHistory$ = createPointsHistoryStats();

      expect(await pointsHistory$.first, null);
      verify(playerRepository.getAllPlayers).called(1);
      verify(getFinishedGrandPrixesUseCase.call).called(1);
    },
  );

  test(
    'list of finished grand prixes is empty, '
    'should return null',
    () async {
      playerRepository.mockGetAllPlayers(
        players: [
          createPlayer(id: 'p1'),
          createPlayer(id: 'p2'),
        ],
      );
      getFinishedGrandPrixesUseCase.mock(
        finishedGrandPrixes: [],
      );

      final Stream<PointsHistory?> pointsHistory$ = createPointsHistoryStats();

      expect(await pointsHistory$.first, null);
      verify(playerRepository.getAllPlayers).called(1);
      verify(getFinishedGrandPrixesUseCase.call).called(1);
    },
  );

  test(
    'for each player should create cumulative sum of points gained for each '
    'grand prix',
    () async {
      final List<Player> players = [
        createPlayer(id: 'p1'),
        createPlayer(id: 'p2'),
        createPlayer(id: 'p3'),
      ];
      final List<GrandPrix> finishedGrandPrixes = [
        GrandPrixCreator(id: 'gp1', roundNumber: 2).createEntity(),
        GrandPrixCreator(id: 'gp2', roundNumber: 3).createEntity(),
        GrandPrixCreator(id: 'gp3', roundNumber: 1).createEntity(),
      ];
      final List<GrandPrixBetPoints> grandPrixesBetPoints = [
        GrandPrixBetPointsCreator(
          playerId: 'p1',
          grandPrixId: 'gp1',
          totalPoints: 20,
        ).createEntity(),
        GrandPrixBetPointsCreator(
          playerId: 'p1',
          grandPrixId: 'gp2',
          totalPoints: 12.2,
        ).createEntity(),
        GrandPrixBetPointsCreator(
          playerId: 'p1',
          grandPrixId: 'gp3',
          totalPoints: 17,
        ).createEntity(),
        GrandPrixBetPointsCreator(
          playerId: 'p2',
          grandPrixId: 'gp1',
          totalPoints: 5.5,
        ).createEntity(),
        GrandPrixBetPointsCreator(
          playerId: 'p2',
          grandPrixId: 'gp2',
          totalPoints: 17,
        ).createEntity(),
        GrandPrixBetPointsCreator(
          playerId: 'p2',
          grandPrixId: 'gp3',
          totalPoints: 9,
        ).createEntity(),
        GrandPrixBetPointsCreator(
          playerId: 'p3',
          grandPrixId: 'gp1',
          totalPoints: 15,
        ).createEntity(),
        GrandPrixBetPointsCreator(
          playerId: 'p3',
          grandPrixId: 'gp2',
          totalPoints: 17,
        ).createEntity(),
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
      playerRepository.mockGetAllPlayers(players: players);
      getFinishedGrandPrixesUseCase.mock(
        finishedGrandPrixes: finishedGrandPrixes,
      );
      grandPrixBetPointsRepository
          .mockGetGrandPrixBetPointsForPlayersAndGrandPrixes(
        grandPrixesBetPoints: grandPrixesBetPoints,
      );

      final Stream<PointsHistory?> pointsHistory$ = createPointsHistoryStats();

      expect(await pointsHistory$.first, expectedPointsHistory);
      verify(playerRepository.getAllPlayers).called(1);
      verify(getFinishedGrandPrixesUseCase.call).called(1);
      verify(
        () => grandPrixBetPointsRepository
            .getGrandPrixBetPointsForPlayersAndGrandPrixes(
          idsOfPlayers: ['p1', 'p2', 'p3'],
          idsOfGrandPrixes: ['gp1', 'gp2', 'gp3'],
        ),
      ).called(1);
    },
  );
}
