import 'package:betgrid/data/repository/auth/auth_repository.dart';
import 'package:betgrid/data/repository/grand_prix/grand_prix_repository.dart';
import 'package:betgrid/data/repository/grand_prix_bet/grand_prix_bet_repository.dart';
import 'package:betgrid/model/grand_prix.dart';
import 'package:betgrid/model/grand_prix_bet.dart';
import 'package:betgrid/ui/screen/home/controller/grand_prix_bets_initialization_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/grand_prix_bet_creator.dart';
import '../../../creator/grand_prix_creator.dart';
import '../../../mock/data/repository/mock_auth_repository.dart';
import '../../../mock/data/repository/mock_grand_prix_bet_repository.dart';
import '../../../mock/data/repository/mock_grand_prix_repository.dart';

void main() {
  final authRepository = MockAuthRepository();
  final grandPrixRepository = MockGrandPrixRepository();
  final grandPrixBetRepository = MockGrandPrixBetRepository();

  ProviderContainer makeProviderContainer() {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    return container;
  }

  setUpAll(() {
    GetIt.I.registerSingleton<AuthRepository>(authRepository);
    GetIt.I.registerLazySingleton<GrandPrixRepository>(
      () => grandPrixRepository,
    );
    GetIt.I.registerLazySingleton<GrandPrixBetRepository>(
      () => grandPrixBetRepository,
    );
  });

  tearDown(() {
    reset(authRepository);
  });

  test(
    'initialize, '
    'logged user id is null, '
    'should do nothing',
    () async {
      authRepository.mockGetLoggedUserId(null);
      final container = makeProviderContainer();

      await container
          .read(grandPrixBetsInitializationControllerProvider.notifier)
          .initialize();
    },
  );

  test(
    'initialize, '
    'should not initialize grand prix bets if they exist',
    () async {
      const String loggedUserId = 'u1';
      final List<GrandPrixBet> grandPrixBets = [
        createGrandPrixBet(id: 'gpb1'),
        createGrandPrixBet(id: 'gpb2'),
      ];
      authRepository.mockGetLoggedUserId(loggedUserId);
      grandPrixBetRepository.mockGetAllGrandPrixBetsForPlayer(
        grandPrixBets: grandPrixBets,
      );
      final container = makeProviderContainer();

      await container
          .read(grandPrixBetsInitializationControllerProvider.notifier)
          .initialize();
    },
  );

  test(
    'initialize, '
    'should initialize grand prix bets with default params if they do not exist',
    () async {
      const String loggedUserId = 'u1';
      final List<String?> defaultQualiStandings =
          List.generate(20, (_) => null);
      final List<GrandPrix> allGrandPrixes = [
        createGrandPrix(id: 'gp1'),
        createGrandPrix(id: 'gp2'),
        createGrandPrix(id: 'gp3'),
      ];
      final List<String?> defaultDnfDrivers = List.generate(3, (_) => null);
      authRepository.mockGetLoggedUserId(loggedUserId);
      grandPrixBetRepository.mockGetAllGrandPrixBetsForPlayer();
      grandPrixRepository.mockGetAllGrandPrixes(allGrandPrixes);
      grandPrixBetRepository.mockAddGrandPrixBets();
      final container = makeProviderContainer();

      await container
          .read(grandPrixBetsInitializationControllerProvider.notifier)
          .initialize();

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

  test(
    'initialize, '
    'should initialize grand prix bets with default params if list of bets is '
    'empty',
    () async {
      const String loggedUserId = 'u1';
      final List<String?> defaultQualiStandings =
          List.generate(20, (_) => null);
      final List<GrandPrix> allGrandPrixes = [
        createGrandPrix(id: 'gp1'),
        createGrandPrix(id: 'gp2'),
        createGrandPrix(id: 'gp3'),
      ];
      final List<String?> defaultDnfDrivers = List.generate(3, (_) => null);
      authRepository.mockGetLoggedUserId(loggedUserId);
      grandPrixBetRepository.mockGetAllGrandPrixBetsForPlayer(
        grandPrixBets: [],
      );
      grandPrixRepository.mockGetAllGrandPrixes(allGrandPrixes);
      grandPrixBetRepository.mockAddGrandPrixBets();
      final container = makeProviderContainer();

      await container
          .read(grandPrixBetsInitializationControllerProvider.notifier)
          .initialize();

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
