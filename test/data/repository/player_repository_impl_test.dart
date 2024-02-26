import 'package:betgrid/data/repository/player/player_repository_impl.dart';
import 'package:betgrid/firebase/model/user_dto/user_dto.dart';
import 'package:betgrid/firebase/service/firebase_avatar_service.dart';
import 'package:betgrid/firebase/service/firebase_user_service.dart';
import 'package:betgrid/model/player.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../../creator/user_dto_creator.dart';
import '../../mock/firebase/mock_firebase_avatar_service.dart';
import '../../mock/firebase/mock_firebase_user_service.dart';

void main() {
  final dbUserService = MockFirebaseUserService();
  final dbAvatarService = MockFirebaseAvatarService();
  const String userId = 'u1';
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
    'getAllPlayersWithoutGiven, '
    'should load all players from db, add them to repo state and '
    'emit players with id different than given id',
    () async {
      final List<UserDto> userDtos = [
        createUserDto(id: 'u2', username: 'username 2'),
        createUserDto(id: userId, username: 'username 1'),
        createUserDto(id: 'u3', username: 'username 3'),
      ];
      const String user2AvatarUrl = 'avatar/url';
      final List<Player> expectedPlayers = [
        const Player(
          id: 'u2',
          username: 'username 2',
          avatarUrl: user2AvatarUrl,
        ),
        const Player(id: 'u3', username: 'username 3'),
      ];
      dbUserService.mockLoadAllUsers(userDtos: userDtos);
      when(
        () => dbAvatarService.loadAvatarUrlForUser(userId: 'u2'),
      ).thenAnswer((_) => Future.value(user2AvatarUrl));
      when(
        () => dbAvatarService.loadAvatarUrlForUser(userId: 'u3'),
      ).thenAnswer((_) => Future.value(null));
      repositoryImpl = PlayerRepositoryImpl(initialData: []);

      final Stream<List<Player>?> players$ =
          repositoryImpl.getAllPlayersWithoutGiven(playerId: userId);

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
        () => dbAvatarService.loadAvatarUrlForUser(userId: 'u3'),
      ).called(1);
    },
  );
}
