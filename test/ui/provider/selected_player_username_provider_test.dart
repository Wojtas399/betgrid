import 'package:betgrid/auth/auth_service.dart';
import 'package:betgrid/data/repository/player/player_repository.dart';
import 'package:betgrid/model/player.dart';
import 'package:betgrid/ui/provider/grand_prix_bet_player_username_provider.dart';
import 'package:betgrid/ui/provider/player_id_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mock/auth/mock_auth_service.dart';
import '../../mock/data/repository/mock_player_repository.dart';
import '../../mock/listener.dart';

void main() {
  final authService = MockAuthService();
  final playerRepository = MockPlayerRepository();

  ProviderContainer makeProviderContainer(String? playerId) {
    final container = ProviderContainer(
      overrides: [
        playerIdProvider.overrideWithValue(playerId),
        authServiceProvider.overrideWithValue(authService),
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
    'player id is null, '
    'should emit null',
    () async {
      final container = makeProviderContainer(null);
      final listener = Listener<AsyncValue<String?>>();
      container.listen(
        grandPrixBetPlayerUsernameProvider,
        listener,
        fireImmediately: true,
      );

      await expectLater(
        container.read(grandPrixBetPlayerUsernameProvider.future),
        completion(null),
      );
      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<String?>(),
            ),
        () => listener(
              const AsyncLoading<String?>(),
              const AsyncData<String?>(null),
            ),
      ]);
      verifyNoMoreInteractions(listener);
      verifyNever(() => authService.loggedUserId$);
      verifyNever(
        () => playerRepository.getPlayerById(
          playerId: any(named: 'playerId'),
        ),
      );
    },
  );

  test(
    'logged user id is null'
    'should emit null',
    () async {
      authService.mockGetLoggedUserId(null);
      final container = makeProviderContainer('u1');
      final listener = Listener<AsyncValue<String?>>();
      container.listen(
        grandPrixBetPlayerUsernameProvider,
        listener,
        fireImmediately: true,
      );

      await expectLater(
        container.read(grandPrixBetPlayerUsernameProvider.future),
        completion(null),
      );
      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<String?>(),
            ),
        () => listener(
              const AsyncLoading<String?>(),
              const AsyncData<String?>(null),
            ),
      ]);
      verifyNoMoreInteractions(listener);
      verify(() => authService.loggedUserId$).called(1);
      verifyNever(
        () => playerRepository.getPlayerById(
          playerId: any(named: 'playerId'),
        ),
      );
    },
  );

  test(
    'player id is equal to logged user id'
    'should emit null',
    () async {
      authService.mockGetLoggedUserId('u1');
      final container = makeProviderContainer('u1');
      final listener = Listener<AsyncValue<String?>>();
      container.listen(
        grandPrixBetPlayerUsernameProvider,
        listener,
        fireImmediately: true,
      );

      await expectLater(
        container.read(grandPrixBetPlayerUsernameProvider.future),
        completion(null),
      );
      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<String?>(),
            ),
        () => listener(
              const AsyncLoading<String?>(),
              const AsyncData<String?>(null),
            ),
      ]);
      verifyNoMoreInteractions(listener);
      verify(() => authService.loggedUserId$).called(1);
      verifyNever(
        () => playerRepository.getPlayerById(
          playerId: any(named: 'playerId'),
        ),
      );
    },
  );

  test(
    'should get player from player repository and should emit its username',
    () async {
      const String playerId = 'p1';
      const String expectedUsername = 'username';
      const Player player = Player(id: playerId, username: expectedUsername);
      authService.mockGetLoggedUserId('u2');
      playerRepository.mockGetPlayerById(player: player);
      final container = makeProviderContainer(playerId);
      final listener = Listener<AsyncValue<String?>>();
      container.listen(
        grandPrixBetPlayerUsernameProvider,
        listener,
        fireImmediately: true,
      );

      await expectLater(
        container.read(grandPrixBetPlayerUsernameProvider.future),
        completion(expectedUsername),
      );
      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<String?>(),
            ),
        () => listener(
              const AsyncLoading<String?>(),
              const AsyncData<String?>(expectedUsername),
            ),
      ]);
      verifyNoMoreInteractions(listener);
      verify(() => authService.loggedUserId$).called(1);
      verify(
        () => playerRepository.getPlayerById(playerId: playerId),
      ).called(1);
    },
  );
}
