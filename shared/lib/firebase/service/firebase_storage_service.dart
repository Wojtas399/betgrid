import 'package:firebase_storage/firebase_storage.dart';

import '../firebase_storage_folders.dart';

class FirebaseStorageService {
  final FirebaseStorageFolders _fireStorageFolders =
      const FirebaseStorageFolders();

  Future<String?> fetchTeamLogoImgUrl({
    required int season,
    required String teamLogoImgFileName,
  }) {
    return _fetchImgUrl(
      '${_fireStorageFolders.teamLogoImgsPath(season)}/$teamLogoImgFileName',
    );
  }

  Future<String?> fetchCarImgUrl({
    required int season,
    required String carImgFileName,
  }) {
    return _fetchImgUrl(
      '${_fireStorageFolders.carImgsPath(season)}/$carImgFileName',
    );
  }

  Future<String?> _fetchImgUrl(String path) async {
    try {
      return await FirebaseStorage.instance.ref(path).getDownloadURL();
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') {
        return null;
      }

      rethrow;
    }
  }
}
