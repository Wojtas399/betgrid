import 'package:betgrid/data/repository/player/player_repository.dart';
import 'package:betgrid/data/repository/player/player_repository_method_providers.dart';
import 'package:betgrid/model/player.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mock/data/repository/mock_player_repository.dart';

void main() {
  final playerRepository = MockPlayerRepository();

  ProviderContainer makeProviderContainer() {
    final container = ProviderContainer(
      overrides: [
        playerRepositoryProvider.overrideWithValue(playerRepository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test(
    'allPlayersProvider, '
    'should get all players from player repository and should emit them',
    () async {
      const List<Player> expectedPlayers = [
        Player(id: 'p1', username: 'username 1'),
        Player(id: 'p2', username: 'username 2'),
      ];
      playerRepository.mockGetAllPlayers(players: expectedPlayers);
      final container = makeProviderContainer();

      final List<Player>? players =
          await container.read(allPlayersProvider.future);

      expect(players, expectedPlayers);
    },
  );
}
