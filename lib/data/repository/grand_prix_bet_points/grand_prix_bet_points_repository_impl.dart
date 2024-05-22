import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';

import '../../../firebase/model/grand_prix_bet_points_dto/grand_prix_bet_points_dto.dart';
import '../../../firebase/service/firebase_grand_prix_bet_points_service.dart';
import '../../../model/grand_prix_bet_points.dart';
import '../../../ui/extensions/stream_extensions.dart';
import '../../mapper/grand_prix_bet_points_mapper.dart';
import '../repository.dart';
import 'grand_prix_bet_points_repository.dart';

typedef _GrandPrixBetPointsFetchData = ({String playerId, String grandPrixId});

@LazySingleton(as: GrandPrixBetPointsRepository)
class GrandPrixBetPointsRepositoryImpl extends Repository<GrandPrixBetPoints>
    implements GrandPrixBetPointsRepository {
  final FirebaseGrandPrixBetPointsService _dbBetPointsService;

  GrandPrixBetPointsRepositoryImpl(this._dbBetPointsService);

  @override
  Stream<List<GrandPrixBetPoints>>
      getGrandPrixBetPointsForPlayersAndGrandPrixes({
    required List<String> idsOfPlayers,
    required List<String> idsOfGrandPrixes,
  }) =>
          repositoryState$.asyncMap(
            (List<GrandPrixBetPoints> existingBetPointsForGps) async {
              final List<GrandPrixBetPoints> betPointsForGps = [];
              final List<_GrandPrixBetPointsFetchData>
                  dataOfMissingBetPointsForGps = [];
              for (final playerId in idsOfPlayers) {
                for (final gpId in idsOfGrandPrixes) {
                  final GrandPrixBetPoints? existingGpBetPoints =
                      existingBetPointsForGps.firstWhereOrNull(
                    (GrandPrixBetPoints gpBetPoints) =>
                        gpBetPoints.grandPrixId == gpId &&
                        gpBetPoints.playerId == playerId,
                  );
                  if (existingGpBetPoints != null) {
                    betPointsForGps.add(existingGpBetPoints);
                  } else {
                    dataOfMissingBetPointsForGps.add((
                      playerId: playerId,
                      grandPrixId: gpId,
                    ));
                  }
                }
              }
              if (dataOfMissingBetPointsForGps.isNotEmpty) {
                final missingGpBetPoints =
                    await _fetchManyGrandPrixBetPointsFromDb(
                  dataOfMissingBetPointsForGps,
                );
                betPointsForGps.addAll(missingGpBetPoints);
              }
              return betPointsForGps;
            },
          ).distinctList();

  @override
  Stream<GrandPrixBetPoints?> getGrandPrixBetPointsForPlayerAndGrandPrix({
    required String playerId,
    required String grandPrixId,
  }) async* {
    await for (final entities in repositoryState$) {
      GrandPrixBetPoints? points = entities.firstWhereOrNull(
        (entity) =>
            entity.playerId == playerId && entity.grandPrixId == grandPrixId,
      );
      points ??= await _fetchGrandPrixBetPointsFromDb((
        playerId: playerId,
        grandPrixId: grandPrixId,
      ));
      yield points;
    }
  }

  Future<List<GrandPrixBetPoints>> _fetchManyGrandPrixBetPointsFromDb(
    Iterable<_GrandPrixBetPointsFetchData> dataOfPointsForGpBets,
  ) async {
    final List<GrandPrixBetPoints> fetchedBetPoints = [];
    for (final gpBetPointsData in dataOfPointsForGpBets) {
      final GrandPrixBetPointsDto? gpBetPointsDto = await _dbBetPointsService
          .fetchGrandPrixBetPointsByPlayerIdAndGrandPrixId(
        playerId: gpBetPointsData.playerId,
        grandPrixId: gpBetPointsData.grandPrixId,
      );
      if (gpBetPointsDto != null) {
        final GrandPrixBetPoints gpBetPoints =
            mapGrandPrixBetPointsFromDto(gpBetPointsDto);
        fetchedBetPoints.add(gpBetPoints);
      }
    }
    addEntities(fetchedBetPoints);
    return fetchedBetPoints;
  }

  Future<GrandPrixBetPoints?> _fetchGrandPrixBetPointsFromDb(
    _GrandPrixBetPointsFetchData gpBetPointsData,
  ) async {
    final GrandPrixBetPointsDto? dto = await _dbBetPointsService
        .fetchGrandPrixBetPointsByPlayerIdAndGrandPrixId(
      playerId: gpBetPointsData.playerId,
      grandPrixId: gpBetPointsData.grandPrixId,
    );
    if (dto == null) return null;
    final GrandPrixBetPoints entity = mapGrandPrixBetPointsFromDto(dto);
    addEntity(entity);
    return entity;
  }
}
