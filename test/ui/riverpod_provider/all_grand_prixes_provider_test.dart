import 'package:betgrid/auth/auth_service.dart';
import 'package:betgrid/data/repository/grand_prix/grand_prix_repository.dart';
import 'package:betgrid/data/repository/grand_prix_bet/grand_prix_bet_repository.dart';
import 'package:betgrid/model/grand_prix.dart';
import 'package:betgrid/ui/riverpod_provider/all_grand_prixes_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../creator/grand_prix_bet_creator.dart';
import '../../mock/auth/mock_auth_service.dart';
import '../../mock/data/repository/mock_grand_prix_bet_repository.dart';
import '../../mock/data/repository/mock_grand_prix_repository.dart';
import '../../mock/listener.dart';

void main() {
  final authService = MockAuthService();
  final grandPrixRepository = MockGrandPrixRepository();
  final grandPrixBetRepository = MockGrandPrixBetRepository();

  ProviderContainer makeProviderContainer(
    MockAuthService authService,
    MockGrandPrixRepository grandPrixRepository,
    MockGrandPrixBetRepository grandPrixBetRepository,
  ) {
    final container = ProviderContainer(
      overrides: [
        authServiceProvider.overrideWithValue(authService),
        grandPrixRepositoryProvider.overrideWithValue(grandPrixRepository),
        grandPrixBetRepositoryProvider.overrideWithValue(
          grandPrixBetRepository,
        ),
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
    reset(grandPrixBetRepository);
  });

  const String loggedUserId = 'u1';
  final GrandPrix gp1 = GrandPrix(
    id: 'gp1',
    name: 'Grand Prix 1',
    startDate: DateTime(2023, 1, 1),
    endDate: DateTime(2023, 1, 3),
  );
  final GrandPrix gp2 = GrandPrix(
    id: 'gp2',
    name: 'Grand Prix 2',
    startDate: DateTime(2023, 1, 5),
    endDate: DateTime(2023, 1, 7),
  );
  final GrandPrix gp3 = GrandPrix(
    id: 'gp3',
    name: 'Grand Prix 3',
    startDate: DateTime(2023, 1, 9),
    endDate: DateTime(2023, 1, 11),
  );

  test(
    'should return null if logged user does not exist',
    () async {
      authService.mockGetLoggedUserId(null);
      final container = makeProviderContainer(
        authService,
        grandPrixRepository,
        grandPrixBetRepository,
      );
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
    'should load all grand prixes and return them sorted by date and '
    'should load grand prix bets and if they are not initialized '
    'should initialize them',
    () async {
      final List<String?> defaultQualiStandings =
          List.generate(20, (_) => null);
      authService.mockGetLoggedUserId(loggedUserId);
      grandPrixRepository.mockLoadAllGrandPrixes([gp3, gp1, gp2]);
      grandPrixBetRepository.mockGetAllGrandPrixBets(null);
      grandPrixBetRepository.mockAddGrandPrixBets();
      final container = makeProviderContainer(
        authService,
        grandPrixRepository,
        grandPrixBetRepository,
      );
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
      verify(
        () => grandPrixBetRepository.addGrandPrixBets(
          userId: loggedUserId,
          grandPrixBets: [
            createGrandPrixBet(
              grandPrixId: gp1.id,
              qualiStandingsByDriverIds: defaultQualiStandings,
            ),
            createGrandPrixBet(
              grandPrixId: gp2.id,
              qualiStandingsByDriverIds: defaultQualiStandings,
            ),
            createGrandPrixBet(
              grandPrixId: gp3.id,
              qualiStandingsByDriverIds: defaultQualiStandings,
            ),
          ],
        ),
      ).called(1);
    },
  );

  test(
    'should load all grand prixes and return them sorted by date and '
    'should load grand prix bets and if list of grand prix bets is empty '
    'should initialize them',
    () async {
      final List<String?> defaultQualiStandings =
          List.generate(20, (_) => null);
      authService.mockGetLoggedUserId(loggedUserId);
      grandPrixRepository.mockLoadAllGrandPrixes([gp3, gp1, gp2]);
      grandPrixBetRepository.mockGetAllGrandPrixBets([]);
      grandPrixBetRepository.mockAddGrandPrixBets();
      final container = makeProviderContainer(
        authService,
        grandPrixRepository,
        grandPrixBetRepository,
      );
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
      verify(
        () => grandPrixBetRepository.addGrandPrixBets(
          userId: loggedUserId,
          grandPrixBets: [
            createGrandPrixBet(
              grandPrixId: gp1.id,
              qualiStandingsByDriverIds: defaultQualiStandings,
            ),
            createGrandPrixBet(
              grandPrixId: gp2.id,
              qualiStandingsByDriverIds: defaultQualiStandings,
            ),
            createGrandPrixBet(
              grandPrixId: gp3.id,
              qualiStandingsByDriverIds: defaultQualiStandings,
            ),
          ],
        ),
      ).called(1);
    },
  );

  test(
    'build, '
    'should load and return all grand prixes sorted by date and '
    'should load grand prix bets and if they exist should not initialize them',
    () async {
      final List<String?> defaultQualiStandings =
          List.generate(20, (_) => null);
      authService.mockGetLoggedUserId(loggedUserId);
      grandPrixRepository.mockLoadAllGrandPrixes([gp3, gp1, gp2]);
      grandPrixBetRepository.mockGetAllGrandPrixBets([
        createGrandPrixBet(id: 'gpb1', grandPrixId: gp1.id),
        createGrandPrixBet(id: 'gpb2', grandPrixId: gp2.id),
        createGrandPrixBet(id: 'gpb3', grandPrixId: gp3.id),
      ]);
      grandPrixBetRepository.mockAddGrandPrixBets();
      final container = makeProviderContainer(
        authService,
        grandPrixRepository,
        grandPrixBetRepository,
      );
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
      verifyNever(
        () => grandPrixBetRepository.addGrandPrixBets(
          userId: loggedUserId,
          grandPrixBets: [
            createGrandPrixBet(
              grandPrixId: gp1.id,
              qualiStandingsByDriverIds: defaultQualiStandings,
            ),
            createGrandPrixBet(
              grandPrixId: gp2.id,
              qualiStandingsByDriverIds: defaultQualiStandings,
            ),
            createGrandPrixBet(
              grandPrixId: gp3.id,
              qualiStandingsByDriverIds: defaultQualiStandings,
            ),
          ],
        ),
      );
    },
  );
}
