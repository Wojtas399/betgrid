import 'package:collection/collection.dart';

import '../../../dependency_injection.dart';
import '../../../firebase/model/grand_prix_bet_points_dto/grand_prix_bet_points_dto.dart';
import '../../../firebase/service/firebase_grand_prix_bet_points_service.dart';
import '../../../model/grand_prix_bet_points.dart';
import '../../mapper/grand_prix_bet_points_mapper.dart';
import '../repository.dart';
import 'grand_prix_bet_points_repository.dart';

class GrandPrixBetPointsRepositoryImpl extends Repository<GrandPrixBetPoints>
    implements GrandPrixBetPointsRepository {
  final FirebaseGrandPrixBetPointsService _dbBetPointsService;

  GrandPrixBetPointsRepositoryImpl({super.initialData})
      : _dbBetPointsService = getIt<FirebaseGrandPrixBetPointsService>();

  @override
  Stream<GrandPrixBetPoints?> getPointsForPlayerByGrandPrixId({
    required String playerId,
    required String grandPrixId,
  }) async* {
    await for (final entities in repositoryState$) {
      GrandPrixBetPoints? points = entities.firstWhereOrNull(
        (entity) =>
            entity.playerId == playerId && entity.grandPrixId == grandPrixId,
      );
      points ??= await _fetchGrandPrixBetPointsFromDb(grandPrixId, playerId);
      yield points;
    }
  }

  Future<GrandPrixBetPoints?> _fetchGrandPrixBetPointsFromDb(
    String grandPrixId,
    String playerId,
  ) async {
    final GrandPrixBetPointsDto? dto = await _dbBetPointsService
        .loadGrandPrixBetPointsByPlayerIdAndGrandPrixId(
      playerId: playerId,
      grandPrixId: grandPrixId,
    );
    if (dto == null) return null;
    final GrandPrixBetPoints entity = mapGrandPrixBetPointsFromDto(dto);
    addEntity(entity);
    return entity;
  }
}
