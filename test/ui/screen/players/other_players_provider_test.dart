import 'package:betgrid/data/repository/auth/auth_repository.dart';
import 'package:betgrid/data/repository/player/player_repository.dart';
import 'package:betgrid/model/player.dart';
import 'package:betgrid/ui/screen/players/provider/other_players_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mock/data/repository/mock_auth_repository.dart';
import '../../../mock/data/repository/mock_player_repository.dart';

void main() {
  final authRepository = MockAuthRepository();
  final playerRepository = MockPlayerRepository();

  setUpAll(() {
    GetIt.I.registerSingleton<AuthRepository>(authRepository);
    GetIt.I.registerLazySingleton<PlayerRepository>(() => playerRepository);
  });

  tearDown(() {
    reset(authRepository);
    reset(playerRepository);
  });

  test(
    'logged user id is null, '
    'should return null',
    () async {
      authRepository.mockGetLoggedUserId(null);
      final container = ProviderContainer();

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
      authRepository.mockGetLoggedUserId(loggedUserId);
      playerRepository.mockGetAllPlayers(players: allPlayers);
      final container = ProviderContainer();

      final List<Player>? otherPlayers = await container.read(
        otherPlayersProvider.future,
      );

      expect(otherPlayers, expectedPlayers);
    },
  );
}
