import 'package:betgrid/data/repository/player/player_repository_method_providers.dart';
import 'package:betgrid/model/grand_prix.dart';
import 'package:betgrid/model/player.dart';
import 'package:betgrid/ui/provider/grand_prix_bet_points_provider.dart';
import 'package:betgrid/ui/screen/stats/provider/finished_grand_prixes_provider.dart';
import 'package:betgrid/ui/screen/stats/provider/points_history_chart_data_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../creator/grand_prix_bet_points_creator.dart';
import '../../../creator/grand_prix_creator.dart';

void main() {
  test(
    'players do not exist, '
    'should return null',
    () async {
      final container = ProviderContainer(
        overrides: [
          allPlayersProvider.overrideWith((_) => Stream.value(null)),
        ],
      );

      final chartData =
          await container.read(pointsHistoryChartDataProvider.future);

      expect(chartData, null);
    },
  );

  test(
    'for each player in grand prix should sum bet points for current grand prix '
    'and previous grand prixes, ',
    () async {
      const List<Player> allPlayers = [
        Player(id: 'p1', username: 'username 1'),
        Player(id: 'p2', username: 'username 2'),
      ];
      final List<GrandPrix> terminatedGrandPrixes = [
        createGrandPrix(id: 'gp1', name: 'grand prix 1'),
        createGrandPrix(id: 'gp2', name: 'grand prix 2'),
        createGrandPrix(id: 'gp3', name: 'grand prix 3'),
      ];
      const double player1Gp1BetPoints = 5.0;
      const double player1Gp2BetPoints = 9.0;
      const double player1Gp3BetPoints = 4.0;
      const double player2Gp1BetPoints = 10.0;
      const double player2Gp2BetPoints = 8.0;
      const double player2Gp3BetPoints = 6.0;
      const PointsHistoryChartData expectedChartData = PointsHistoryChartData(
        players: allPlayers,
        chartGrandPrixes: [
          PointsHistoryChartGrandPrix(
            grandPrixName: 'grand prix 1',
            playersPoints: [
              PointsHistoryChartPlayerPoints(
                playerId: 'p1',
                points: player1Gp1BetPoints,
              ),
              PointsHistoryChartPlayerPoints(
                playerId: 'p2',
                points: player2Gp1BetPoints,
              ),
            ],
          ),
          PointsHistoryChartGrandPrix(
            grandPrixName: 'grand prix 2',
            playersPoints: [
              PointsHistoryChartPlayerPoints(
                playerId: 'p1',
                points: player1Gp1BetPoints + player1Gp2BetPoints,
              ),
              PointsHistoryChartPlayerPoints(
                playerId: 'p2',
                points: player2Gp1BetPoints + player2Gp2BetPoints,
              ),
            ],
          ),
          PointsHistoryChartGrandPrix(
            grandPrixName: 'grand prix 3',
            playersPoints: [
              PointsHistoryChartPlayerPoints(
                playerId: 'p1',
                points: player1Gp1BetPoints +
                    player1Gp2BetPoints +
                    player1Gp3BetPoints,
              ),
              PointsHistoryChartPlayerPoints(
                playerId: 'p2',
                points: player2Gp1BetPoints +
                    player2Gp2BetPoints +
                    player2Gp3BetPoints,
              ),
            ],
          ),
        ],
      );
      final container = ProviderContainer(
        overrides: [
          allPlayersProvider.overrideWith((_) => Stream.value(allPlayers)),
          finishedGrandPrixesProvider.overrideWith(
            (_) => Future.value(terminatedGrandPrixes),
          ),
          grandPrixBetPointsProvider(
            grandPrixId: 'gp1',
            playerId: 'p1',
          ).overrideWith(
            (_) => Stream.value(
              createGrandPrixBetPoints(totalPoints: player1Gp1BetPoints),
            ),
          ),
          grandPrixBetPointsProvider(
            grandPrixId: 'gp2',
            playerId: 'p1',
          ).overrideWith(
            (_) => Stream.value(
              createGrandPrixBetPoints(totalPoints: player1Gp2BetPoints),
            ),
          ),
          grandPrixBetPointsProvider(
            grandPrixId: 'gp3',
            playerId: 'p1',
          ).overrideWith(
            (_) => Stream.value(
              createGrandPrixBetPoints(totalPoints: player1Gp3BetPoints),
            ),
          ),
          grandPrixBetPointsProvider(
            grandPrixId: 'gp1',
            playerId: 'p2',
          ).overrideWith(
            (_) => Stream.value(
              createGrandPrixBetPoints(totalPoints: player2Gp1BetPoints),
            ),
          ),
          grandPrixBetPointsProvider(
            grandPrixId: 'gp2',
            playerId: 'p2',
          ).overrideWith(
            (_) => Stream.value(
              createGrandPrixBetPoints(totalPoints: player2Gp2BetPoints),
            ),
          ),
          grandPrixBetPointsProvider(
            grandPrixId: 'gp3',
            playerId: 'p2',
          ).overrideWith(
            (_) => Stream.value(
              createGrandPrixBetPoints(totalPoints: player2Gp3BetPoints),
            ),
          ),
        ],
      );

      final chartData =
          await container.read(pointsHistoryChartDataProvider.future);

      expect(chartData, expectedChartData);
    },
  );
}
