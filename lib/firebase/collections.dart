import 'package:cloud_firestore/cloud_firestore.dart';

import 'model/driver_dto/driver_dto.dart';
import 'model/grand_prix_bet_dto/grand_prix_bet_dto.dart';
import 'model/grand_prix_dto/grand_prix_dto.dart';
import 'model/user_dto/user_dto.dart';

CollectionReference<GrandPrixDto> getGrandPrixesRef() =>
    FirebaseFirestore.instance
        .collection('GrandPrixes')
        .withConverter<GrandPrixDto>(
          fromFirestore: (snapshot, _) {
            final data = snapshot.data();
            if (data == null) throw 'Grand prix document data was null';
            return GrandPrixDto.fromIdAndJson(snapshot.id, data);
          },
          toFirestore: (GrandPrixDto dto, _) => dto.toJson(),
        );

CollectionReference<DriverDto> getDriversRef() =>
    FirebaseFirestore.instance.collection('Drivers').withConverter<DriverDto>(
          fromFirestore: (snapshot, _) {
            final data = snapshot.data();
            if (data == null) throw 'Driver document data was null';
            return DriverDto.fromIdAndJson(snapshot.id, data);
          },
          toFirestore: (DriverDto dto, _) => dto.toJson(),
        );

CollectionReference<UserDto> getUsersRef() =>
    FirebaseFirestore.instance.collection('Users').withConverter<UserDto>(
          fromFirestore: (snapshot, _) {
            final data = snapshot.data();
            if (data == null) throw 'User document data was null';
            return UserDto.fromIdAndJson(snapshot.id, data);
          },
          toFirestore: (UserDto dto, _) => dto.toJson(),
        );

CollectionReference<GrandPrixBetDto> getGrandPrixBetsRef(String userId) =>
    FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('GrandPrixBets')
        .withConverter<GrandPrixBetDto>(
          fromFirestore: (snapshot, _) {
            final data = snapshot.data();
            if (data == null) throw 'Grand prix bet document was null';
            return GrandPrixBetDto.fromIdAndJson(snapshot.id, data);
          },
          toFirestore: (GrandPrixBetDto dto, _) => dto.toJson(),
        );
