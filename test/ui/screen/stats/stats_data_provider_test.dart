import 'package:betgrid/data/repository/grand_prix_bet_points/grand_prix_bet_points_repository_method_providers.dart';
import 'package:betgrid/data/repository/player/player_repository_method_providers.dart';
import 'package:betgrid/model/grand_prix.dart';
import 'package:betgrid/model/player.dart';
import 'package:betgrid/ui/screen/stats/provider/finished_grand_prixes_provider.dart';
import 'package:betgrid/ui/screen/stats/provider/players_podium_chart_data.dart';
import 'package:betgrid/ui/screen/stats/provider/points_by_driver_data.dart';
import 'package:betgrid/ui/screen/stats/provider/points_for_driver_in_grand_prix_provider.dart';
import 'package:betgrid/ui/screen/stats/provider/points_history_chart_data.dart';
import 'package:betgrid/ui/screen/stats/provider/stats_data_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../creator/grand_prix_bet_points_creator.dart';
import '../../../creator/grand_prix_creator.dart';
import '../../../creator/player_creator.dart';

void main() {
  test(
    'build, '
    'list of all players is null, '
    'should return null',
    () async {
      final container = ProviderContainer(
        overrides: [
          allPlayersProvider.overrideWith((_) => Stream.value(null)),
        ],
      );

      final StatsData? stats = await container.read(statsProvider.future);

      expect(stats, null);
    },
  );

  test(
    'build, '
    'list of all players is empty, '
    'should return null',
    () async {
      final container = ProviderContainer(
        overrides: [
          allPlayersProvider.overrideWith((_) => Stream.value([])),
        ],
      );

      final StatsData? stats = await container.read(statsProvider.future);

      expect(stats, null);
    },
  );

  test(
    'build, '
    'should initialize data for players podium chart and points history chart',
    () async {
      final List<Player> allPlayers = [
        createPlayer(id: 'p1'),
        createPlayer(id: 'p2'),
        createPlayer(id: 'p3'),
      ];
      final List<GrandPrix> finishedGrandPrixes = [
        createGrandPrix(
          id: 'gp1',
          roundNumber: 3,
          name: 'grand prix 1',
        ),
        createGrandPrix(
          id: 'gp2',
          roundNumber: 2,
          name: 'grand prix 2',
        ),
        createGrandPrix(
          id: 'gp3',
          roundNumber: 1,
          name: 'grand prix 3',
        ),
      ];
      final player1Gp1BetPoints = createGrandPrixBetPoints(
        totalPoints: 5,
        playerId: allPlayers.first.id,
        grandPrixId: finishedGrandPrixes.first.id,
      );
      final player1Gp2BetPoints = createGrandPrixBetPoints(
        totalPoints: 7.5,
        playerId: allPlayers.first.id,
        grandPrixId: finishedGrandPrixes[1].id,
      );
      final player1Gp3BetPoints = createGrandPrixBetPoints(
        totalPoints: 4,
        playerId: allPlayers.first.id,
        grandPrixId: finishedGrandPrixes[2].id,
      );
      final player2Gp1BetPoints = createGrandPrixBetPoints(
        totalPoints: 8.5,
        playerId: allPlayers[1].id,
        grandPrixId: finishedGrandPrixes.first.id,
      );
      final player2Gp2BetPoints = createGrandPrixBetPoints(
        totalPoints: 5.25,
        playerId: allPlayers[1].id,
        grandPrixId: finishedGrandPrixes[1].id,
      );
      final player2Gp3BetPoints = createGrandPrixBetPoints(
        totalPoints: 9,
        playerId: allPlayers[1].id,
        grandPrixId: finishedGrandPrixes[2].id,
      );
      final player3Gp1BetPoints = createGrandPrixBetPoints(
        totalPoints: 4.75,
        playerId: allPlayers[2].id,
        grandPrixId: finishedGrandPrixes.first.id,
      );
      final player3Gp2BetPoints = createGrandPrixBetPoints(
        totalPoints: 6,
        playerId: allPlayers[2].id,
        grandPrixId: finishedGrandPrixes[1].id,
      );
      final StatsData expectedStats = StatsData(
        playersPodiumChartData: PlayersPodiumChartData(
          p1Player: PlayersPodiumChartPlayer(
            player: allPlayers[1],
            points: player2Gp1BetPoints.totalPoints +
                player2Gp2BetPoints.totalPoints +
                player2Gp3BetPoints.totalPoints,
          ),
          p2Player: PlayersPodiumChartPlayer(
            player: allPlayers.first,
            points: player1Gp1BetPoints.totalPoints +
                player1Gp2BetPoints.totalPoints +
                player1Gp3BetPoints.totalPoints,
          ),
          p3Player: PlayersPodiumChartPlayer(
            player: allPlayers.last,
            points: player3Gp1BetPoints.totalPoints +
                player3Gp2BetPoints.totalPoints,
          ),
        ),
        pointsHistoryChartData: PointsHistoryChartData(
          players: allPlayers,
          chartGrandPrixes: [
            PointsHistoryChartGrandPrix(
              roundNumber: 1,
              playersPoints: [
                PointsHistoryChartPlayerPoints(
                  playerId: 'p1',
                  points: player1Gp3BetPoints.totalPoints,
                ),
                PointsHistoryChartPlayerPoints(
                  playerId: 'p2',
                  points: player2Gp3BetPoints.totalPoints,
                ),
                const PointsHistoryChartPlayerPoints(
                  playerId: 'p3',
                  points: 0.0,
                ),
              ],
            ),
            PointsHistoryChartGrandPrix(
              roundNumber: 2,
              playersPoints: [
                PointsHistoryChartPlayerPoints(
                  playerId: 'p1',
                  points: player1Gp3BetPoints.totalPoints +
                      player1Gp2BetPoints.totalPoints,
                ),
                PointsHistoryChartPlayerPoints(
                  playerId: 'p2',
                  points: player2Gp3BetPoints.totalPoints +
                      player2Gp2BetPoints.totalPoints,
                ),
                PointsHistoryChartPlayerPoints(
                  playerId: 'p3',
                  points: player3Gp2BetPoints.totalPoints,
                ),
              ],
            ),
            PointsHistoryChartGrandPrix(
              roundNumber: 3,
              playersPoints: [
                PointsHistoryChartPlayerPoints(
                  playerId: 'p1',
                  points: player1Gp3BetPoints.totalPoints +
                      player1Gp2BetPoints.totalPoints +
                      player1Gp1BetPoints.totalPoints,
                ),
                PointsHistoryChartPlayerPoints(
                  playerId: 'p2',
                  points: player2Gp3BetPoints.totalPoints +
                      player2Gp2BetPoints.totalPoints +
                      player2Gp1BetPoints.totalPoints,
                ),
                PointsHistoryChartPlayerPoints(
                  playerId: 'p3',
                  points: player3Gp2BetPoints.totalPoints +
                      player3Gp1BetPoints.totalPoints,
                ),
              ],
            ),
          ],
        ),
        pointsByDriverChartData: const [],
      );
      final container = ProviderContainer(
        overrides: [
          allPlayersProvider.overrideWith((_) => Stream.value(allPlayers)),
          finishedGrandPrixesProvider.overrideWith(
            (_) => Future.value(finishedGrandPrixes),
          ),
          grandPrixBetPointsProvider(
            playerId: allPlayers.first.id,
            grandPrixId: finishedGrandPrixes.first.id,
          ).overrideWith((_) => Stream.value(player1Gp1BetPoints)),
          grandPrixBetPointsProvider(
            playerId: allPlayers.first.id,
            grandPrixId: finishedGrandPrixes[1].id,
          ).overrideWith((_) => Stream.value(player1Gp2BetPoints)),
          grandPrixBetPointsProvider(
            playerId: allPlayers.first.id,
            grandPrixId: finishedGrandPrixes[2].id,
          ).overrideWith((_) => Stream.value(player1Gp3BetPoints)),
          grandPrixBetPointsProvider(
            playerId: allPlayers[1].id,
            grandPrixId: finishedGrandPrixes.first.id,
          ).overrideWith((_) => Stream.value(player2Gp1BetPoints)),
          grandPrixBetPointsProvider(
            playerId: allPlayers[1].id,
            grandPrixId: finishedGrandPrixes[1].id,
          ).overrideWith((_) => Stream.value(player2Gp2BetPoints)),
          grandPrixBetPointsProvider(
            playerId: allPlayers[1].id,
            grandPrixId: finishedGrandPrixes[2].id,
          ).overrideWith((_) => Stream.value(player2Gp3BetPoints)),
          grandPrixBetPointsProvider(
            playerId: allPlayers[2].id,
            grandPrixId: finishedGrandPrixes.first.id,
          ).overrideWith((_) => Stream.value(player3Gp1BetPoints)),
          grandPrixBetPointsProvider(
            playerId: allPlayers[2].id,
            grandPrixId: finishedGrandPrixes[1].id,
          ).overrideWith((_) => Stream.value(player3Gp2BetPoints)),
          grandPrixBetPointsProvider(
            playerId: allPlayers[2].id,
            grandPrixId: finishedGrandPrixes[2].id,
          ).overrideWith((_) => Stream.value(null)),
        ],
      );

      final StatsData? stats = await container.read(statsProvider.future);

      expect(stats, expectedStats);
    },
  );

  test(
    'onDriverChanged, '
    'should create data for points by driver',
    () async {
      const String driverId = 'd1';
      final List<Player> allPlayers = [
        createPlayer(id: 'p1'),
        createPlayer(id: 'p2'),
        createPlayer(id: 'p3'),
      ];
      final List<GrandPrix> finishedGrandPrixes = [
        createGrandPrix(
          id: 'gp1',
          roundNumber: 3,
          name: 'grand prix 1',
        ),
        createGrandPrix(
          id: 'gp2',
          roundNumber: 2,
          name: 'grand prix 2',
        ),
        createGrandPrix(
          id: 'gp3',
          roundNumber: 1,
          name: 'grand prix 3',
        ),
      ];
      final player1Gp1BetPoints = createGrandPrixBetPoints(
        totalPoints: 5,
        playerId: allPlayers.first.id,
        grandPrixId: finishedGrandPrixes.first.id,
      );
      final player1Gp2BetPoints = createGrandPrixBetPoints(
        totalPoints: 7.5,
        playerId: allPlayers.first.id,
        grandPrixId: finishedGrandPrixes[1].id,
      );
      final player1Gp3BetPoints = createGrandPrixBetPoints(
        totalPoints: 4,
        playerId: allPlayers.first.id,
        grandPrixId: finishedGrandPrixes[2].id,
      );
      final player2Gp1BetPoints = createGrandPrixBetPoints(
        totalPoints: 8.5,
        playerId: allPlayers[1].id,
        grandPrixId: finishedGrandPrixes.first.id,
      );
      final player2Gp2BetPoints = createGrandPrixBetPoints(
        totalPoints: 5.25,
        playerId: allPlayers[1].id,
        grandPrixId: finishedGrandPrixes[1].id,
      );
      final player2Gp3BetPoints = createGrandPrixBetPoints(
        totalPoints: 9,
        playerId: allPlayers[1].id,
        grandPrixId: finishedGrandPrixes[2].id,
      );
      final player3Gp1BetPoints = createGrandPrixBetPoints(
        totalPoints: 4.75,
        playerId: allPlayers[2].id,
        grandPrixId: finishedGrandPrixes.first.id,
      );
      final player3Gp2BetPoints = createGrandPrixBetPoints(
        totalPoints: 6,
        playerId: allPlayers[2].id,
        grandPrixId: finishedGrandPrixes[1].id,
      );
      const double player1Gp1PointsForDriver = 2.5;
      const double player1Gp2PointsForDriver = 5;
      const double player1Gp3PointsForDriver = 3;
      const double player2Gp1PointsForDriver = 4;
      const double player2Gp2PointsForDriver = 4;
      const double player2Gp3PointsForDriver = 8.4;
      const double player3Gp1PointsForDriver = 6;
      const double player3Gp2PointsForDriver = 1.6;
      final StatsData expectedStats = StatsData(
        playersPodiumChartData: PlayersPodiumChartData(
          p1Player: PlayersPodiumChartPlayer(
            player: allPlayers[1],
            points: player2Gp1BetPoints.totalPoints +
                player2Gp2BetPoints.totalPoints +
                player2Gp3BetPoints.totalPoints,
          ),
          p2Player: PlayersPodiumChartPlayer(
            player: allPlayers.first,
            points: player1Gp1BetPoints.totalPoints +
                player1Gp2BetPoints.totalPoints +
                player1Gp3BetPoints.totalPoints,
          ),
          p3Player: PlayersPodiumChartPlayer(
            player: allPlayers.last,
            points: player3Gp1BetPoints.totalPoints +
                player3Gp2BetPoints.totalPoints,
          ),
        ),
        pointsHistoryChartData: PointsHistoryChartData(
          players: allPlayers,
          chartGrandPrixes: [
            PointsHistoryChartGrandPrix(
              roundNumber: 1,
              playersPoints: [
                PointsHistoryChartPlayerPoints(
                  playerId: 'p1',
                  points: player1Gp3BetPoints.totalPoints,
                ),
                PointsHistoryChartPlayerPoints(
                  playerId: 'p2',
                  points: player2Gp3BetPoints.totalPoints,
                ),
                const PointsHistoryChartPlayerPoints(
                  playerId: 'p3',
                  points: 0.0,
                ),
              ],
            ),
            PointsHistoryChartGrandPrix(
              roundNumber: 2,
              playersPoints: [
                PointsHistoryChartPlayerPoints(
                  playerId: 'p1',
                  points: player1Gp3BetPoints.totalPoints +
                      player1Gp2BetPoints.totalPoints,
                ),
                PointsHistoryChartPlayerPoints(
                  playerId: 'p2',
                  points: player2Gp3BetPoints.totalPoints +
                      player2Gp2BetPoints.totalPoints,
                ),
                PointsHistoryChartPlayerPoints(
                  playerId: 'p3',
                  points: player3Gp2BetPoints.totalPoints,
                ),
              ],
            ),
            PointsHistoryChartGrandPrix(
              roundNumber: 3,
              playersPoints: [
                PointsHistoryChartPlayerPoints(
                  playerId: 'p1',
                  points: player1Gp3BetPoints.totalPoints +
                      player1Gp2BetPoints.totalPoints +
                      player1Gp1BetPoints.totalPoints,
                ),
                PointsHistoryChartPlayerPoints(
                  playerId: 'p2',
                  points: player2Gp3BetPoints.totalPoints +
                      player2Gp2BetPoints.totalPoints +
                      player2Gp1BetPoints.totalPoints,
                ),
                PointsHistoryChartPlayerPoints(
                  playerId: 'p3',
                  points: player3Gp2BetPoints.totalPoints +
                      player3Gp1BetPoints.totalPoints,
                ),
              ],
            ),
          ],
        ),
        pointsByDriverChartData: [
          PointsByDriverPlayerPoints(
            player: allPlayers.first,
            points: player1Gp1PointsForDriver +
                player1Gp2PointsForDriver +
                player1Gp3PointsForDriver,
          ),
          PointsByDriverPlayerPoints(
            player: allPlayers[1],
            points: player2Gp1PointsForDriver +
                player2Gp2PointsForDriver +
                player2Gp3PointsForDriver,
          ),
          PointsByDriverPlayerPoints(
              player: allPlayers.last,
              points: player3Gp1PointsForDriver + player3Gp2PointsForDriver),
        ],
      );
      final container = ProviderContainer(
        overrides: [
          allPlayersProvider.overrideWith((_) => Stream.value(allPlayers)),
          finishedGrandPrixesProvider.overrideWith(
            (_) => Future.value(finishedGrandPrixes),
          ),
          grandPrixBetPointsProvider(
            playerId: allPlayers.first.id,
            grandPrixId: finishedGrandPrixes.first.id,
          ).overrideWith((_) => Stream.value(player1Gp1BetPoints)),
          grandPrixBetPointsProvider(
            playerId: allPlayers.first.id,
            grandPrixId: finishedGrandPrixes[1].id,
          ).overrideWith((_) => Stream.value(player1Gp2BetPoints)),
          grandPrixBetPointsProvider(
            playerId: allPlayers.first.id,
            grandPrixId: finishedGrandPrixes[2].id,
          ).overrideWith((_) => Stream.value(player1Gp3BetPoints)),
          grandPrixBetPointsProvider(
            playerId: allPlayers[1].id,
            grandPrixId: finishedGrandPrixes.first.id,
          ).overrideWith((_) => Stream.value(player2Gp1BetPoints)),
          grandPrixBetPointsProvider(
            playerId: allPlayers[1].id,
            grandPrixId: finishedGrandPrixes[1].id,
          ).overrideWith((_) => Stream.value(player2Gp2BetPoints)),
          grandPrixBetPointsProvider(
            playerId: allPlayers[1].id,
            grandPrixId: finishedGrandPrixes[2].id,
          ).overrideWith((_) => Stream.value(player2Gp3BetPoints)),
          grandPrixBetPointsProvider(
            playerId: allPlayers[2].id,
            grandPrixId: finishedGrandPrixes.first.id,
          ).overrideWith((_) => Stream.value(player3Gp1BetPoints)),
          grandPrixBetPointsProvider(
            playerId: allPlayers[2].id,
            grandPrixId: finishedGrandPrixes[1].id,
          ).overrideWith((_) => Stream.value(player3Gp2BetPoints)),
          grandPrixBetPointsProvider(
            playerId: allPlayers[2].id,
            grandPrixId: finishedGrandPrixes[2].id,
          ).overrideWith((_) => Stream.value(null)),
          pointsForDriverInGrandPrixProvider(
            playerId: allPlayers.first.id,
            grandPrixId: finishedGrandPrixes.first.id,
            driverId: driverId,
            grandPrixBetPoints: player1Gp1BetPoints,
          ).overrideWith((_) => Future.value(player1Gp1PointsForDriver)),
          pointsForDriverInGrandPrixProvider(
            playerId: allPlayers.first.id,
            grandPrixId: finishedGrandPrixes[1].id,
            driverId: driverId,
            grandPrixBetPoints: player1Gp2BetPoints,
          ).overrideWith((_) => Future.value(player1Gp2PointsForDriver)),
          pointsForDriverInGrandPrixProvider(
            playerId: allPlayers.first.id,
            grandPrixId: finishedGrandPrixes[2].id,
            driverId: driverId,
            grandPrixBetPoints: player1Gp3BetPoints,
          ).overrideWith((_) => Future.value(player1Gp3PointsForDriver)),
          pointsForDriverInGrandPrixProvider(
            playerId: allPlayers[1].id,
            grandPrixId: finishedGrandPrixes.first.id,
            driverId: driverId,
            grandPrixBetPoints: player2Gp1BetPoints,
          ).overrideWith((_) => Future.value(player2Gp1PointsForDriver)),
          pointsForDriverInGrandPrixProvider(
            playerId: allPlayers[1].id,
            grandPrixId: finishedGrandPrixes[1].id,
            driverId: driverId,
            grandPrixBetPoints: player2Gp2BetPoints,
          ).overrideWith((_) => Future.value(player2Gp2PointsForDriver)),
          pointsForDriverInGrandPrixProvider(
            playerId: allPlayers[1].id,
            grandPrixId: finishedGrandPrixes[2].id,
            driverId: driverId,
            grandPrixBetPoints: player2Gp3BetPoints,
          ).overrideWith((_) => Future.value(player2Gp3PointsForDriver)),
          pointsForDriverInGrandPrixProvider(
            playerId: allPlayers[2].id,
            grandPrixId: finishedGrandPrixes.first.id,
            driverId: driverId,
            grandPrixBetPoints: player3Gp1BetPoints,
          ).overrideWith((_) => Future.value(player3Gp1PointsForDriver)),
          pointsForDriverInGrandPrixProvider(
            playerId: allPlayers[2].id,
            grandPrixId: finishedGrandPrixes[1].id,
            driverId: driverId,
            grandPrixBetPoints: player3Gp2BetPoints,
          ).overrideWith((_) => Future.value(player3Gp2PointsForDriver)),
        ],
      );

      await container.read(statsProvider.future);
      container.read(statsProvider.notifier).onDriverChanged(driverId);
      final stats = await container.read(statsProvider.future);

      expect(stats, expectedStats);
    },
  );
}
