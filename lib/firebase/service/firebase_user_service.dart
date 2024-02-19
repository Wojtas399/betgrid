import 'package:injectable/injectable.dart';

import '../collections.dart';
import '../model/user_dto/user_dto.dart';

@injectable
class FirebaseUserService {
  Future<UserDto?> loadUserById({required String userId}) async {
    final snapshot = await getUsersRef().doc(userId).get();
    return snapshot.data();
  }

  Future<UserDto?> addUser({
    required String userId,
    required String username,
    required ThemeModeDto themeMode,
    required ThemePrimaryColorDto themePrimaryColor,
  }) async {
    final docRef = getUsersRef().doc(userId);
    await docRef.set(
      UserDto(
        username: username,
        themeMode: themeMode,
        themePrimaryColor: themePrimaryColor,
      ),
    );
    final snapshot = await docRef.get();
    return snapshot.data();
  }

  Future<bool> isUsernameAlreadyTaken({required String username}) async {
    final snapshot = await getUsersRef()
        .where('username', isEqualTo: username)
        .limit(1)
        .get();
    return snapshot.docs.isNotEmpty;
  }
}
