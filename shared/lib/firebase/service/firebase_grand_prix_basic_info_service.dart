import '../firebase_collections_references.dart';
import '../model/grand_prix_basic_info_dto.dart';

class FirebaseGrandPrixBasicInfoService {
  final _firebaseCollectionsReferences = FirebaseCollectionsReferences();

  Future<Iterable<GrandPrixBasicInfoDto>> fetchAll() async {
    final snapshot =
        await _firebaseCollectionsReferences.grandPrixesBasicInfo().get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<GrandPrixBasicInfoDto?> fetchById(String id) async {
    final snapshot = await _firebaseCollectionsReferences
        .grandPrixesBasicInfo()
        .doc(id)
        .get();
    return snapshot.data();
  }

  Future<GrandPrixBasicInfoDto?> add({
    required String name,
    required String countryAlpha2Code,
  }) async {
    final dto = GrandPrixBasicInfoDto(
      name: name,
      countryAlpha2Code: countryAlpha2Code,
    );
    final docRef =
        await _firebaseCollectionsReferences.grandPrixesBasicInfo().add(dto);
    final snapshot = await docRef.get();
    return snapshot.data();
  }

  Future<void> deleteById(String id) async {
    await _firebaseCollectionsReferences
        .grandPrixesBasicInfo()
        .doc(id)
        .delete();
  }
}
