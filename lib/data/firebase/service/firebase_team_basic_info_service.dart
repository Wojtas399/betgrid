import 'package:injectable/injectable.dart';

import '../collections.dart';
import '../model/team_basic_info_dto.dart';

@injectable
class FirebaseTeamBasicInfoService {
  final FirebaseCollections _firebaseCollections;

  const FirebaseTeamBasicInfoService(this._firebaseCollections);

  Future<TeamBasicInfoDto?> fetchTeamBasicInfoById(String id) async {
    final snapshot = await _firebaseCollections.teamsBasicInfo().doc(id).get();
    return snapshot.data();
  }
}
