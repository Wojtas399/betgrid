import '../../../model/user.dart';

abstract interface class UserRepository {
  Stream<User?> getById(String userId);

  Future<void> add({
    required String userId,
    required String username,
    String? avatarImgPath,
    required ThemeMode themeMode,
    required ThemePrimaryColor themePrimaryColor,
  });

  Future<void> updateData({
    required String userId,
    String? username,
    ThemeMode? themeMode,
    ThemePrimaryColor? themePrimaryColor,
  });

  Future<void> updateAvatar({
    required String userId,
    String? avatarImgPath,
  });
}
