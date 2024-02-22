import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../model/user.dart';
import 'user_repository_impl.dart';

part 'user_repository.g.dart';

@riverpod
UserRepository userRepository(UserRepositoryRef ref) => UserRepositoryImpl();

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
