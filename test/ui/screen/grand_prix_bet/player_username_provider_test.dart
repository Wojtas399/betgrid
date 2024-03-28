import 'package:betgrid/data/repository/player/player_repository_method_providers.dart';
import 'package:betgrid/model/player.dart';
import 'package:betgrid/ui/screen/grand_prix_bet/provider/player_id_provider.dart';
import 'package:betgrid/ui/screen/grand_prix_bet/provider/player_username_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  ProviderContainer makeProviderContainer({
    String? playerId,
    Player? player,
  }) {
    final container = ProviderContainer(
      overrides: [
        playerIdProvider.overrideWithValue(playerId),
        if (playerId != null)
          playerProvider(playerId: playerId).overrideWith(
            (_) => Stream.value(player),
          ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test(
    'player id is null, '
    'should emit null',
    () async {
      final container = makeProviderContainer();

      final String? playerUsername = await container.read(
        playerUsernameProvider.future,
      );

      expect(playerUsername, null);
    },
  );

  test(
    'should get player and should emit its username',
    () async {
      const String playerId = 'p1';
      const String expectedUsername = 'username';
      const Player player = Player(id: playerId, username: expectedUsername);
      final container = makeProviderContainer(
        playerId: playerId,
        player: player,
      );

      final String? playerUsername = await container.read(
        playerUsernameProvider.future,
      );

      expect(playerUsername, expectedUsername);
    },
  );
}
