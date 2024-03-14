import 'package:betgrid/data/repository/auth/auth_repository.dart';
import 'package:betgrid/data/repository/grand_prix/grand_prix_repository.dart';
import 'package:betgrid/data/repository/grand_prix_bet/grand_prix_bet_repository.dart';
import 'package:betgrid/ui/provider/grand_prix_bet/all_grand_prix_bets_initialization_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../creator/grand_prix_bet_creator.dart';
import '../../creator/grand_prix_creator.dart';
import '../../mock/data/repository/mock_auth_repository.dart';
import '../../mock/data/repository/mock_grand_prix_bet_repository.dart';
import '../../mock/data/repository/mock_grand_prix_repository.dart';
import '../../mock/listener.dart';

void main() {
  final authService = MockAuthRepository();
  final grandPrixRepository = MockGrandPrixRepository();
  final grandPrixBetRepository = MockGrandPrixBetRepository();

  ProviderContainer makeProviderContainer() {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(authService),
        grandPrixRepositoryProvider.overrideWithValue(grandPrixRepository),
        grandPrixBetRepositoryProvider
            .overrideWithValue(grandPrixBetRepository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  tearDown(() {
    reset(authService);
    reset(grandPrixRepository);
    reset(grandPrixBetRepository);
  });

  test(
    'logged user id is null, '
    'should do nothing',
    () async {
      authService.mockGetLoggedUserId(null);
      final container = makeProviderContainer();
      final listener = Listener<void>();
      container.listen(
        allGrandPrixBetsInitializationProvider,
        listener,
        fireImmediately: true,
      );

      await container.read(allGrandPrixBetsInitializationProvider.future);

      verify(() => authService.loggedUserId$).called(1);
    },
  );

  test(
    'logged user id is null, '
    'should not initialize grand prix bets if they exist',
    () async {
      const String loggedUserId = 'u1';
      authService.mockGetLoggedUserId(loggedUserId);
      grandPrixBetRepository.mockGetAllGrandPrixBets([
        createGrandPrixBet(id: 'gpb1'),
        createGrandPrixBet(id: 'gpb2'),
      ]);
      final container = makeProviderContainer();
      final listener = Listener<void>();
      container.listen(
        allGrandPrixBetsInitializationProvider,
        listener,
        fireImmediately: true,
      );

      await container.read(allGrandPrixBetsInitializationProvider.future);

      verify(() => authService.loggedUserId$).called(1);
      verify(
        () => grandPrixBetRepository.getAllGrandPrixBets(
          playerId: loggedUserId,
        ),
      ).called(1);
    },
  );

  test(
    'logged user id is null, '
    'should initialize grand prix bets with default params if they do not exist',
    () async {
      const String loggedUserId = 'u1';
      final List<String?> defaultQualiStandings =
          List.generate(20, (_) => null);
      final List<String?> defaultDnfDrivers = List.generate(3, (_) => null);
      authService.mockGetLoggedUserId(loggedUserId);
      grandPrixBetRepository.mockGetAllGrandPrixBets([]);
      grandPrixRepository.mockGetAllGrandPrixes([
        createGrandPrix(id: 'gp1'),
        createGrandPrix(id: 'gp2'),
        createGrandPrix(id: 'gp3'),
      ]);
      grandPrixBetRepository.mockAddGrandPrixBets();
      final container = makeProviderContainer();
      final listener = Listener<void>();
      container.listen(
        allGrandPrixBetsInitializationProvider,
        listener,
        fireImmediately: true,
      );

      await container.read(allGrandPrixBetsInitializationProvider.future);

      verify(() => authService.loggedUserId$).called(1);
      verify(
        () => grandPrixBetRepository.getAllGrandPrixBets(
          playerId: loggedUserId,
        ),
      ).called(1);
      verify(grandPrixRepository.getAllGrandPrixes).called(1);
      verify(
        () => grandPrixBetRepository.addGrandPrixBets(
          playerId: loggedUserId,
          grandPrixBets: [
            createGrandPrixBet(
              playerId: loggedUserId,
              grandPrixId: 'gp1',
              qualiStandingsByDriverIds: defaultQualiStandings,
              dnfDriverIds: defaultDnfDrivers,
            ),
            createGrandPrixBet(
              playerId: loggedUserId,
              grandPrixId: 'gp2',
              qualiStandingsByDriverIds: defaultQualiStandings,
              dnfDriverIds: defaultDnfDrivers,
            ),
            createGrandPrixBet(
              playerId: loggedUserId,
              grandPrixId: 'gp3',
              qualiStandingsByDriverIds: defaultQualiStandings,
              dnfDriverIds: defaultDnfDrivers,
            ),
          ],
        ),
      ).called(1);
    },
  );
}
