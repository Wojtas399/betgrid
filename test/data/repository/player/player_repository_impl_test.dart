import 'package:betgrid/data/repository/player/player_repository_impl.dart';
import 'package:betgrid/firebase/model/user_dto/user_dto.dart';
import 'package:betgrid/model/player.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/user_dto_creator.dart';
import '../../../mock/firebase/mock_firebase_avatar_service.dart';
import '../../../mock/firebase/mock_firebase_user_service.dart';

void main() {
  final dbUserService = MockFirebaseUserService();
  final dbAvatarService = MockFirebaseAvatarService();
  late PlayerRepositoryImpl repositoryImpl;

  setUp(() {
    repositoryImpl = PlayerRepositoryImpl(dbUserService, dbAvatarService);
  });

  test(
    'getAllPlayers, '
    'should load all players from db, add them to repo state and emit them',
    () async {
      final List<UserDto> userDtos = [
        createUserDto(id: 'u2', username: 'username 2'),
        createUserDto(id: 'u1', username: 'username 1'),
        createUserDto(id: 'u3', username: 'username 3'),
      ];
      const String user2AvatarUrl = 'avatar/url';
      final List<Player> expectedPlayers = [
        const Player(
          id: 'u2',
          username: 'username 2',
          avatarUrl: user2AvatarUrl,
        ),
        const Player(id: 'u1', username: 'username 1'),
        const Player(id: 'u3', username: 'username 3'),
      ];
      dbUserService.mockFetchAllUsers(userDtos: userDtos);
      when(
        () => dbAvatarService.fetchAvatarUrlForUser(userId: 'u2'),
      ).thenAnswer((_) => Future.value(user2AvatarUrl));
      when(
        () => dbAvatarService.fetchAvatarUrlForUser(userId: 'u1'),
      ).thenAnswer((_) => Future.value(null));
      when(
        () => dbAvatarService.fetchAvatarUrlForUser(userId: 'u3'),
      ).thenAnswer((_) => Future.value(null));

      final Stream<List<Player>?> players$ = repositoryImpl.getAllPlayers();

      expect(await players$.first, expectedPlayers);
      expect(
        repositoryImpl.repositoryState$,
        emits(expectedPlayers),
      );
      verify(dbUserService.fetchAllUsers).called(1);
      verify(
        () => dbAvatarService.fetchAvatarUrlForUser(userId: 'u2'),
      ).called(1);
      verify(
        () => dbAvatarService.fetchAvatarUrlForUser(userId: 'u1'),
      ).called(1);
      verify(
        () => dbAvatarService.fetchAvatarUrlForUser(userId: 'u3'),
      ).called(1);
    },
  );

  test(
    'getPlayerById, '
    'should load player from db, add it to repo state and emit it if it does '
    'not exist in repo state, '
    'should only emit player if it exists in repo state',
    () async {
      const String playerId = 'p1';
      final UserDto userDto = createUserDto(id: playerId, username: 'player 1');
      const Player expectedPlayer = Player(id: playerId, username: 'player 1');
      dbUserService.mockFetchUserById(userDto: userDto);
      dbAvatarService.mockFetchAvatarUrlForUser(avatarUrl: null);

      final Stream<Player?> player1$ = repositoryImpl.getPlayerById(
        playerId: playerId,
      );
      final Stream<Player?> player2$ = repositoryImpl.getPlayerById(
        playerId: playerId,
      );

      expect(await player1$.first, expectedPlayer);
      expect(await player2$.first, expectedPlayer);
      expect(await repositoryImpl.repositoryState$.first, [expectedPlayer]);
      verify(
        () => dbUserService.fetchUserById(userId: playerId),
      ).called(1);
      verify(
        () => dbAvatarService.fetchAvatarUrlForUser(userId: playerId),
      ).called(1);
    },
  );
}
