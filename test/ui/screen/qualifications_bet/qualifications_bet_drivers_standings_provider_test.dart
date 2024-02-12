import 'package:betgrid/auth/auth_service.dart';
import 'package:betgrid/data/repository/grand_prix_bet/grand_prix_bet_repository.dart';
import 'package:betgrid/ui/riverpod_provider/grand_prix_id_provider.dart';
import 'package:betgrid/ui/screen/qualifications_bet/provider/qualifications_bet_drivers_standings_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/grand_prix_bet_creator.dart';
import '../../../mock/auth/mock_auth_service.dart';
import '../../../mock/data/repository/mock_grand_prix_bet_repository.dart';
import '../../../mock/listener.dart';

void main() {
  final authService = MockAuthService();
  final grandPrixBetRepository = MockGrandPrixBetRepository();
  const String loggedUserId = 'u1';
  const String grandPrixId = 'gp1';
  late Listener<AsyncValue<List<String?>?>> listener;

  ProviderContainer makeProviderContainer(
    String grandPrixId,
    MockAuthService authService,
    MockGrandPrixBetRepository grandPrixBetRepository,
  ) {
    final container = ProviderContainer(
      overrides: [
        grandPrixIdProvider.overrideWithValue(grandPrixId),
        authServiceProvider.overrideWithValue(authService),
        grandPrixBetRepositoryProvider.overrideWithValue(
          grandPrixBetRepository,
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUp(() {
    authService.mockGetLoggedUserId(loggedUserId);
    grandPrixBetRepository.mockGetGrandPrixBetByGrandPrixId(
      createGrandPrixBet(grandPrixId: grandPrixId),
    );
    listener = Listener<AsyncValue<List<String?>?>>();
  });

  tearDown(() {
    reset(authService);
    reset(grandPrixBetRepository);
  });

  test(
    'build, '
    'should watch to grand prix bet and emit its quali standings',
    () async {
      final List<String> qualiStandings = ['d1', 'd2', 'd5', 'd3'];
      grandPrixBetRepository.mockGetGrandPrixBetByGrandPrixId(
        createGrandPrixBet(
          grandPrixId: grandPrixId,
          qualiStandingsByDriverIds: qualiStandings,
        ),
      );
      final container = makeProviderContainer(
        grandPrixId,
        authService,
        grandPrixBetRepository,
      );
      container.listen(
        qualificationsBetDriversStandingsProvider,
        listener,
        fireImmediately: true,
      );

      await expectLater(
        container.read(qualificationsBetDriversStandingsProvider.future),
        completion(qualiStandings),
      );
      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<List<String?>?>(),
            ),
        () => listener(
              const AsyncLoading<List<String?>?>(),
              AsyncData(qualiStandings),
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

  test(
    'onBeginDriversOrdering, '
    'should set state as list with 20 null elements',
    () async {
      final List<String?> expectedList = [for (int i = 0; i < 20; i++) null];
      final container = makeProviderContainer(
        grandPrixId,
        authService,
        grandPrixBetRepository,
      );
      container.listen(
        qualificationsBetDriversStandingsProvider,
        listener,
        fireImmediately: true,
      );

      container
          .read(qualificationsBetDriversStandingsProvider.notifier)
          .onBeginDriversOrdering();

      await expectLater(
        container.read(qualificationsBetDriversStandingsProvider.future),
        completion(expectedList),
      );
    },
  );

  test(
    'onPositionDriverChanged, '
    'should update driver id on given index in state list',
    () async {
      const int index = 5;
      const String driverId = 'd2';
      final List<String?> expectedList = List.generate(
        20,
        (i) => index == i ? driverId : null,
      );
      final container = makeProviderContainer(
        grandPrixId,
        authService,
        grandPrixBetRepository,
      );
      container.listen(
        qualificationsBetDriversStandingsProvider,
        listener,
        fireImmediately: true,
      );
      final notifier = container.read(
        qualificationsBetDriversStandingsProvider.notifier,
      );

      notifier.onBeginDriversOrdering();
      notifier.onPositionDriverChanged(index, driverId);

      await expectLater(
        container.read(qualificationsBetDriversStandingsProvider.future),
        completion(expectedList),
      );
    },
  );

  test(
    'saveStandings, '
    'should should call method from GrandPrixBetRepository to update bet with '
    'new qualifications standings',
    () async {
      const String grandPrixBetId = 'gpb1';
      final List<String?> standings = List.generate(20, (_) => null);
      final List<String?> updatedStandings = List.generate(
        20,
        (index) => switch (index) {
          1 => 'd4',
          5 => 'd9',
          11 => 'd1',
          _ => null,
        },
      );
      grandPrixBetRepository.mockGetGrandPrixBetByGrandPrixId(
        createGrandPrixBet(
          id: grandPrixBetId,
          qualiStandingsByDriverIds: standings,
        ),
      );
      grandPrixBetRepository.mockUpdateGrandPrixBet();
      final container = makeProviderContainer(
        grandPrixId,
        authService,
        grandPrixBetRepository,
      );
      container.listen(
        qualificationsBetDriversStandingsProvider,
        listener,
        fireImmediately: true,
      );
      final notifier = container.read(
        qualificationsBetDriversStandingsProvider.notifier,
      );

      await notifier.future;
      notifier.onPositionDriverChanged(1, 'd4');
      notifier.onPositionDriverChanged(5, 'd9');
      notifier.onPositionDriverChanged(11, 'd1');
      await notifier.saveStandings();

      verify(
        () => grandPrixBetRepository.updateGrandPrixBet(
          userId: loggedUserId,
          grandPrixBetId: grandPrixBetId,
          qualiStandingsByDriverIds: updatedStandings,
        ),
      ).called(1);
    },
  );
}
