import 'package:betgrid/data/exception/user_repository_exception.dart';
import 'package:betgrid/data/firebase/model/user_dto.dart';
import 'package:betgrid/data/repository/user/user_repository_impl.dart';
import 'package:betgrid/model/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../creator/user_creator.dart';
import '../../mock/data/mapper/mock_theme_mode_mapper.dart';
import '../../mock/data/mapper/mock_theme_primary_color_mapper.dart';
import '../../mock/data/mapper/mock_user_mapper.dart';
import '../../mock/firebase/mock_firebase_avatar_service.dart';
import '../../mock/firebase/mock_firebase_user_service.dart';

void main() {
  final dbUserService = MockFirebaseUserService();
  final dbAvatarService = MockFirebaseAvatarService();
  final userMapper = MockUserMapper();
  final themeModeMapper = MockThemeModeMapper();
  final themePrimaryColorMapper = MockThemePrimaryColorMapper();
  late UserRepositoryImpl repositoryImpl;
  const String userId = 'u1';

  setUp(() {
    repositoryImpl = UserRepositoryImpl(
      dbUserService,
      dbAvatarService,
      userMapper,
      themeModeMapper,
      themePrimaryColorMapper,
    );
  });

  tearDown(() {
    reset(dbUserService);
    reset(dbAvatarService);
    reset(userMapper);
    reset(themeModeMapper);
    reset(themePrimaryColorMapper);
  });

  group(
    'getUserById, ',
    () {
      const String avatarUrl = 'avatar/url';
      const UserCreator userCreator = UserCreator(
        id: userId,
        username: 'username',
        avatarUrl: avatarUrl,
      );
      final List<User> existingUsers = [
        const UserCreator(id: 'u2').createEntity(),
        const UserCreator(id: 'u3').createEntity(),
      ];

      test(
        'should only emit user if it already exists in repo state',
        () async {
          final User expectedUser = userCreator.createEntity();
          repositoryImpl.addEntities([
            ...existingUsers,
            expectedUser,
          ]);

          final Stream<User?> user$ = repositoryImpl.getUserById(
            userId: userId,
          );

          expect(await user$.first, expectedUser);
        },
      );

      test(
        'should fetch user data and avatar from db, should add its data to '
        'repo state and should emit them if user does not exist in repo state',
        () async {
          final UserDto expectedUserDto = userCreator.createDto();
          final User expectedUser = userCreator.createEntity();
          dbUserService.mockFetchUserById(userDto: expectedUserDto);
          dbAvatarService.mockFetchAvatarUrlForUser(avatarUrl: avatarUrl);
          userMapper.mockMapFromDto(expectedUser: expectedUser);

          final Stream<User?> user$ = repositoryImpl.getUserById(
            userId: userId,
          );

          expect(await user$.first, expectedUser);
          expect(await repositoryImpl.repositoryState$.first, [expectedUser]);
          verify(
            () => dbUserService.fetchUserById(userId: userId),
          ).called(1);
          verify(
            () => dbAvatarService.fetchAvatarUrlForUser(userId: userId),
          ).called(1);
        },
      );
    },
  );

  group(
    'addUser, ',
    () {
      const String username = 'user';
      const ThemeMode themeMode = ThemeMode.dark;
      const ThemePrimaryColor themePrimaryColor = ThemePrimaryColor.defaultRed;
      const ThemeModeDto themeModeDto = ThemeModeDto.dark;
      const ThemePrimaryColorDto themePrimaryColorDto =
          ThemePrimaryColorDto.defaultRed;

      setUp(() {
        themeModeMapper.mockMapToDto(expectedThemeModeDto: themeModeDto);
        themePrimaryColorMapper.mockMapToDto(
          expectedThemePrimaryColorDto: themePrimaryColorDto,
        );
      });

      test(
        'should throw UserRepositoryExceptionUsernameAlreadyTaken exception if '
        'passed username is already taken',
        () async {
          const expectedException =
              UserRepositoryExceptionUsernameAlreadyTaken();
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
        'should only add user data to db and to repository state if '
        'avatarImgPath is null',
        () async {
          const UserCreator addedUserCreator = UserCreator(
            id: userId,
            username: username,
            themeMode: UserCreatorThemeMode.dark,
            themePrimaryColor: UserCreatorThemePrimaryColor.red,
          );
          final UserDto addedUserDto = addedUserCreator.createDto();
          final User addedUser = addedUserCreator.createEntity();
          dbUserService.mockIsUsernameAlreadyTaken(isAlreadyTaken: false);
          dbUserService.mockAddUser(addedUserDto: addedUserDto);
          userMapper.mockMapFromDto(expectedUser: addedUser);

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
        'should add user data and its avatar to db and should add user to '
        'repository state if avatarImgPath is not null',
        () async {
          const String avatarImgPath = 'avatar/img';
          const String avatarUrl = 'avatar/url';
          const UserCreator addedUserCreator = UserCreator(
            id: userId,
            username: username,
            avatarUrl: avatarUrl,
            themeMode: UserCreatorThemeMode.dark,
            themePrimaryColor: UserCreatorThemePrimaryColor.red,
          );
          final UserDto addedUserDto = addedUserCreator.createDto();
          final User addedUser = addedUserCreator.createEntity();
          dbUserService.mockIsUsernameAlreadyTaken(isAlreadyTaken: false);
          dbUserService.mockAddUser(addedUserDto: addedUserDto);
          dbAvatarService.mockAddAvatarForUser(addedAvatarUrl: avatarUrl);
          userMapper.mockMapFromDto(expectedUser: addedUser);

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
    },
  );

  group(
    'updateUserData, ',
    () {
      const String newUsername = 'new username';
      const ThemeMode newThemeMode = ThemeMode.system;
      const ThemePrimaryColor newThemePrimaryColor = ThemePrimaryColor.pink;
      const ThemeModeDto newThemeModeDto = ThemeModeDto.system;
      const ThemePrimaryColorDto newThemePrimaryColorDto =
          ThemePrimaryColorDto.pink;
      const UserCreator existingUserCreator = UserCreator(
        id: userId,
        username: 'username',
      );

      setUp(() {
        dbUserService.mockFetchUserById(
          userDto: existingUserCreator.createDto(),
        );
        userMapper.mockMapFromDto(
          expectedUser: existingUserCreator.createEntity(),
        );
      });

      test(
        'should do nothing if username, themeMode and themePrimaryColor are '
        'null',
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
        'should finish method call if user does not exists in repo state',
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
        'should throw UserRepositoryExceptionUsernameAlreadyTaken exception if '
        'new username is already taken',
        () async {
          const expectedException =
              UserRepositoryExceptionUsernameAlreadyTaken();
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
        'should throw UserRepositoryExceptionUserNotFound exception if updated '
        'user is not returned from db',
        () async {
          const expectedException = UserRepositoryExceptionUserNotFound();
          dbAvatarService.mockFetchAvatarUrlForUser(avatarUrl: null);
          dbUserService.mockIsUsernameAlreadyTaken(isAlreadyTaken: false);
          themeModeMapper.mockMapToDto(expectedThemeModeDto: newThemeModeDto);
          themePrimaryColorMapper.mockMapToDto(
            expectedThemePrimaryColorDto: newThemePrimaryColorDto,
          );
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
        'should update user in db and in repo state',
        () async {
          const UserCreator updatedUserCreator = UserCreator(
            id: userId,
            username: newUsername,
            themeMode: UserCreatorThemeMode.system,
            themePrimaryColor: UserCreatorThemePrimaryColor.pink,
          );
          final UserDto updatedUserDto = updatedUserCreator.createDto();
          final User updatedUser = updatedUserCreator.createEntity();
          dbAvatarService.mockFetchAvatarUrlForUser(avatarUrl: null);
          dbUserService.mockIsUsernameAlreadyTaken(isAlreadyTaken: false);
          themeModeMapper.mockMapToDto(expectedThemeModeDto: newThemeModeDto);
          themePrimaryColorMapper.mockMapToDto(
            expectedThemePrimaryColorDto: newThemePrimaryColorDto,
          );
          dbUserService.mockUpdateUser(updatedUserDto: updatedUserDto);
          when(
            () => userMapper.mapFromDto(userDto: updatedUserDto),
          ).thenReturn(updatedUser);

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
    },
  );

  group(
    'updateUserAvatar, ',
    () {
      const UserCreator existingUserCreator = UserCreator(id: userId);
      const String existingUserAvatarUrl = 'avr/u/r/l';

      setUp(() {
        dbUserService.mockFetchUserById(
          userDto: existingUserCreator.createDto(),
        );
        userMapper.mockMapFromDto(
          expectedUser: existingUserCreator.createEntity(),
        );
        dbAvatarService.mockFetchAvatarUrlForUser(
          avatarUrl: existingUserAvatarUrl,
        );
      });

      test(
        'should remove avatar from db if avatarImgPath is null and should '
        'update user data if it exists in repo state',
        () async {
          final User updatedUser = const UserCreator(id: userId).createEntity();
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
        'should remove avatar from db, should add new avatar to db if '
        'avatarImgPath is not null and should update user data if it exists in '
        'repo state',
        () async {
          const String newAvatarImgPath = 'avatar/img/path';
          const String newAvatarUrl = 'newAvr/url';
          final User updatedUser = const UserCreator(
            id: userId,
            avatarUrl: newAvatarUrl,
          ).createEntity();
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
    },
  );
}
