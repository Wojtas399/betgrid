import 'package:betgrid/auth/auth_service.dart';
import 'package:betgrid/data/repository/grand_prix/grand_prix_repository.dart';
import 'package:betgrid/model/grand_prix.dart';
import 'package:betgrid/ui/provider/all_grand_prixes_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mock/auth/mock_auth_service.dart';
import '../../mock/data/repository/mock_grand_prix_repository.dart';
import '../../mock/listener.dart';

void main() {
  final authService = MockAuthService();
  final grandPrixRepository = MockGrandPrixRepository();

  ProviderContainer makeProviderContainer(
    MockAuthService authService,
    MockGrandPrixRepository grandPrixRepository,
  ) {
    final container = ProviderContainer(
      overrides: [
        authServiceProvider.overrideWithValue(authService),
        grandPrixRepositoryProvider.overrideWithValue(grandPrixRepository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUpAll(() {
    registerFallbackValue(const AsyncData<List<GrandPrix>?>([]));
  });

  tearDown(() {
    reset(authService);
    reset(grandPrixRepository);
  });

  const String loggedUserId = 'u1';
  final GrandPrix gp1 = GrandPrix(
    id: 'gp1',
    name: 'Grand Prix 1',
    countryAlpha2Code: 'BH',
    startDate: DateTime(2023, 1, 1),
    endDate: DateTime(2023, 1, 3),
  );
  final GrandPrix gp2 = GrandPrix(
    id: 'gp2',
    name: 'Grand Prix 2',
    countryAlpha2Code: 'PL',
    startDate: DateTime(2023, 1, 5),
    endDate: DateTime(2023, 1, 7),
  );
  final GrandPrix gp3 = GrandPrix(
    id: 'gp3',
    name: 'Grand Prix 3',
    countryAlpha2Code: 'XD',
    startDate: DateTime(2023, 1, 9),
    endDate: DateTime(2023, 1, 11),
  );

  test(
    'should return null if logged user does not exist',
    () async {
      authService.mockGetLoggedUserId(null);
      final container = makeProviderContainer(authService, grandPrixRepository);
      final listener = Listener<AsyncValue<List<GrandPrix>?>>();
      container.listen(
        allGrandPrixesProvider,
        listener,
        fireImmediately: true,
      );

      await container.read(allGrandPrixesProvider.future);

      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<List<GrandPrix>?>(),
            ),
        () => listener(
              const AsyncLoading<List<GrandPrix>?>(),
              const AsyncData<List<GrandPrix>?>(null),
            ),
      ]);
      verifyNoMoreInteractions(listener);
      verify(() => authService.loggedUserId$).called(1);
    },
  );

  test(
    'should load all grand prixes and return them sorted by date',
    () async {
      authService.mockGetLoggedUserId(loggedUserId);
      grandPrixRepository.mockLoadAllGrandPrixes([gp3, gp1, gp2]);
      final container = makeProviderContainer(authService, grandPrixRepository);
      final listener = Listener<AsyncValue<List<GrandPrix>?>>();
      container.listen(
        allGrandPrixesProvider,
        listener,
        fireImmediately: true,
      );

      await expectLater(
        container.read(allGrandPrixesProvider.future),
        completion([gp1, gp2, gp3]),
      );
      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<List<GrandPrix>?>(),
            ),
        () => listener(
              const AsyncLoading<List<GrandPrix>?>(),
              any(that: isA<AsyncData<List<GrandPrix>?>>()),
            ),
      ]);
      verifyNoMoreInteractions(listener);
      verify(() => authService.loggedUserId$).called(1);
      verify(grandPrixRepository.loadAllGrandPrixes).called(1);
    },
  );
}
