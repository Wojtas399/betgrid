import 'package:betgrid/data/repository/player/player_repository_impl.dart';
import 'package:betgrid/firebase/model/user_dto/user_dto.dart';
import 'package:betgrid/firebase/service/firebase_avatar_service.dart';
import 'package:betgrid/firebase/service/firebase_user_service.dart';
import 'package:betgrid/model/player.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/user_dto_creator.dart';
import '../../../mock/firebase/mock_firebase_avatar_service.dart';
import '../../../mock/firebase/mock_firebase_user_service.dart';

void main() {
  final dbUserService = MockFirebaseUserService();
  final dbAvatarService = MockFirebaseAvatarService();
  late PlayerRepositoryImpl repositoryImpl;

  setUpAll(() {
    GetIt.I.registerFactory<FirebaseUserService>(() => dbUserService);
    GetIt.I.registerFactory<FirebaseAvatarService>(() => dbAvatarService);
  });

  setUp(() {
    repositoryImpl = PlayerRepositoryImpl();
  });

  tearDown(() {
    reset(dbUserService);
    reset(dbAvatarService);
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
      dbUserService.mockLoadAllUsers(userDtos: userDtos);
      when(
        () => dbAvatarService.loadAvatarUrlForUser(userId: 'u2'),
      ).thenAnswer((_) => Future.value(user2AvatarUrl));
      when(
        () => dbAvatarService.loadAvatarUrlForUser(userId: 'u1'),
      ).thenAnswer((_) => Future.value(null));
      when(
        () => dbAvatarService.loadAvatarUrlForUser(userId: 'u3'),
      ).thenAnswer((_) => Future.value(null));
      repositoryImpl = PlayerRepositoryImpl(initialData: []);

      final Stream<List<Player>?> players$ = repositoryImpl.getAllPlayers();

      expect(await players$.first, expectedPlayers);
      expect(
        repositoryImpl.repositoryState$,
        emits(expectedPlayers),
      );
      verify(dbUserService.loadAllUsers).called(1);
      verify(
        () => dbAvatarService.loadAvatarUrlForUser(userId: 'u2'),
      ).called(1);
      verify(
        () => dbAvatarService.loadAvatarUrlForUser(userId: 'u1'),
      ).called(1);
      verify(
        () => dbAvatarService.loadAvatarUrlForUser(userId: 'u3'),
      ).called(1);
    },
  );

  test(
    'getPlayerById, '
    'player exists in repository state, '
    'should emit existing player',
    () async {
      const String playerId = 'p1';
      const Player expectedPlayer = Player(id: playerId, username: 'player 1');
      const List<Player> existingPlayers = [
        Player(id: 'p2', username: 'player 2'),
        Player(id: 'p3', username: 'player 3'),
        expectedPlayer,
      ];
      repositoryImpl = PlayerRepositoryImpl(initialData: existingPlayers);

      final Stream<Player?> player$ = repositoryImpl.getPlayerById(
        playerId: playerId,
      );

      expect(player$, emits(expectedPlayer));
      verifyNever(
        () => dbUserService.loadUserById(userId: playerId),
      );
      verifyNever(
        () => dbAvatarService.loadAvatarUrlForUser(userId: playerId),
      );
    },
  );

  test(
    'getPlayerById, '
    'player does not exist in repository state, '
    'should load player from db, add it to repo state and emit it',
    () async {
      const String playerId = 'p1';
      final UserDto userDto = createUserDto(id: playerId, username: 'player 1');
      const Player expectedPlayer = Player(id: playerId, username: 'player 1');
      const List<Player> existingPlayers = [
        Player(id: 'p2', username: 'player 2'),
        Player(id: 'p3', username: 'player 3'),
      ];
      dbUserService.mockLoadUserById(userDto: userDto);
      dbAvatarService.mockLoadAvatarUrlForUser(avatarUrl: null);
      repositoryImpl = PlayerRepositoryImpl(initialData: existingPlayers);

      final Stream<Player?> player$ = repositoryImpl.getPlayerById(
        playerId: playerId,
      );

      expect(await player$.first, expectedPlayer);
      expect(
        repositoryImpl.repositoryState$,
        emits([...existingPlayers, expectedPlayer]),
      );
      verify(
        () => dbUserService.loadUserById(userId: playerId),
      ).called(1);
      verify(
        () => dbAvatarService.loadAvatarUrlForUser(userId: playerId),
      ).called(1);
    },
  );
}
