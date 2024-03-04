import 'package:injectable/injectable.dart';

import '../collections.dart';
import '../model/driver_dto/driver_dto.dart';

@injectable
class FirebaseDriverService {
  Future<DriverDto?> loadDriverById({required String driverId}) async {
    final snapshot = await getDriversRef().doc(driverId).get();
    return snapshot.data();
  }
}
