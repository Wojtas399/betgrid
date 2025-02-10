import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import 'firebase_collections.dart';
import 'model/season_driver_dto.dart';
import 'model/season_grand_prix_dto.dart';
import 'model/team_basic_info_dto.dart';
import 'model/user_dto.dart';

@injectable
class FirebaseCollectionRefs {
  final FirebaseCollections _firebaseCollections;

  const FirebaseCollectionRefs(this._firebaseCollections);

  CollectionReference<SeasonGrandPrixDto> seasonGrandPrixes() {
    return FirebaseFirestore.instance
        .collection(_firebaseCollections.seasonGrandPrixes)
        .withConverter<SeasonGrandPrixDto>(
          fromFirestore: (snapshot, _) {
            final data = snapshot.data();
            if (data == null) {
              throw 'There is not data of SeasonGrandPrix document';
            }
            return SeasonGrandPrixDto.fromFirebase(
              id: snapshot.id,
              json: data,
            );
          },
          toFirestore: (SeasonGrandPrixDto dto, _) => dto.toJson(),
        );
  }

  CollectionReference<UserDto> users() => FirebaseFirestore.instance
      .collection(_firebaseCollections.users.main)
      .withConverter<UserDto>(
        fromFirestore: (snapshot, _) {
          final data = snapshot.data();
          if (data == null) throw 'User document data was null';
          return UserDto.fromFirebase(
            id: snapshot.id,
            json: data,
          );
        },
        toFirestore: (UserDto dto, _) => dto.toJson(),
      );

  CollectionReference<SeasonDriverDto> seasonDrivers() {
    return FirebaseFirestore.instance
        .collection(_firebaseCollections.seasonDrivers)
        .withConverter<SeasonDriverDto>(
          fromFirestore: (snapshot, _) {
            final data = snapshot.data();
            if (data == null) {
              throw 'Season driver_personal_data document is null';
            }
            return SeasonDriverDto.fromFirebase(
              id: snapshot.id,
              json: data,
            );
          },
          toFirestore: (dto, _) => dto.toJson(),
        );
  }

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
