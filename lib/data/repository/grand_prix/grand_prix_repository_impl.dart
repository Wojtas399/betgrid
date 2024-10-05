import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';

import '../../../model/grand_prix.dart';
import '../../firebase/model/grand_prix_dto.dart';
import '../../firebase/service/firebase_grand_prix_service.dart';
import '../../mapper/grand_prix_mapper.dart';
import '../repository.dart';
import 'grand_prix_repository.dart';

@LazySingleton(as: GrandPrixRepository)
class GrandPrixRepositoryImpl extends Repository<GrandPrix>
    implements GrandPrixRepository {
  final FirebaseGrandPrixService _dbGrandPrixService;
  final GrandPrixMapper _grandPrixMapper;

  GrandPrixRepositoryImpl(
    this._dbGrandPrixService,
    this._grandPrixMapper,
  );

  @override
  Stream<List<GrandPrix>?> getAllGrandPrixesFromSeason(int season) async* {
    //TODO: We should always load grand prixes. Below if instruction should
    //TODO: be removed
    if (isRepositoryStateEmpty) await _fetchAllGrandPrixesFromSeason(season);
    await for (final allGrandPrixes in repositoryState$) {
      yield allGrandPrixes;
    }
  }

  @override
  Stream<GrandPrix?> getGrandPrixByIdFromSeason({
    required int season,
    required String grandPrixId,
  }) async* {
    await for (final grandPrixes in repositoryState$) {
      GrandPrix? grandPrix = grandPrixes.firstWhereOrNull(
        (GrandPrix gp) => gp.id == grandPrixId,
      );
      grandPrix ??= await _fetchGrandPrixByIdFromSeason(season, grandPrixId);
      yield grandPrix;
    }
  }

  Future<void> _fetchAllGrandPrixesFromSeason(int season) async {
    final List<GrandPrixDto> grandPrixDtos =
        await _dbGrandPrixService.fetchAllGrandPrixesFromSeason(season);
    final List<GrandPrix> grandPrixes =
        grandPrixDtos.map(_grandPrixMapper.mapFromDto).toList();
    setEntities(grandPrixes);
  }

  Future<GrandPrix?> _fetchGrandPrixByIdFromSeason(
    int season,
    String grandPrixId,
  ) async {
    final GrandPrixDto? grandPrixDto =
        await _dbGrandPrixService.fetchGrandPrixFromSeasonById(
      season: season,
      grandPrixId: grandPrixId,
    );
    if (grandPrixDto == null) return null;
    final GrandPrix grandPrix = _grandPrixMapper.mapFromDto(grandPrixDto);
    addEntity(grandPrix);
    return grandPrix;
  }
}
