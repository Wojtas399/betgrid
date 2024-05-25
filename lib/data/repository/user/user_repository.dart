import '../../../model/user.dart';

abstract interface class UserRepository {
  Stream<User?> getUserById({required String userId});

  Future<void> addUser({
    required String userId,
    required String username,
    String? avatarImgPath,
    required ThemeMode themeMode,
    required ThemePrimaryColor themePrimaryColor,
  });

  Future<void> updateUserData({
    required String userId,
    String? username,
    ThemeMode? themeMode,
    ThemePrimaryColor? themePrimaryColor,
  });

  Future<void> updateUserAvatar({
    required String userId,
    String? avatarImgPath,
  });
}
