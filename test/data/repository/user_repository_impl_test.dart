import 'package:betgrid/data/exception/user_repository_exception.dart';
import 'package:betgrid/data/repository/user/user_repository_impl.dart';
import 'package:betgrid/firebase/model/user_dto/user_dto.dart';
import 'package:betgrid/firebase/service/firebase_avatar_service.dart';
import 'package:betgrid/firebase/service/firebase_user_service.dart';
import 'package:betgrid/model/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../../creator/user_creator.dart';
import '../../creator/user_dto_creator.dart';
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
      const String userId = 'u1';
      const String username = 'user';
      const ThemeMode themeMode = ThemeMode.dark;
      const ThemePrimaryColor themePrimaryColor = ThemePrimaryColor.defaultRed;
      const expectedException = UserRepositoryExceptionUsernameAlreadyTaken();
      dbUserService.mockIsUsernameAlreadyTaken(isAlreadyTaken: true);

      try {
        await repositoryImpl.addUser(
          userId: userId,
          username: username,
          themeMode: themeMode,
          themePrimaryColor: themePrimaryColor,
        );
      } catch (exception) {
        expect(exception, expectedException);
      }
    },
  );

  test(
    'addUser, '
    'avatarImgPath is null, '
    'should add user data to db and to repository state',
    () async {
      const String userId = 'u1';
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
      const String userId = 'u1';
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
}
