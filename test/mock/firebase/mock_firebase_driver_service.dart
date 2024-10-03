import 'package:betgrid/data/firebase/model/driver_dto.dart';
import 'package:betgrid/data/firebase/service/firebase_driver_service.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseDriverService extends Mock implements FirebaseDriverService {
  void mockFetchAllDrivers({required List<DriverDto> allDriverDtos}) {
    when(fetchAllDrivers).thenAnswer((_) => Future.value(allDriverDtos));
  }

  void mockFetchDriverById({DriverDto? driverDto}) {
    when(
      () => fetchDriverById(
        driverId: any(named: 'driverId'),
      ),
    ).thenAnswer((_) => Future.value(driverDto));
  }
}
