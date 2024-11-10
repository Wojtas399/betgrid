import 'package:betgrid/data/firebase/model/driver_personal_data_dto.dart';
import 'package:betgrid/data/firebase/service/firebase_driver_personal_data_service.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseDriverPersonalDataService extends Mock
    implements FirebaseDriverPersonalDataService {
  void mockFetchDriverPersonalDataById({
    DriverPersonalDataDto? expectedDriverPersonalDataDto,
  }) {
    when(
      () => fetchDriverPersonalDataById(any()),
    ).thenAnswer((_) => Future.value(expectedDriverPersonalDataDto));
  }
}
