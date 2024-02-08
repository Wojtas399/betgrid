import '../../../dependency_injection.dart';
import '../../../firebase/model/grand_prix_dto/grand_prix_dto.dart';
import '../../../firebase/service/firebase_grand_prix_service.dart';
import '../../../model/grand_prix.dart';
import '../../mapper/grand_prix_mapper.dart';
import 'grand_prix_repository.dart';

class GrandPrixRepositoryImpl implements GrandPrixRepository {
  final FirebaseGrandPrixService _firebaseGrandPrixService;

  GrandPrixRepositoryImpl()
      : _firebaseGrandPrixService = getIt<FirebaseGrandPrixService>();

  @override
  Future<List<GrandPrix>> loadAllGrandPrixes() async {
    final List<GrandPrixDto> grandPrixDtos =
        await _firebaseGrandPrixService.loadAllGrandPrixes();
    return grandPrixDtos.map(mapGrandPrixFromDto).toList();
  }
}
