import 'package:betgrid/firebase/model/driver_dto/driver_dto.dart';
import 'package:betgrid/firebase/service/firebase_driver_service.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseDriverService extends Mock implements FirebaseDriverService {
  void mockLoadAllDrivers(List<DriverDto> driverDtos) {
    when(loadAllDrivers).thenAnswer((_) => Future.value(driverDtos));
  }
}
