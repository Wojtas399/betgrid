import '../../../model/driver_personal_data.dart';

abstract interface class DriverPersonalDataRepository {
  Stream<DriverPersonalData?> getDriverPersonalDataById(String id);
}
