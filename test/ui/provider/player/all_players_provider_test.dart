import 'package:betgrid/data/repository/auth/auth_repository.dart';
import 'package:betgrid/data/repository/player/player_repository.dart';
import 'package:betgrid/model/player.dart';
import 'package:betgrid/ui/provider/player/all_players_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mock/data/repository/mock_auth_repository.dart';
import '../../../mock/data/repository/mock_player_repository.dart';
import '../../../mock/listener.dart';

void main() {
  final authService = MockAuthRepository();
  final playerRepository = MockPlayerRepository();

  ProviderContainer makeProviderContainer() {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(authService),
        playerRepositoryProvider.overrideWithValue(playerRepository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  tearDown(() {
    reset(authService);
    reset(playerRepository);
  });

  test(
    'logged user id is null, '
    'should emit null',
    () async {
      authService.mockGetLoggedUserId(null);
      final container = makeProviderContainer();
      final listener = Listener<AsyncValue<List<Player>?>>();
      container.listen(
        allPlayersProvider,
        listener,
        fireImmediately: true,
      );

      await expectLater(
        container.read(allPlayersProvider.future),
        completion(null),
      );
      verifyNever(
        () => playerRepository.getAllPlayersWithoutGiven(
          playerId: any(named: 'playerId'),
        ),
      );
    },
  );

  test(
    'should listen to logged user id and '
    'should emit players got directly from player repository without '
    'player with id equal to logged user id',
    () async {
      const String loggedUserId = 'u1';
      const List<Player> players = [
        Player(id: 'p1', username: 'username 1', avatarUrl: 'avatar/url/1'),
        Player(id: 'p2', username: 'username 2', avatarUrl: 'avatar/url/2'),
        Player(id: 'p3', username: 'username 3', avatarUrl: 'avatar/url/3'),
      ];
      authService.mockGetLoggedUserId(loggedUserId);
      playerRepository.mockGetAllPlayersWithoutGiven(players: players);
      final container = makeProviderContainer();
      final listener = Listener<AsyncValue<List<Player>?>>();
      container.listen(
        allPlayersProvider,
        listener,
        fireImmediately: true,
      );

      await expectLater(
        container.read(allPlayersProvider.future),
        completion(players),
      );
      verify(
        () => playerRepository.getAllPlayersWithoutGiven(
          playerId: loggedUserId,
        ),
      ).called(1);
    },
  );
}
