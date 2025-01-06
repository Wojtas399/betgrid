import 'package:injectable/injectable.dart';

import '../firebase_collection_refs.dart';
import '../model/team_basic_info_dto.dart';

@injectable
class FirebaseTeamBasicInfoService {
  final FirebaseCollectionRefs _firebaseCollectionRefs;

  const FirebaseTeamBasicInfoService(this._firebaseCollectionRefs);

  Future<TeamBasicInfoDto?> fetchTeamBasicInfoById(String id) async {
    final snapshot =
        await _firebaseCollectionRefs.teamsBasicInfo().doc(id).get();
    return snapshot.data();
  }
}
