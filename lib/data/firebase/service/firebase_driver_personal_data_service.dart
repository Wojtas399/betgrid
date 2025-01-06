import 'package:injectable/injectable.dart';

import '../firebase_collection_refs.dart';
import '../model/driver_personal_data_dto.dart';

@injectable
class FirebaseDriverPersonalDataService {
  final FirebaseCollectionRefs _firebaseCollectionRefs;

  const FirebaseDriverPersonalDataService(this._firebaseCollectionRefs);

  Future<DriverPersonalDataDto?> fetchDriverPersonalDataById(String id) async {
    final snapshot =
        await _firebaseCollectionRefs.driversPersonalData().doc(id).get();
    return snapshot.data();
  }
}
