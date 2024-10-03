import 'package:injectable/injectable.dart';

import '../collections.dart';
import '../model/driver_dto/driver_dto.dart';

@injectable
class FirebaseDriverService {
  final FirebaseCollections _firebaseCollections;

  const FirebaseDriverService(this._firebaseCollections);

  Future<List<DriverDto>> fetchAllDrivers() async {
    final snapshot = await _firebaseCollections.drivers().get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<DriverDto?> fetchDriverById({required String driverId}) async {
    final snapshot = await _firebaseCollections.drivers().doc(driverId).get();
    return snapshot.data();
  }
}
