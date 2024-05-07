import 'package:injectable/injectable.dart';

import '../collections.dart';
import '../model/driver_dto/driver_dto.dart';

@injectable
class FirebaseDriverService {
  Future<List<DriverDto>> fetchAllDrivers() async {
    final snapshot = await getDriversRef().get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<DriverDto?> fetchDriverById({required String driverId}) async {
    final snapshot = await getDriversRef().doc(driverId).get();
    return snapshot.data();
  }
}
