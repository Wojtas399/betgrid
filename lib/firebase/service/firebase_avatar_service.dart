import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';

@injectable
class FirebaseAvatarService {
  Reference _getAvatarRef(String userId) => FirebaseStorage.instance.ref(
        'Avatars/$userId.jpg',
      );

  Future<String?> loadAvatarUrlForUser({required String userId}) async {
    try {
      return await _getAvatarRef(userId).getDownloadURL();
    } catch (_) {
      return null;
    }
  }

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
    try {
      await _getAvatarRef(userId).getDownloadURL();
      return true;
    } catch (error) {
      return false;
    }
  }
}
