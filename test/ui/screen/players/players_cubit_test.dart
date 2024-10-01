import 'package:betgrid/ui/screen/players/cubit/players_cubit.dart';
import 'package:betgrid/ui/screen/players/cubit/players_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/player_creator.dart';
import '../../../mock/data/repository/mock_auth_repository.dart';
import '../../../mock/data/repository/mock_player_repository.dart';
import '../../../mock/use_case/mock_get_player_points_use_case.dart';

void main() {
  final authRepository = MockAuthRepository();
  final playerRepository = MockPlayerRepository();
  final getPlayerPointsUseCase = MockGetPlayerPointsUseCase();

  PlayersCubit createCubit() => PlayersCubit(
        authRepository,
        playerRepository,
        getPlayerPointsUseCase,
      );

  tearDown(() {
    reset(authRepository);
    reset(playerRepository);
    reset(getPlayerPointsUseCase);
  });

  blocTest(
    'initialize, '
    'logged user id is null, '
    'should emit state with status set to loggedUserDoesNotExist',
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
    'initialize, '
    'should load and emit other players with their points',
    build: () => createCubit(),
    setUp: () {
      authRepository.mockGetLoggedUserId('u1');
      playerRepository.mockGetAllPlayers(
        players: [
          PlayerCreator(id: 'u1').createEntity(),
          PlayerCreator(id: 'u2').createEntity(),
          PlayerCreator(id: 'u3').createEntity(),
        ],
      );
      when(
        () => getPlayerPointsUseCase.call(playerId: 'u2'),
      ).thenAnswer((_) => Stream.value(12.5));
      when(
        () => getPlayerPointsUseCase.call(playerId: 'u3'),
      ).thenAnswer((_) => Stream.value(22.2));
    },
    act: (cubit) async => await cubit.initialize(),
    expect: () => [
      PlayersState(
        status: PlayersStateStatus.completed,
        playersWithTheirPoints: [
          PlayerWithPoints(
            player: PlayerCreator(id: 'u2').createEntity(),
            totalPoints: 12.5,
          ),
          PlayerWithPoints(
            player: PlayerCreator(id: 'u3').createEntity(),
            totalPoints: 22.2,
          ),
        ],
      ),
    ],
    verify: (_) {
      verify(() => authRepository.loggedUserId$).called(1);
      verify(() => playerRepository.getAllPlayers()).called(1);
      verify(() => getPlayerPointsUseCase.call(playerId: 'u2')).called(1);
      verify(() => getPlayerPointsUseCase.call(playerId: 'u3')).called(1);
    },
  );
}
