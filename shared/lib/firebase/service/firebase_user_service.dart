import '../firebase_collections_references.dart';
import '../model/user_dto.dart';

class FirebaseUserService {
  final _firebaseCollectionReferences = FirebaseCollectionsReferences();

  Future<UserDto?> fetchById(String userId) async {
    final snapshot =
        await _firebaseCollectionReferences.users().doc(userId).get();
    return snapshot.data();
  }

  Future<List<UserDto>> fetchAll() async {
    final snapshot = await _firebaseCollectionReferences.users().get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<UserDto?> add({
    required String userId,
    required String username,
    required ThemeModeDto themeMode,
    required ThemePrimaryColorDto themePrimaryColor,
  }) async {
    final docRef = _firebaseCollectionReferences.users().doc(userId);
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
    final snapshot = await _firebaseCollectionReferences
        .users()
        .where(UserFields.username, isEqualTo: username)
        .limit(1)
        .get();
    return snapshot.docs.isNotEmpty;
  }

  Future<UserDto?> update({
    required String userId,
    String? username,
    ThemeModeDto? themeMode,
    ThemePrimaryColorDto? themePrimaryColor,
  }) async {
    final docRef = _firebaseCollectionReferences.users().doc(userId);
    await docRef.update({
      if (username != null) UserFields.username: username,
      if (themeMode != null) UserFields.themeMode: themeMode.name,
      if (themePrimaryColor != null)
        UserFields.themePrimaryColor: themePrimaryColor.name,
    });
    final snapshot = await docRef.get();
    return snapshot.data();
  }
}
