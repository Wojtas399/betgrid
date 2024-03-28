import 'package:betgrid/data/exception/user_repository_exception.dart';
import 'package:betgrid/data/repository/user/user_repository_impl.dart';
import 'package:betgrid/firebase/model/user_dto/user_dto.dart';
import 'package:betgrid/firebase/service/firebase_avatar_service.dart';
import 'package:betgrid/firebase/service/firebase_user_service.dart';
import 'package:betgrid/model/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/user_creator.dart';
import '../../../creator/user_dto_creator.dart';
import '../../../mock/firebase/mock_firebase_avatar_service.dart';
import '../../../mock/firebase/mock_firebase_user_service.dart';

void main() {
  final dbUserService = MockFirebaseUserService();
  final dbAvatarService = MockFirebaseAvatarService();
  late UserRepositoryImpl repositoryImpl;
  const String userId = 'u1';

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
      final User expectedUser = createUser(id: 'u2', username: 'username 2');
      final List<User> existingUsers = [
        createUser(id: 'u1', username: 'username 1'),
        expectedUser,
        createUser(id: 'u3', username: 'username 3'),
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
      const String username = 'username 2';
      const String avatarUrl = 'avatar/url';
      final UserDto expectedUserDto = createUserDto(id: id, username: username);
      final User expectedUser = createUser(
        id: id,
        username: username,
        avatarUrl: avatarUrl,
      );
      final List<User> existingUsers = [
        createUser(id: 'u1', username: 'username 1'),
        createUser(id: 'u3', username: 'username 3'),
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
    'username is already taken, '
    'should throw UserRepositoryExceptionUsernameAlreadyTaken exception',
    () async {
      const String username = 'user';
      const ThemeMode themeMode = ThemeMode.dark;
      const ThemePrimaryColor themePrimaryColor = ThemePrimaryColor.defaultRed;
      const expectedException = UserRepositoryExceptionUsernameAlreadyTaken();
      dbUserService.mockIsUsernameAlreadyTaken(isAlreadyTaken: true);

      Object? exception;
      try {
        await repositoryImpl.addUser(
          userId: userId,
          username: username,
          themeMode: themeMode,
          themePrimaryColor: themePrimaryColor,
        );
      } catch (e) {
        exception = e;
      }

      expect(exception, expectedException);
    },
  );

  test(
    'addUser, '
    'avatarImgPath is null, '
    'should add user data to db and to repository state',
    () async {
      const String username = 'user';
      const ThemeMode themeMode = ThemeMode.dark;
      const ThemeModeDto themeModeDto = ThemeModeDto.dark;
      const ThemePrimaryColor themePrimaryColor = ThemePrimaryColor.defaultRed;
      const ThemePrimaryColorDto themePrimaryColorDto =
          ThemePrimaryColorDto.defaultRed;
      const UserDto addedUserDto = UserDto(
        id: userId,
        username: username,
        themeMode: themeModeDto,
        themePrimaryColor: themePrimaryColorDto,
      );
      const User addedUser = User(
        id: userId,
        username: username,
        themeMode: themeMode,
        themePrimaryColor: themePrimaryColor,
      );
      dbUserService.mockIsUsernameAlreadyTaken(isAlreadyTaken: false);
      dbUserService.mockAddUser(addedUserDto: addedUserDto);

      await repositoryImpl.addUser(
        userId: userId,
        username: username,
        themeMode: themeMode,
        themePrimaryColor: themePrimaryColor,
      );

      expect(repositoryImpl.repositoryState$, emits([addedUser]));
      verify(
        () => dbUserService.addUser(
          userId: userId,
          username: username,
          themeMode: themeModeDto,
          themePrimaryColor: themePrimaryColorDto,
        ),
      ).called(1);
    },
  );

  test(
    'addUser, '
    'avatarImgPath is not null, '
    'should add user data and its avatar to db and '
    'should add user to repository state',
    () async {
      const String username = 'user';
      const ThemeMode themeMode = ThemeMode.dark;
      const ThemeModeDto themeModeDto = ThemeModeDto.dark;
      const ThemePrimaryColor themePrimaryColor = ThemePrimaryColor.defaultRed;
      const ThemePrimaryColorDto themePrimaryColorDto =
          ThemePrimaryColorDto.defaultRed;
      const String avatarImgPath = 'avatar/img';
      const String avatarUrl = 'avatar/url';
      const UserDto addedUserDto = UserDto(
        id: userId,
        username: username,
        themeMode: themeModeDto,
        themePrimaryColor: themePrimaryColorDto,
      );
      const User addedUser = User(
        id: userId,
        username: username,
        avatarUrl: avatarUrl,
        themeMode: themeMode,
        themePrimaryColor: themePrimaryColor,
      );
      dbUserService.mockIsUsernameAlreadyTaken(isAlreadyTaken: false);
      dbUserService.mockAddUser(addedUserDto: addedUserDto);
      dbAvatarService.mockAddAvatarForUser(addedAvatarUrl: avatarUrl);

      await repositoryImpl.addUser(
        userId: userId,
        username: username,
        avatarImgPath: avatarImgPath,
        themeMode: themeMode,
        themePrimaryColor: themePrimaryColor,
      );

      expect(repositoryImpl.repositoryState$, emits([addedUser]));
      verify(
        () => dbUserService.addUser(
          userId: userId,
          username: username,
          themeMode: themeModeDto,
          themePrimaryColor: themePrimaryColorDto,
        ),
      ).called(1);
      verify(
        () => dbAvatarService.addAvatarForUser(
          userId: userId,
          avatarImgPath: avatarImgPath,
        ),
      ).called(1);
    },
  );

  test(
    'updateUserData, '
    'username, themeMode and themePrimaryColor are null, '
    'should do nothing',
    () async {
      await repositoryImpl.updateUserData(userId: userId);

      verifyNever(
        () => dbUserService.isUsernameAlreadyTaken(
          username: any(named: 'username'),
        ),
      );
      verifyNever(
        () => dbUserService.updateUser(
          userId: userId,
          username: any(named: 'username'),
          themeMode: any(named: 'themeMode'),
          themePrimaryColor: any(named: 'themePrimaryColor'),
        ),
      );
    },
  );

  test(
    'updateUserData, '
    'user does not exists in repo state, '
    'should finish method call',
    () async {
      final List<User> existingUsers = [
        createUser(id: 'u2'),
        createUser(id: 'u3'),
      ];
      repositoryImpl = UserRepositoryImpl(initialData: existingUsers);

      await repositoryImpl.updateUserData(userId: userId);

      verifyNever(
        () => dbUserService.isUsernameAlreadyTaken(
          username: any(named: 'username'),
        ),
      );
      verifyNever(
        () => dbUserService.updateUser(
          userId: userId,
          username: any(named: 'username'),
          themeMode: any(named: 'themeMode'),
          themePrimaryColor: any(named: 'themePrimaryColor'),
        ),
      );
    },
  );

  test(
    'updateUserData, '
    'new username is already taken, '
    'should throw UserRepositoryExceptionUsernameAlreadyTaken exception',
    () async {
      const String newUsername = 'new username';
      final List<User> existingUsers = [
        createUser(id: userId),
        createUser(id: 'u2'),
        createUser(id: 'u3'),
      ];
      const expectedException = UserRepositoryExceptionUsernameAlreadyTaken();
      dbUserService.mockIsUsernameAlreadyTaken(isAlreadyTaken: true);
      repositoryImpl = UserRepositoryImpl(initialData: existingUsers);

      Object? exception;
      try {
        await repositoryImpl.updateUserData(
          userId: userId,
          username: newUsername,
        );
      } catch (e) {
        exception = e;
      }

      expect(exception, expectedException);
      verify(
        () => dbUserService.isUsernameAlreadyTaken(username: newUsername),
      ).called(1);
      verifyNever(
        () => dbUserService.updateUser(
          userId: userId,
          username: any(named: 'username'),
          themeMode: any(named: 'themeMode'),
          themePrimaryColor: any(named: 'themePrimaryColor'),
        ),
      );
    },
  );

  test(
    'updateUserData, '
    'updated user is not returned from db, '
    'should throw UserRepositoryExceptionUserNotFound exception',
    () async {
      const String newUsername = 'new username';
      const ThemeMode newThemeMode = ThemeMode.system;
      const ThemePrimaryColor newThemePrimaryColor = ThemePrimaryColor.pink;
      const ThemeModeDto newThemeModeDto = ThemeModeDto.system;
      const ThemePrimaryColorDto newThemePrimaryColorDto =
          ThemePrimaryColorDto.pink;
      final List<User> existingUsers = [
        createUser(id: userId),
        createUser(id: 'u2'),
        createUser(id: 'u3'),
      ];
      const expectedException = UserRepositoryExceptionUserNotFound();
      dbUserService.mockIsUsernameAlreadyTaken(isAlreadyTaken: false);
      dbUserService.mockUpdateUser(updatedUserDto: null);
      repositoryImpl = UserRepositoryImpl(initialData: existingUsers);

      Object? exception;
      try {
        await repositoryImpl.updateUserData(
          userId: userId,
          username: newUsername,
          themeMode: newThemeMode,
          themePrimaryColor: newThemePrimaryColor,
        );
      } catch (e) {
        exception = e;
      }

      expect(exception, expectedException);
      verify(
        () => dbUserService.isUsernameAlreadyTaken(username: newUsername),
      ).called(1);
      verify(
        () => dbUserService.updateUser(
          userId: userId,
          username: newUsername,
          themeMode: newThemeModeDto,
          themePrimaryColor: newThemePrimaryColorDto,
        ),
      ).called(1);
    },
  );

  test(
    'updateUserData, '
    'should update user in db and in repo state',
    () async {
      const String newUsername = 'new username';
      const ThemeMode newThemeMode = ThemeMode.system;
      const ThemePrimaryColor newThemePrimaryColor = ThemePrimaryColor.pink;
      const ThemeModeDto newThemeModeDto = ThemeModeDto.system;
      const ThemePrimaryColorDto newThemePrimaryColorDto =
          ThemePrimaryColorDto.pink;
      final User updatedUser = createUser(
        id: userId,
        username: newUsername,
        themeMode: newThemeMode,
        themePrimaryColor: newThemePrimaryColor,
      );
      final UserDto updatedUserDto = createUserDto(
        id: userId,
        username: newUsername,
        themeMode: newThemeModeDto,
        themePrimaryColor: newThemePrimaryColorDto,
      );
      final List<User> existingUsers = [
        createUser(id: userId),
        createUser(id: 'u2'),
        createUser(id: 'u3'),
      ];
      dbUserService.mockIsUsernameAlreadyTaken(isAlreadyTaken: false);
      dbUserService.mockUpdateUser(updatedUserDto: updatedUserDto);
      repositoryImpl = UserRepositoryImpl(initialData: existingUsers);

      await repositoryImpl.updateUserData(
        userId: userId,
        username: newUsername,
        themeMode: newThemeMode,
        themePrimaryColor: newThemePrimaryColor,
      );

      expect(
        repositoryImpl.repositoryState$,
        emits([updatedUser, existingUsers[1], existingUsers[2]]),
      );
      verify(
        () => dbUserService.isUsernameAlreadyTaken(username: newUsername),
      ).called(1);
      verify(
        () => dbUserService.updateUser(
          userId: userId,
          username: newUsername,
          themeMode: newThemeModeDto,
          themePrimaryColor: newThemePrimaryColorDto,
        ),
      ).called(1);
    },
  );

  test(
    'updateUserAvatar, '
    'avatarImgPath is null, '
    'should remove avatar from db and should update user data if it exists in '
    'repo state',
    () async {
      final User existingUser = createUser(id: userId, avatarUrl: 'avr/u/r/l');
      final User updatedUser = createUser(id: userId, avatarUrl: null);
      final List<User> existingUsers = [
        createUser(id: 'u2', avatarUrl: 'avatar/url'),
        existingUser,
        createUser(id: 'u3', avatarUrl: 'avr/url'),
      ];
      dbAvatarService.mockRemoveAvatarForUser();
      repositoryImpl = UserRepositoryImpl(initialData: existingUsers);

      await repositoryImpl.updateUserAvatar(
        userId: userId,
        avatarImgPath: null,
      );

      expect(
        repositoryImpl.repositoryState$,
        emits([existingUsers.first, updatedUser, existingUsers.last]),
      );
      verify(
        () => dbAvatarService.removeAvatarForUser(userId: userId),
      ).called(1);
      verifyNever(
        () => dbAvatarService.addAvatarForUser(
          userId: userId,
          avatarImgPath: any(named: 'avatarImgPath'),
        ),
      );
    },
  );

  test(
    'updateUserAvatar, '
    'avatarImgPath is not null, '
    'should remove avatar from db, should add new avatar to db and '
    'should update user data if it exists in repo state',
    () async {
      const String newAvatarImgPath = 'avatar/img/path';
      const String newAvatarUrl = 'newAvr/url';
      final User existingUser = createUser(id: userId, avatarUrl: 'avr/u/r/l');
      final User updatedUser = createUser(id: userId, avatarUrl: newAvatarUrl);
      final List<User> existingUsers = [
        createUser(id: 'u2', avatarUrl: 'avatar/url'),
        existingUser,
        createUser(id: 'u3', avatarUrl: 'avr/url'),
      ];
      dbAvatarService.mockRemoveAvatarForUser();
      dbAvatarService.mockAddAvatarForUser(addedAvatarUrl: newAvatarUrl);
      repositoryImpl = UserRepositoryImpl(initialData: existingUsers);

      await repositoryImpl.updateUserAvatar(
        userId: userId,
        avatarImgPath: newAvatarImgPath,
      );

      expect(
        repositoryImpl.repositoryState$,
        emits([existingUsers.first, updatedUser, existingUsers.last]),
      );
      verify(
        () => dbAvatarService.removeAvatarForUser(userId: userId),
      ).called(1);
      verify(
        () => dbAvatarService.addAvatarForUser(
          userId: userId,
          avatarImgPath: newAvatarImgPath,
        ),
      ).called(1);
    },
  );
}
