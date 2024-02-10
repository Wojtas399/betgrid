import 'package:collection/collection.dart';

import '../../../dependency_injection.dart';
import '../../../firebase/model/grand_prix_dto/grand_prix_dto.dart';
import '../../../firebase/service/firebase_grand_prix_service.dart';
import '../../../model/grand_prix.dart';
import '../../mapper/grand_prix_mapper.dart';
import '../repository.dart';
import 'grand_prix_repository.dart';

class GrandPrixRepositoryImpl extends Repository<GrandPrix>
    implements GrandPrixRepository {
  final FirebaseGrandPrixService _dbGrandPrixService;

  GrandPrixRepositoryImpl({super.initialData})
      : _dbGrandPrixService = getIt<FirebaseGrandPrixService>();

  @override
  Future<List<GrandPrix>> loadAllGrandPrixes() async {
    final List<GrandPrixDto> grandPrixDtos =
        await _dbGrandPrixService.loadAllGrandPrixes();
    final List<GrandPrix> grandPrixes =
        grandPrixDtos.map(mapGrandPrixFromDto).toList();
    setEntities(grandPrixes);
    return grandPrixes;
  }

  @override
  Future<GrandPrix?> loadGrandPrixById({required String grandPrixId}) async {
    final List<GrandPrix>? existingGrandPrixes = await repositoryState$.first;
    GrandPrix? grandPrix = existingGrandPrixes?.firstWhereOrNull(
      (GrandPrix gp) => gp.id == grandPrixId,
    );
    grandPrix ??= await _loadGrandPrixFromDb(grandPrixId);
    return grandPrix;
  }

  Future<GrandPrix?> _loadGrandPrixFromDb(String grandPrixId) async {
    final GrandPrixDto? grandPrixDto =
        await _dbGrandPrixService.loadGrandPrixById(
      grandPrixId: grandPrixId,
    );
    if (grandPrixDto == null) return null;
    final GrandPrix grandPrix = mapGrandPrixFromDto(grandPrixDto);
    addEntity(grandPrix);
    return grandPrix;
  }
}
