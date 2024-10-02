import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:mutex/mutex.dart';

import '../../../model/user.dart';
import '../../exception/user_repository_exception.dart';
import '../../firebase/model/user_dto/user_dto.dart';
import '../../firebase/service/firebase_avatar_service.dart';
import '../../firebase/service/firebase_user_service.dart';
import '../../mapper/theme_mode_mapper.dart';
import '../../mapper/theme_primary_color_mapper.dart';
import '../../mapper/user_mapper.dart';
import '../repository.dart';
import 'user_repository.dart';

@LazySingleton(as: UserRepository)
class UserRepositoryImpl extends Repository<User> implements UserRepository {
  final getUserByIdMutex = Mutex();
  final FirebaseUserService _dbUserService;
  final FirebaseAvatarService _dbAvatarService;
  final UserMapper _userMapper;
  final ThemeModeMapper _themeModeMapper;
  final ThemePrimaryColorMapper _themePrimaryColorMapper;

  UserRepositoryImpl(
    this._dbUserService,
    this._dbAvatarService,
    this._userMapper,
    this._themeModeMapper,
    this._themePrimaryColorMapper,
  );

  @override
  Stream<User?> getUserById({required String userId}) async* {
    await getUserByIdMutex.acquire();
    await for (final users in repositoryState$) {
      User? user = users.firstWhereOrNull((user) => user.id == userId);
      try {
        user ??= await _fetchUserFromDb(userId);
      } finally {
        if (getUserByIdMutex.isLocked) getUserByIdMutex.release();
      }
      yield user;
    }
  }

  @override
  Future<void> addUser({
    required String userId,
    required String username,
    String? avatarImgPath,
    required ThemeMode themeMode,
    required ThemePrimaryColor themePrimaryColor,
  }) async {
    final bool isUsernameAlreadyTaken =
        await _dbUserService.isUsernameAlreadyTaken(username: username);
    if (isUsernameAlreadyTaken) {
      throw const UserRepositoryExceptionUsernameAlreadyTaken();
    }
    final UserDto? addedUserDto = await _dbUserService.addUser(
      userId: userId,
      username: username,
      themeMode: _themeModeMapper.mapToDto(themeMode),
      themePrimaryColor: _themePrimaryColorMapper.mapToDto(themePrimaryColor),
    );
    if (addedUserDto == null) throw "Added user's data not found";
    String? avatarUrl;
    if (avatarImgPath != null) {
      avatarUrl = await _dbAvatarService.addAvatarForUser(
        userId: userId,
        avatarImgPath: avatarImgPath,
      );
    }
    final User addedUser = _userMapper.mapFromDto(
      userDto: addedUserDto,
      avatarUrl: avatarUrl,
    );
    addEntity(addedUser);
  }

  @override
  Future<void> updateUserData({
    required String userId,
    String? username,
    ThemeMode? themeMode,
    ThemePrimaryColor? themePrimaryColor,
  }) async {
    if (username == null && themeMode == null && themePrimaryColor == null) {
      return;
    }
    User? user = await _findExistingUserInRepoState(userId);
    if (user == null) return;
    if (username != null) await _checkIfUsernameIsAlreadyTaken(username);
    final UserDto? updatedUserDto = await _dbUserService.updateUser(
      userId: userId,
      username: username,
      themeMode:
          themeMode != null ? _themeModeMapper.mapToDto(themeMode) : null,
      themePrimaryColor: themePrimaryColor != null
          ? _themePrimaryColorMapper.mapToDto(themePrimaryColor)
          : null,
    );
    if (updatedUserDto == null) {
      throw const UserRepositoryExceptionUserNotFound();
    }
    user = _userMapper.mapFromDto(
      userDto: updatedUserDto,
      avatarUrl: user.avatarUrl,
    );
    updateEntity(user);
  }

  @override
  Future<void> updateUserAvatar({
    required String userId,
    String? avatarImgPath,
  }) async {
    String? newAvatarUrl;
    await _dbAvatarService.removeAvatarForUser(userId: userId);
    if (avatarImgPath != null) {
      newAvatarUrl = await _dbAvatarService.addAvatarForUser(
        userId: userId,
        avatarImgPath: avatarImgPath,
      );
    }
    User? user = await _findExistingUserInRepoState(userId);
    if (user == null) return;
    user = User(
      id: user.id,
      username: user.username,
      avatarUrl: newAvatarUrl,
      themeMode: user.themeMode,
      themePrimaryColor: user.themePrimaryColor,
    );
    updateEntity(user);
  }

  Future<User?> _fetchUserFromDb(String userId) async {
    final UserDto? userDto = await _dbUserService.fetchUserById(userId: userId);
    if (userDto == null) return null;
    final String? avatarUrl = await _dbAvatarService.fetchAvatarUrlForUser(
      userId: userId,
    );
    final User user = _userMapper.mapFromDto(
      userDto: userDto,
      avatarUrl: avatarUrl,
    );
    addEntity(user);
    return user;
  }

  Future<void> _checkIfUsernameIsAlreadyTaken(String username) async {
    final bool isUsernameAlreadyTaken =
        await _dbUserService.isUsernameAlreadyTaken(username: username);
    if (isUsernameAlreadyTaken) {
      throw const UserRepositoryExceptionUsernameAlreadyTaken();
    }
  }

  Future<User?> _findExistingUserInRepoState(String userId) async {
    final List<User> existingUsers = await repositoryState$.first;
    return existingUsers.firstWhereOrNull((User user) => user.id == userId);
  }
}
