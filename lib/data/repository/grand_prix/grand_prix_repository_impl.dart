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
  Stream<List<GrandPrix>?> getAllGrandPrixes() async* {
    await for (final repoState in repositoryState$) {
      List<GrandPrix>? grandPrixes = repoState;
      if (grandPrixes == null || grandPrixes.isEmpty) {
        grandPrixes = await _loadGrandPrixesFromDb();
      }
      yield grandPrixes;
    }
  }

  @override
  Stream<GrandPrix?> getGrandPrixById({required String grandPrixId}) async* {
    await for (final grandPrixes in repositoryState$) {
      GrandPrix? grandPrix = grandPrixes?.firstWhereOrNull(
        (GrandPrix gp) => gp.id == grandPrixId,
      );
      grandPrix ??= await _fetchGrandPrixFromDb(grandPrixId);
      yield grandPrix;
    }
  }

  Future<List<GrandPrix>> _loadGrandPrixesFromDb() async {
    final List<GrandPrixDto> grandPrixDtos =
        await _dbGrandPrixService.loadAllGrandPrixes();
    final List<GrandPrix> grandPrixes =
        grandPrixDtos.map(mapGrandPrixFromDto).toList();
    setEntities(grandPrixes);
    return grandPrixes;
  }

  Future<GrandPrix?> _fetchGrandPrixFromDb(String grandPrixId) async {
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
