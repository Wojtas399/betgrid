import 'package:betgrid/data/repository/player/player_repository_method_providers.dart';
import 'package:betgrid/model/player.dart';
import 'package:betgrid/ui/provider/player_points_provider.dart';
import 'package:betgrid/ui/screen/stats/provider/players_podium_chart_data_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'there are no players, '
    'should return null',
    () async {
      final container = ProviderContainer(
        overrides: [
          allPlayersProvider.overrideWith((_) => Stream.value(null)),
        ],
      );

      final chartData =
          await container.read(playersPodiumChartDataProvider.future);

      expect(chartData, null);
    },
  );

  test(
    'there is only 1 player, '
    'should load its total bet points',
    () async {
      const List<Player> allPlayers = [
        Player(id: 'p1', username: 'username 1'),
      ];
      const double player1BetPoints = 15.0;
      final PlayersPodiumChartData expectedChartData = PlayersPodiumChartData(
        p1Player: PlayersPodiumChartPlayer(
          player: allPlayers.first,
          points: player1BetPoints,
        ),
      );
      final container = ProviderContainer(
        overrides: [
          allPlayersProvider.overrideWith((_) => Stream.value(allPlayers)),
          playerPointsProvider(playerId: 'p1').overrideWith(
            (_) => Future.value(player1BetPoints),
          ),
        ],
      );

      final chartData =
          await container.read(playersPodiumChartDataProvider.future);

      expect(chartData, expectedChartData);
    },
  );

  test(
    'there is only 2 players, '
    'for each player should load its total bet points and should return them '
    'sorted by total points',
    () async {
      const List<Player> allPlayers = [
        Player(id: 'p1', username: 'username 1'),
        Player(id: 'p2', username: 'username 2'),
      ];
      const double player1BetPoints = 15.0;
      const double player2BetPoints = 23.5;
      final PlayersPodiumChartData expectedChartData = PlayersPodiumChartData(
        p1Player: PlayersPodiumChartPlayer(
          player: allPlayers[1],
          points: player2BetPoints,
        ),
        p2Player: PlayersPodiumChartPlayer(
          player: allPlayers.first,
          points: player1BetPoints,
        ),
      );
      final container = ProviderContainer(
        overrides: [
          allPlayersProvider.overrideWith((_) => Stream.value(allPlayers)),
          playerPointsProvider(playerId: 'p1').overrideWith(
            (_) => Future.value(player1BetPoints),
          ),
          playerPointsProvider(playerId: 'p2').overrideWith(
            (_) => Future.value(player2BetPoints),
          ),
        ],
      );

      final chartData =
          await container.read(playersPodiumChartDataProvider.future);

      expect(chartData, expectedChartData);
    },
  );

  test(
    'for each player should load its total bet points and should return only '
    'top 3 players',
    () async {
      const List<Player> allPlayers = [
        Player(id: 'p1', username: 'username 1'),
        Player(id: 'p2', username: 'username 2'),
        Player(id: 'p3', username: 'username 3'),
        Player(id: 'p4', username: 'username 4'),
      ];
      const double player1BetPoints = 15.0;
      const double player2BetPoints = 23.5;
      const double player3BetPoints = 8.75;
      const double player4BetPoints = 12.0;
      final PlayersPodiumChartData expectedChartData = PlayersPodiumChartData(
        p1Player: PlayersPodiumChartPlayer(
          player: allPlayers[1],
          points: player2BetPoints,
        ),
        p2Player: PlayersPodiumChartPlayer(
          player: allPlayers.first,
          points: player1BetPoints,
        ),
        p3Player: PlayersPodiumChartPlayer(
          player: allPlayers.last,
          points: player4BetPoints,
        ),
      );
      final container = ProviderContainer(
        overrides: [
          allPlayersProvider.overrideWith((_) => Stream.value(allPlayers)),
          playerPointsProvider(playerId: 'p1').overrideWith(
            (_) => Future.value(player1BetPoints),
          ),
          playerPointsProvider(playerId: 'p2').overrideWith(
            (_) => Future.value(player2BetPoints),
          ),
          playerPointsProvider(playerId: 'p3').overrideWith(
            (_) => Future.value(player3BetPoints),
          ),
          playerPointsProvider(playerId: 'p4').overrideWith(
            (_) => Future.value(player4BetPoints),
          ),
        ],
      );

      final chartData =
          await container.read(playersPodiumChartDataProvider.future);

      expect(chartData, expectedChartData);
    },
  );
}
