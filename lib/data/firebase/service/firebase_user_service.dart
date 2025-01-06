import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../firebase_collection_refs.dart';
import '../model/user_dto.dart';

@injectable
class FirebaseUserService {
  final FirebaseCollectionRefs _firebaseCollectionRefs;

  const FirebaseUserService(this._firebaseCollectionRefs);

  Future<UserDto?> fetchUserById({required String userId}) async {
    final snapshot = await _firebaseCollectionRefs.users().doc(userId).get();
    return snapshot.data();
  }

  Future<List<UserDto>> fetchAllUsers() async {
    final snapshot = await _firebaseCollectionRefs.users().get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<UserDto?> addUser({
    required String userId,
    required String username,
    required ThemeModeDto themeMode,
    required ThemePrimaryColorDto themePrimaryColor,
  }) async {
    final docRef = _firebaseCollectionRefs.users().doc(userId);
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
    final snapshot = await _firebaseCollectionRefs
        .users()
        .where('username', isEqualTo: username)
        .limit(1)
        .get();
    return snapshot.docs.isNotEmpty;
  }

  Future<UserDto?> updateUser({
    required String userId,
    String? username,
    ThemeModeDto? themeMode,
    ThemePrimaryColorDto? themePrimaryColor,
  }) async {
    final docRef = _firebaseCollectionRefs.users().doc(userId);
    DocumentSnapshot<UserDto> doc = await docRef.get();
    UserDto? data = doc.data();
    if (data == null) {
      throw '[FirebaseUserService] Cannot find doc data';
    }
    data = data.copyWith(
      username: username ?? data.username,
      themeMode: themeMode ?? data.themeMode,
      themePrimaryColor: themePrimaryColor ?? data.themePrimaryColor,
    );
    await docRef.set(data);
    final snapshot = await docRef.get();
    return snapshot.data();
  }
}
