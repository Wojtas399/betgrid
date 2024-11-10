import 'package:injectable/injectable.dart';

import '../collections.dart';
import '../model/grand_prix_basic_info_dto.dart';

@injectable
class FirebaseGrandPrixBasicInfoService {
  final FirebaseCollections _firebaseCollections;

  const FirebaseGrandPrixBasicInfoService(this._firebaseCollections);

  Future<GrandPrixBasicInfoDto?> fetchGrandPrixBasicInfoById(String id) async {
    final snapshot =
        await _firebaseCollections.grandPrixesBasicInfo().doc(id).get();
    return snapshot.data();
  }
}
