import 'package:injectable/injectable.dart';

import '../firebase_collection_refs.dart';
import '../model/grand_prix_basic_info_dto.dart';

@injectable
class FirebaseGrandPrixBasicInfoService {
  final FirebaseCollectionRefs _firebaseCollectionRefs;

  const FirebaseGrandPrixBasicInfoService(this._firebaseCollectionRefs);

  Future<GrandPrixBasicInfoDto?> fetchGrandPrixBasicInfoById(String id) async {
    final snapshot =
        await _firebaseCollectionRefs.grandPrixesBasicInfo().doc(id).get();
    return snapshot.data();
  }
}
