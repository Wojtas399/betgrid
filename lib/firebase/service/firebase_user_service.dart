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
    required String nick,
    required ThemeModeDto themeMode,
  }) async {
    final docRef = getUsersRef().doc(userId);
    await docRef.set(UserDto(
      nick: nick,
      themeMode: themeMode,
    ));
    final snapshot = await docRef.get();
    return snapshot.data();
  }
}
