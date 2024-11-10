import 'package:injectable/injectable.dart';

import '../collections.dart';
import '../model/team_dto.dart';

@injectable
class FirebaseTeamService {
  final FirebaseCollections _firebaseCollections;

  const FirebaseTeamService(this._firebaseCollections);

  Future<TeamDto?> fetchTeamById(String id) async {
    final snapshot = await _firebaseCollections.teams().doc(id).get();
    return snapshot.data();
  }
}
