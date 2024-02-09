import 'package:cloud_firestore/cloud_firestore.dart';

import 'model/driver_dto/driver_dto.dart';
import 'model/grand_prix_dto/grand_prix_dto.dart';

CollectionReference<GrandPrixDto> getGrandPrixesRef() =>
    FirebaseFirestore.instance
        .collection('GrandPrixes')
        .withConverter<GrandPrixDto>(
          fromFirestore: (snapshot, _) => GrandPrixDto.fromIdAndJson(
            snapshot.id,
            snapshot.data(),
          ),
          toFirestore: (GrandPrixDto grandPrixDto, _) => grandPrixDto.toJson(),
        );

CollectionReference<DriverDto> getDriversRef() =>
    FirebaseFirestore.instance.collection('Drivers').withConverter<DriverDto>(
          fromFirestore: (snapshot, _) => DriverDto.fromIdAndJson(
            snapshot.id,
            snapshot.data(),
          ),
          toFirestore: (DriverDto driverDto, _) => driverDto.toJson(),
        );
