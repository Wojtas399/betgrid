import 'package:betgrid/model/player.dart';
import 'package:betgrid/ui/screen/players/cubit/players_cubit.dart';
import 'package:betgrid/ui/screen/players/cubit/players_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/player_creator.dart';
import '../../../mock/data/repository/mock_auth_repository.dart';
import '../../../mock/data/repository/mock_player_repository.dart';
import '../../../mock/ui/mock_date_service.dart';
import '../../../mock/use_case/mock_get_player_points_use_case.dart';

void main() {
  final authRepository = MockAuthRepository();
  final playerRepository = MockPlayerRepository();
  final getPlayerPointsUseCase = MockGetPlayerPointsUseCase();
  final dateService = MockDateService();

  PlayersCubit createCubit() => PlayersCubit(
        authRepository,
        playerRepository,
        getPlayerPointsUseCase,
        dateService,
      );

  tearDown(() {
    reset(authRepository);
    reset(playerRepository);
    reset(getPlayerPointsUseCase);
    reset(dateService);
  });

  group(
    'initialize, ',
    () {
      const String loggedUserId = 'u1';
      final DateTime now = DateTime(2024);
      final List<Player> players = [
        const PlayerCreator(id: loggedUserId).createEntity(),
        const PlayerCreator(id: 'u2').createEntity(),
        const PlayerCreator(id: 'u3').createEntity(),
      ];

      blocTest(
        'should emit state with status set to loggedUserDoesNotExist if logged '
        'user id is null',
        build: () => createCubit(),
        setUp: () => authRepository.mockGetLoggedUserId(null),
        act: (cubit) async => await cubit.initialize(),
        expect: () => [
          const PlayersState(
            status: PlayersStateStatus.loggedUserDoesNotExist,
          ),
        ],
        verify: (_) => verify(() => authRepository.loggedUserId$).called(1),
      );

      blocTest(
        'should load and emit other players with their points',
        build: () => createCubit(),
        setUp: () {
          authRepository.mockGetLoggedUserId(loggedUserId);
          playerRepository.mockGetAllPlayers(players: players);
          dateService.mockGetNow(now: now);
          when(
            () => getPlayerPointsUseCase.call(
              playerId: players[1].id,
              season: now.year,
            ),
          ).thenAnswer((_) => Stream.value(12.5));
          when(
            () => getPlayerPointsUseCase.call(
              playerId: players.last.id,
              season: now.year,
            ),
          ).thenAnswer((_) => Stream.value(22.2));
        },
        act: (cubit) async => await cubit.initialize(),
        expect: () => [
          PlayersState(
            status: PlayersStateStatus.completed,
            playersWithTheirPoints: [
              PlayerWithPoints(
                player: players[1],
                totalPoints: 12.5,
              ),
              PlayerWithPoints(
                player: players.last,
                totalPoints: 22.2,
              ),
            ],
          ),
        ],
        verify: (_) {
          verify(() => authRepository.loggedUserId$).called(1);
          verify(() => playerRepository.getAllPlayers()).called(1);
          verify(
            () => getPlayerPointsUseCase.call(
              playerId: players[1].id,
              season: now.year,
            ),
          ).called(1);
          verify(
            () => getPlayerPointsUseCase.call(
              playerId: players.last.id,
              season: now.year,
            ),
          ).called(1);
        },
      );
    },
  );
}
