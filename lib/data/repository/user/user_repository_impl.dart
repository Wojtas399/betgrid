import 'package:collection/collection.dart';

import '../../../dependency_injection.dart';
import '../../../firebase/model/user_dto/user_dto.dart';
import '../../../firebase/service/firebase_avatar_service.dart';
import '../../../firebase/service/firebase_user_service.dart';
import '../../../model/user.dart';
import '../../exception/user_repository_exception.dart';
import '../../mapper/theme_mode_mapper.dart';
import '../../mapper/theme_primary_color_mapper.dart';
import '../../mapper/user_mapper.dart';
import '../repository.dart';
import 'user_repository.dart';

class UserRepositoryImpl extends Repository<User> implements UserRepository {
  final FirebaseUserService _dbUserService;
  final FirebaseAvatarService _dbAvatarService;

  UserRepositoryImpl({super.initialData})
      : _dbUserService = getIt<FirebaseUserService>(),
        _dbAvatarService = getIt<FirebaseAvatarService>();

  @override
  Stream<User?> getUserById({required String userId}) async* {
    await for (final users in repositoryState$) {
      User? user = users?.firstWhereOrNull((user) => user.id == userId);
      user ??= await _loadUserFromDb(userId);
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
      themeMode: mapThemeModeToDto(themeMode),
      themePrimaryColor: mapThemePrimaryColorToDto(themePrimaryColor),
    );
    if (addedUserDto == null) throw "Added user's data not found";
    String? avatarUrl;
    if (avatarImgPath != null) {
      avatarUrl = await _dbAvatarService.addAvatarForUser(
        userId: userId,
        avatarImgPath: avatarImgPath,
      );
    }
    final User addedUser = mapUserFromDto(addedUserDto, avatarUrl);
    addEntity(addedUser);
  }

  Future<User?> _loadUserFromDb(String userId) async {
    final UserDto? userDto = await _dbUserService.loadUserById(userId: userId);
    if (userDto == null) return null;
    final String? avatarUrl = await _dbAvatarService.loadAvatarUrlForUser(
      userId: userId,
    );
    final User user = mapUserFromDto(userDto, avatarUrl);
    addEntity(user);
    return user;
  }
}
