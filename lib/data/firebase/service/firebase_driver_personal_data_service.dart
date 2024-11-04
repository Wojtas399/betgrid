import 'package:injectable/injectable.dart';

import '../collections.dart';
import '../model/driver_personal_data_dto.dart';

@injectable
class FirebaseDriverPersonalDataService {
  final FirebaseCollections _firebaseCollections;

  const FirebaseDriverPersonalDataService(this._firebaseCollections);

  Future<DriverPersonalDataDto?> fetchDriverPersonalDataById(String id) async {
    final snapshot =
        await _firebaseCollections.driversPersonalData().doc(id).get();
    return snapshot.data();
  }
}
