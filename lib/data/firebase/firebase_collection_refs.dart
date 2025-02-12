import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import 'firebase_collections.dart';
import 'model/team_basic_info_dto.dart';

@injectable
class FirebaseCollectionRefs {
  final FirebaseCollections _firebaseCollections;

  const FirebaseCollectionRefs(this._firebaseCollections);

  CollectionReference<TeamBasicInfoDto> teamsBasicInfo() {
    return FirebaseFirestore.instance
        .collection(_firebaseCollections.teamsBasicInfo)
        .withConverter<TeamBasicInfoDto>(
          fromFirestore: (snapshot, _) {
            final data = snapshot.data();
            if (data == null) throw 'TeamBasicInfo document is null';
            return TeamBasicInfoDto.fromFirebase(
              id: snapshot.id,
              json: data,
            );
          },
          toFirestore: (dto, _) => dto.toJson(),
        );
  }
}
