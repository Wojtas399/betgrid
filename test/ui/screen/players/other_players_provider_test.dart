import 'package:betgrid/data/repository/auth/auth_repository_method_providers.dart';
import 'package:betgrid/data/repository/player/player_repository_method_providers.dart';
import 'package:betgrid/model/player.dart';
import 'package:betgrid/ui/screen/players/provider/other_players_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  ProviderContainer makeProviderContainer({
    String? loggedUserId,
    List<Player>? allPlayers,
  }) {
    final container = ProviderContainer(
      overrides: [
        loggedUserIdProvider.overrideWith((_) => Stream.value(loggedUserId)),
        allPlayersProvider.overrideWith((_) => Stream.value(allPlayers)),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test(
    'logged user id is null, '
    'should return null',
    () async {
      final container = makeProviderContainer();

      final List<Player>? otherPlayers = await container.read(
        otherPlayersProvider.future,
      );

      expect(otherPlayers, null);
    },
  );

  test(
    'should get all players and should return players with id different than id '
    'of logged user',
    () async {
      const String loggedUserId = 'u1';
      const List<Player> allPlayers = [
        Player(id: 'p1', username: 'username 1'),
        Player(id: loggedUserId, username: 'username 2'),
        Player(id: 'p2', username: 'username 3'),
        Player(id: 'p3', username: 'username 4'),
      ];
      final List<Player> expectedPlayers = [
        allPlayers.first,
        allPlayers[2],
        allPlayers.last,
      ];
      final container = makeProviderContainer(
        loggedUserId: loggedUserId,
        allPlayers: allPlayers,
      );

      final List<Player>? otherPlayers = await container.read(
        otherPlayersProvider.future,
      );

      expect(otherPlayers, expectedPlayers);
    },
  );
}
