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
    'playerProvider, '
    'should get player from PlayerRepository and should emit it',
    () async {
      const String playerId = 'p1';
      const Player expectedPlayer = Player(
        id: playerId,
        username: 'username 1',
      );
      playerRepository.mockGetPlayerById(player: expectedPlayer);
      final container = makeProviderContainer();

      final Player? player = await container.read(
        playerProvider(playerId: playerId).future,
      );

      expect(player, expectedPlayer);
    },
  );
}
