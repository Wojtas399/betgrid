import 'package:cloud_firestore/cloud_firestore.dart';

import 'model/driver_dto/driver_dto.dart';
import 'model/grand_prix_bet/grand_prix_bet_dto.dart';
import 'model/grand_prix_dto/grand_prix_dto.dart';

CollectionReference<GrandPrixDto> getGrandPrixesRef() =>
    FirebaseFirestore.instance
        .collection('GrandPrixes')
        .withConverter<GrandPrixDto>(
          fromFirestore: (snapshot, _) => GrandPrixDto.fromIdAndJson(
            snapshot.id,
            snapshot.data(),
          ),
          toFirestore: (GrandPrixDto dto, _) => dto.toJson(),
        );

CollectionReference<DriverDto> getDriversRef() =>
    FirebaseFirestore.instance.collection('Drivers').withConverter<DriverDto>(
          fromFirestore: (snapshot, _) => DriverDto.fromIdAndJson(
            snapshot.id,
            snapshot.data(),
          ),
          toFirestore: (DriverDto dto, _) => dto.toJson(),
        );

CollectionReference<GrandPrixBetDto> getGrandPrixBetsRef(String userId) =>
    FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('GrandPrixBets')
        .withConverter<GrandPrixBetDto>(
          fromFirestore: (snapshot, _) => GrandPrixBetDto.fromIdAndJson(
            snapshot.id,
            snapshot.data(),
          ),
          toFirestore: (GrandPrixBetDto dto, _) => dto.toJson(),
        );
