import 'package:betgrid/auth/auth_service.dart';
import 'package:betgrid/data/repository/grand_prix_bet/grand_prix_bet_repository.dart';
import 'package:betgrid/model/grand_prix_bet.dart';
import 'package:betgrid/ui/riverpod_provider/grand_prix_bet/grand_prix_bet_notifier_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../creator/grand_prix_bet_creator.dart';
import '../../mock/auth/mock_auth_service.dart';
import '../../mock/data/repository/mock_grand_prix_bet_repository.dart';
import '../../mock/listener.dart';

void main() {
  final authService = MockAuthService();
  final grandPrixBetRepository = MockGrandPrixBetRepository();
  const String grandPrixBetId = 'gpb1';

  ProviderContainer makeProviderContainer(
    MockAuthService authService,
    MockGrandPrixBetRepository grandPrixBetRepository,
  ) {
    final container = ProviderContainer(
      overrides: [
        authServiceProvider.overrideWithValue(authService),
        grandPrixBetRepositoryProvider.overrideWithValue(
          grandPrixBetRepository,
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  tearDown(() {
    reset(authService);
    reset(grandPrixBetRepository);
  });

  test(
    'build, '
    'logged user does not exist, '
    'should return null',
    () async {
      authService.mockGetLoggedUserId(null);
      final container = makeProviderContainer(
        authService,
        grandPrixBetRepository,
      );
      final listener = Listener<AsyncValue<GrandPrixBet?>>();
      container.listen(
        grandPrixBetNotifierProvider(grandPrixBetId),
        listener,
        fireImmediately: true,
      );

      await expectLater(
        container.read(grandPrixBetNotifierProvider(grandPrixBetId).future),
        completion(null),
      );
      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<GrandPrixBet?>(),
            ),
        () => listener(
              const AsyncLoading<GrandPrixBet?>(),
              const AsyncData<GrandPrixBet?>(null),
            ),
      ]);
      verifyNoMoreInteractions(listener);
      verify(() => authService.loggedUserId$).called(1);
    },
  );

  test(
    'should emit grand prix bet got from GrandPrixBetRepository',
    () async {
      const String loggedUserId = 'u1';
      const String grandPrixId = 'gp1';
      final GrandPrixBet grandPrixBet = createGrandPrixBet(
        id: grandPrixBetId,
        grandPrixId: grandPrixId,
      );
      authService.mockGetLoggedUserId(loggedUserId);
      grandPrixBetRepository.mockGetGrandPrixBetByGrandPrixId(grandPrixBet);
      final container = makeProviderContainer(
        authService,
        grandPrixBetRepository,
      );
      final listener = Listener<AsyncValue<GrandPrixBet?>>();
      container.listen(
        grandPrixBetNotifierProvider(grandPrixId),
        listener,
        fireImmediately: true,
      );

      await expectLater(
        container.read(grandPrixBetNotifierProvider(grandPrixId).future),
        completion(grandPrixBet),
      );
      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<GrandPrixBet?>(),
            ),
        () => listener(
              const AsyncLoading<GrandPrixBet?>(),
              AsyncData<GrandPrixBet?>(grandPrixBet),
            ),
      ]);
      verifyNoMoreInteractions(listener);
      verify(() => authService.loggedUserId$).called(1);
      verify(
        () => grandPrixBetRepository.getGrandPrixBetByGrandPrixId(
          userId: loggedUserId,
          grandPrixId: grandPrixId,
        ),
      ).called(1);
    },
  );
}
