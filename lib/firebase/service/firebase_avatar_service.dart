import 'dart:io';

import 'package:collection/collection.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_avatar_service.g.dart';

@injectable
class FirebaseAvatarService {
  Reference _getAvatarRef(String userId) => FirebaseStorage.instance.ref(
        'Avatars/$userId.jpg',
      );

  Future<String?> fetchAvatarUrlForUser({required String userId}) async =>
      await _doesUserAvatarExists(userId)
          ? await _getAvatarRef(userId).getDownloadURL()
          : null;

  Future<String?> addAvatarForUser({
    required String userId,
    required String avatarImgPath,
  }) async {
    final File imageFile = File(avatarImgPath);
    final avatarRef = _getAvatarRef(userId);
    await avatarRef.putFile(imageFile);
    return await avatarRef.getDownloadURL();
  }

  Future<void> removeAvatarForUser({required String userId}) async {
    if (await _doesUserAvatarExists(userId)) {
      await _getAvatarRef(userId).delete();
    }
  }

  Future<bool> _doesUserAvatarExists(String userId) async {
    final allAvatars = await FirebaseStorage.instance.ref('Avatars/').listAll();
    return allAvatars.items.firstWhereOrNull(
          (Reference avatarRef) => avatarRef.fullPath.contains(userId),
        ) !=
        null;
  }
}

@riverpod
FirebaseAvatarService firebaseAvatarService(FirebaseAvatarServiceRef ref) =>
    FirebaseAvatarService();
