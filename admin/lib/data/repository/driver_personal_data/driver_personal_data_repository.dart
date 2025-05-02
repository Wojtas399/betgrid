import '../../../model/driver_personal_data.dart';

abstract interface class DriverPersonalDataRepository {
  Stream<List<DriverPersonalData>> getAll();

  Stream<DriverPersonalData?> getById(String id);

  Future<void> add({required String name, required String surname});

  Future<void> deleteById(String id);
}
