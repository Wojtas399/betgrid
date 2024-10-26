import 'package:betgrid/model/driver.dart';
import 'package:betgrid/model/grand_prix.dart';
import 'package:betgrid/model/grand_prix_bet.dart';
import 'package:betgrid/model/grand_prix_bet_points.dart';
import 'package:betgrid/model/grand_prix_results.dart';
import 'package:betgrid/model/player.dart';
import 'package:betgrid/ui/screen/grand_prix_bet/cubit/grand_prix_bet_cubit.dart';
import 'package:betgrid/ui/screen/grand_prix_bet/cubit/grand_prix_bet_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/driver_creator.dart';
import '../../../creator/grand_prix_bet_creator.dart';
import '../../../creator/grand_prix_bet_points_creator.dart';
import '../../../creator/grand_prix_creator.dart';
import '../../../creator/grand_prix_results_creator.dart';
import '../../../creator/player_creator.dart';
import '../../../mock/data/repository/mock_auth_repository.dart';
import '../../../mock/data/repository/mock_driver_repository.dart';
import '../../../mock/data/repository/mock_grand_prix_bet_points_repository.dart';
import '../../../mock/data/repository/mock_grand_prix_bet_repository.dart';
import '../../../mock/data/repository/mock_grand_prix_repository.dart';
import '../../../mock/data/repository/mock_grand_prix_results_repository.dart';
import '../../../mock/data/repository/mock_player_repository.dart';
import '../../../mock/ui/mock_date_service.dart';

void main() {
  final authRepository = MockAuthRepository();
  final grandPrixRepository = MockGrandPrixRepository();
  final playerRepository = MockPlayerRepository();
  final grandPrixBetRepository = MockGrandPrixBetRepository();
  final grandPrixResultsRepository = MockGrandPrixResultsRepository();
  final grandPrixBetPointsRepository = MockGrandPrixBetPointsRepository();
  final driverRepository = MockDriverRepository();
  final dateService = MockDateService();

  GrandPrixBetCubit createCubit() => GrandPrixBetCubit(
        authRepository,
        grandPrixRepository,
        playerRepository,
        grandPrixBetRepository,
        grandPrixResultsRepository,
        grandPrixBetPointsRepository,
        driverRepository,
        dateService,
      );

  tearDown(() {
    reset(authRepository);
    reset(grandPrixRepository);
    reset(playerRepository);
    reset(grandPrixBetRepository);
    reset(grandPrixResultsRepository);
    reset(grandPrixBetPointsRepository);
    reset(driverRepository);
    reset(dateService);
  });

  group(
    'initialize, '
    "should load player's username, grand prix name, results, bet, bet "
    'points and allDrivers',
    () {
      const String playerId = 'p1';
      const String grandPrixId = 'gp1';
      final Player player = const PlayerCreator(
        username: 'username',
      ).createEntity();
      final GrandPrix grandPrix = GrandPrixCreator(
        name: 'grand prix',
        startDate: DateTime(2024, 3, 3),
      ).createEntity();
      final GrandPrixBet grandPrixBet = GrandPrixBetCreator(
        id: 'gpb1',
      ).createEntity();
      final GrandPrixResults grandPrixResults = const GrandPrixResultsCreator(
        id: 'gpr1',
      ).createEntity();
      final GrandPrixBetPoints grandPrixBetPoints =
          const GrandPrixBetPointsCreator(
        id: 'gpbp1',
      ).createEntity();
      final List<Driver> allDrivers = [
        const DriverCreator(id: 'd1').createEntity(),
        const DriverCreator(id: 'd2').createEntity(),
        const DriverCreator(id: 'd3').createEntity(),
      ];
      final DateTime now = DateTime(2024, 2, 2);
      const bool canEdit = false;
      final GrandPrixBetState expectedState = GrandPrixBetState(
        status: GrandPrixBetStateStatus.completed,
        canEdit: canEdit,
        playerUsername: player.username,
        grandPrixId: grandPrixId,
        grandPrixName: grandPrix.name,
        grandPrixBet: grandPrixBet,
        grandPrixResults: grandPrixResults,
        grandPrixBetPoints: grandPrixBetPoints,
        allDrivers: allDrivers,
      );

      setUp(() {
        playerRepository.mockGetPlayerById(player: player);
        grandPrixRepository.mockGetGrandPrixById(
          expectedGrandPrix: grandPrix,
        );
        grandPrixBetRepository.mockGetGrandPrixBetForPlayerAndGrandPrix(
          grandPrixBet: grandPrixBet,
        );
        grandPrixResultsRepository.mockGetGrandPrixResultsForGrandPrix(
          results: grandPrixResults,
        );
        grandPrixBetPointsRepository
            .mockGetGrandPrixBetPointsForPlayerAndGrandPrix(
          grandPrixBetPoints: grandPrixBetPoints,
        );
        driverRepository.mockGetAllDrivers(allDrivers: allDrivers);
        dateService.mockGetNow(now: now);
        dateService.mockIsDateABeforeDateB(expected: canEdit);
      });

      tearDown(() {
        verify(() => authRepository.loggedUserId$).called(1);
        verify(
          () => playerRepository.getPlayerById(playerId: playerId),
        ).called(1);
        verify(
          () => grandPrixRepository.getGrandPrixById(
            grandPrixId: grandPrixId,
          ),
        ).called(1);
        verify(
          () => grandPrixBetRepository.getGrandPrixBetForPlayerAndGrandPrix(
            playerId: playerId,
            grandPrixId: grandPrixId,
          ),
        ).called(1);
        verify(
          () => grandPrixResultsRepository.getGrandPrixResultsForGrandPrix(
            grandPrixId: grandPrixId,
          ),
        ).called(1);
        verify(
          () => grandPrixBetPointsRepository
              .getGrandPrixBetPointsForPlayerAndGrandPrix(
            playerId: playerId,
            grandPrixId: grandPrixId,
          ),
        ).called(1);
        verify(driverRepository.getAllDrivers).called(1);
        verify(
          () => dateService.isDateABeforeDateB(now, grandPrix.startDate),
        ).called(1);
      });

      blocTest(
        'should set isPlayerIdSameAsLoggedUserId param as true if player is '
        'logged user',
        build: () => createCubit(),
        setUp: () => authRepository.mockGetLoggedUserId(playerId),
        act: (cubit) => cubit.initialize(
          playerId: playerId,
          grandPrixId: grandPrixId,
        ),
        expect: () => [
          expectedState.copyWith(
            isPlayerIdSameAsLoggedUserId: true,
          ),
        ],
      );

      blocTest(
        'should set isPlayerIdSameAsLoggedUserId param as false if player is '
        'not logged user',
        build: () => createCubit(),
        setUp: () => authRepository.mockGetLoggedUserId('u1'),
        act: (cubit) => cubit.initialize(
          playerId: playerId,
          grandPrixId: grandPrixId,
        ),
        expect: () => [
          expectedState.copyWith(
            isPlayerIdSameAsLoggedUserId: false,
          ),
        ],
      );
    },
  );
}
