import 'package:betgrid/data/exception/user_repository_exception.dart';
import 'package:betgrid/data/firebase/model/user_dto/user_dto.dart';
import 'package:betgrid/data/repository/user/user_repository_impl.dart';
import 'package:betgrid/model/user.dart';
import 'package:flutter_test/flutter_test.dart';
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

  setUp(() {
    repositoryImpl = UserRepositoryImpl(dbUserService, dbAvatarService);
  });

  tearDown(() {
    reset(dbUserService);
    reset(dbAvatarService);
  });

  test(
    'getUserById, '
    'should load user data and avatar from db, should add its data to repo state '
    'and should emit them if user does not exist in repo state, '
    'should only emit user if it exists in repo state',
    () async {
      const String username = 'username';
      const String avatarUrl = 'avatar/url';
      final UserDto expectedUserDto = createUserDto(
        id: userId,
        username: username,
      );
      final User expectedUser = createUser(
        id: userId,
        username: username,
        avatarUrl: avatarUrl,
      );
      dbUserService.mockFetchUserById(userDto: expectedUserDto);
      dbAvatarService.mockFetchAvatarUrlForUser(avatarUrl: avatarUrl);
      repositoryImpl = UserRepositoryImpl(dbUserService, dbAvatarService);

      final Stream<User?> user1$ = repositoryImpl.getUserById(userId: userId);
      final Stream<User?> user2$ = repositoryImpl.getUserById(userId: userId);

      expect(await user1$.first, expectedUser);
      expect(await user2$.first, expectedUser);
      expect(await repositoryImpl.repositoryState$.first, [expectedUser]);
      verify(
        () => dbUserService.fetchUserById(userId: userId),
      ).called(1);
      verify(
        () => dbAvatarService.fetchAvatarUrlForUser(userId: userId),
      ).called(1);
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
      final UserDto existingUserDto = createUserDto(
        id: userId,
        username: 'username',
      );
      const String newUsername = 'new username';
      const expectedException = UserRepositoryExceptionUsernameAlreadyTaken();
      dbUserService.mockFetchUserById(userDto: existingUserDto);
      dbAvatarService.mockFetchAvatarUrlForUser(avatarUrl: null);
      dbUserService.mockIsUsernameAlreadyTaken(isAlreadyTaken: true);

      Object? exception;
      try {
        final user$ = repositoryImpl.getUserById(userId: userId);
        await user$.first;
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
      final UserDto existingUserDto = createUserDto(
        id: userId,
        username: 'username',
      );
      const String newUsername = 'new username';
      const ThemeMode newThemeMode = ThemeMode.system;
      const ThemePrimaryColor newThemePrimaryColor = ThemePrimaryColor.pink;
      const ThemeModeDto newThemeModeDto = ThemeModeDto.system;
      const ThemePrimaryColorDto newThemePrimaryColorDto =
          ThemePrimaryColorDto.pink;
      const expectedException = UserRepositoryExceptionUserNotFound();
      dbUserService.mockFetchUserById(userDto: existingUserDto);
      dbAvatarService.mockFetchAvatarUrlForUser(avatarUrl: null);
      dbUserService.mockIsUsernameAlreadyTaken(isAlreadyTaken: false);
      dbUserService.mockUpdateUser(updatedUserDto: null);

      Object? exception;
      try {
        final user$ = repositoryImpl.getUserById(userId: userId);
        await user$.first;
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
      final UserDto existingUserDto = createUserDto(
        id: userId,
        username: 'username',
      );
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
      dbUserService.mockFetchUserById(userDto: existingUserDto);
      dbAvatarService.mockFetchAvatarUrlForUser(avatarUrl: null);
      dbUserService.mockIsUsernameAlreadyTaken(isAlreadyTaken: false);
      dbUserService.mockUpdateUser(updatedUserDto: updatedUserDto);

      final user$ = repositoryImpl.getUserById(userId: userId);
      await user$.first;
      await repositoryImpl.updateUserData(
        userId: userId,
        username: newUsername,
        themeMode: newThemeMode,
        themePrimaryColor: newThemePrimaryColor,
      );

      expect(
        await repositoryImpl.repositoryState$.first,
        [updatedUser],
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
      final UserDto existingUserDto = createUserDto(id: userId);
      const String existingUserAvatarUrl = 'avr/u/r/l';
      final User updatedUser = createUser(id: userId, avatarUrl: null);
      dbUserService.mockFetchUserById(userDto: existingUserDto);
      dbAvatarService.mockFetchAvatarUrlForUser(
        avatarUrl: existingUserAvatarUrl,
      );
      dbAvatarService.mockRemoveAvatarForUser();

      final user$ = repositoryImpl.getUserById(userId: userId);
      await user$.first;
      await repositoryImpl.updateUserAvatar(
        userId: userId,
        avatarImgPath: null,
      );

      expect(
        await repositoryImpl.repositoryState$.first,
        [updatedUser],
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
      final UserDto existingUserDto = createUserDto(id: userId);
      const String existingUserAvatarUrl = 'avr/u/r/l';
      final User updatedUser = createUser(id: userId, avatarUrl: newAvatarUrl);
      dbUserService.mockFetchUserById(userDto: existingUserDto);
      dbAvatarService.mockFetchAvatarUrlForUser(
        avatarUrl: existingUserAvatarUrl,
      );
      dbAvatarService.mockRemoveAvatarForUser();
      dbAvatarService.mockAddAvatarForUser(addedAvatarUrl: newAvatarUrl);

      final user$ = repositoryImpl.getUserById(userId: userId);
      await user$.first;
      await repositoryImpl.updateUserAvatar(
        userId: userId,
        avatarImgPath: newAvatarImgPath,
      );

      expect(
        await repositoryImpl.repositoryState$.first,
        [updatedUser],
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
