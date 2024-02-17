import 'package:betgrid/data/repository/user/user_repository_impl.dart';
import 'package:betgrid/firebase/model/user_dto/user_dto.dart';
import 'package:betgrid/firebase/service/firebase_avatar_service.dart';
import 'package:betgrid/firebase/service/firebase_user_service.dart';
import 'package:betgrid/model/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../../mock/firebase/mock_firebase_avatar_service.dart';
import '../../mock/firebase/mock_firebase_user_service.dart';

void main() {
  final dbUserService = MockFirebaseUserService();
  final dbAvatarService = MockFirebaseAvatarService();
  late UserRepositoryImpl repositoryImpl;

  setUpAll(() {
    GetIt.I.registerFactory<FirebaseUserService>(() => dbUserService);
    GetIt.I.registerFactory<FirebaseAvatarService>(() => dbAvatarService);
  });

  setUp(() {
    repositoryImpl = UserRepositoryImpl();
  });

  tearDown(() {
    reset(dbUserService);
    reset(dbAvatarService);
  });

  test(
    'getUserById, '
    'user exists in repository state, '
    'should return user from state',
    () {
      const User expectedUser = User(id: 'u2', nick: 'nick 2');
      final List<User> existingUsers = [
        const User(id: 'u1', nick: 'nick 1'),
        expectedUser,
        const User(id: 'u3', nick: 'nick 3'),
      ];
      repositoryImpl = UserRepositoryImpl(initialData: existingUsers);

      final Stream<User?> user$ = repositoryImpl.getUserById(userId: 'u2');

      expect(user$, emits(expectedUser));
    },
  );

  test(
    'getUserById, '
    'user does not exist in repository state, '
    'should load user data and avatar from db, should add him to repo state and '
    'should emit him',
    () async {
      const String id = 'u2';
      const String nick = 'nick 2';
      const String avatarUrl = 'avatar/url';
      const UserDto expectedUserDto = UserDto(id: id, nick: nick);
      const User expectedUser = User(id: id, nick: nick, avatarUrl: avatarUrl);
      const List<User> existingUsers = [
        User(id: 'u1', nick: 'nick 1'),
        User(id: 'u3', nick: 'nick 3'),
      ];
      dbUserService.mockLoadUserById(userDto: expectedUserDto);
      dbAvatarService.mockLoadAvatarUrlForUser(avatarUrl: avatarUrl);
      repositoryImpl = UserRepositoryImpl(initialData: existingUsers);

      final Stream<User?> user$ = repositoryImpl.getUserById(userId: id);

      expect(user$, emits(expectedUser));
      expect(
        repositoryImpl.repositoryState$,
        emitsInOrder([
          existingUsers,
          [...existingUsers, expectedUser]
        ]),
      );
      await repositoryImpl.repositoryState$.first;
      verify(() => dbUserService.loadUserById(userId: id)).called(1);
      await repositoryImpl.repositoryState$.first;
      verify(() => dbAvatarService.loadAvatarUrlForUser(userId: id)).called(1);
    },
  );

  test(
    'addUser, '
    'avatarImgPath is null, '
    'should add user data to db and to repository state',
    () async {
      const String userId = 'u1';
      const String nick = 'user';
      const UserDto addedUserDto = UserDto(id: userId, nick: nick);
      const User addedUser = User(id: userId, nick: nick);
      dbUserService.mockAddUser(addedUserDto: addedUserDto);

      await repositoryImpl.addUser(userId: userId, nick: nick);

      expect(repositoryImpl.repositoryState$, emits([addedUser]));
      verify(
        () => dbUserService.addUser(userId: userId, nick: nick),
      ).called(1);
    },
  );

  test(
    'addUser, '
    'avatarImgPath is not null, '
    'should add user data and its avatar to db and '
    'should add user to repository state',
    () async {
      const String userId = 'u1';
      const String nick = 'user';
      const String avatarImgPath = 'avatar/img';
      const String avatarUrl = 'avatar/url';
      const UserDto addedUserDto = UserDto(id: userId, nick: nick);
      const User addedUser = User(
        id: userId,
        nick: nick,
        avatarUrl: avatarUrl,
      );
      dbUserService.mockAddUser(addedUserDto: addedUserDto);
      dbAvatarService.mockAddAvatarForUser(addedAvatarUrl: avatarUrl);

      await repositoryImpl.addUser(
        userId: userId,
        nick: nick,
        avatarImgPath: avatarImgPath,
      );

      expect(repositoryImpl.repositoryState$, emits([addedUser]));
      verify(
        () => dbUserService.addUser(userId: userId, nick: nick),
      ).called(1);
      verify(
        () => dbAvatarService.addAvatarForUser(
          userId: userId,
          avatarImgPath: avatarImgPath,
        ),
      ).called(1);
    },
  );
}
