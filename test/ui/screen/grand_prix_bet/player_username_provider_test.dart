import 'package:betgrid/data/repository/player/player_repository.dart';
import 'package:betgrid/model/player.dart';
import 'package:betgrid/ui/screen/grand_prix_bet/provider/player_id_provider.dart';
import 'package:betgrid/ui/screen/grand_prix_bet/provider/player_username_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import '../../../mock/data/repository/mock_player_repository.dart';

void main() {
  final playerRepository = MockPlayerRepository();

  ProviderContainer makeProviderContainer({
    String? playerId,
  }) {
    final container = ProviderContainer(
      overrides: [
        playerIdProvider.overrideWithValue(playerId),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUpAll(() {
    GetIt.I.registerLazySingleton<PlayerRepository>(() => playerRepository);
  });

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
      playerRepository.mockGetPlayerById(player: player);
      final container = makeProviderContainer(
        playerId: playerId,
      );

      final String? playerUsername = await container.read(
        playerUsernameProvider.future,
      );

      expect(playerUsername, expectedUsername);
    },
  );
}
