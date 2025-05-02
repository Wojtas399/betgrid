import '../firebase_collections_references.dart';
import '../model/driver_personal_data_dto.dart';

class FirebaseDriverPersonalDataService {
  final _firebaseCollectionsReferences = FirebaseCollectionsReferences();

  Future<List<DriverPersonalDataDto>> fetchAll() async {
    final snapshot =
        await _firebaseCollectionsReferences.driversPersonalData().get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<DriverPersonalDataDto?> fetchById(String id) async {
    final snapshot = await _firebaseCollectionsReferences
        .driversPersonalData()
        .doc(id)
        .get();
    return snapshot.data();
  }

  Future<DriverPersonalDataDto?> add({
    required String name,
    required String surname,
  }) async {
    final dto = DriverPersonalDataDto(name: name, surname: surname);
    final docRef =
        await _firebaseCollectionsReferences.driversPersonalData().add(dto);
    final snapshot = await docRef.get();
    return snapshot.data();
  }

  Future<void> deleteById(String id) async {
    await _firebaseCollectionsReferences.driversPersonalData().doc(id).delete();
  }
}
