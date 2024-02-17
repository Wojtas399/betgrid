import 'package:injectable/injectable.dart';

import '../collections.dart';
import '../model/driver_dto/driver_dto.dart';

@injectable
class FirebaseDriverService {
  Future<List<DriverDto>> loadAllDrivers() async {
    final snapshot = await getDriversRef().get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
