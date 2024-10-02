import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:mutex/mutex.dart';

import '../../../model/grand_prix_bet_points.dart';
import '../../../ui/extensions/stream_extensions.dart';
import '../../firebase/model/grand_prix_bet_points_dto/grand_prix_bet_points_dto.dart';
import '../../firebase/service/firebase_grand_prix_bet_points_service.dart';
import '../../mapper/grand_prix_bet_points_mapper.dart';
import '../repository.dart';
import 'grand_prix_bet_points_repository.dart';

typedef _GrandPrixBetPointsFetchData = ({String playerId, String grandPrixId});

@LazySingleton(as: GrandPrixBetPointsRepository)
class GrandPrixBetPointsRepositoryImpl extends Repository<GrandPrixBetPoints>
    implements GrandPrixBetPointsRepository {
  final FirebaseGrandPrixBetPointsService _dbBetPointsService;
  final GrandPrixBetPointsMapper _grandPrixBetPointsMapper;
  final _getGrandPrixesBetPointsForPlayersAndGrandPrixesMutex = Mutex();

  GrandPrixBetPointsRepositoryImpl(
    this._dbBetPointsService,
    this._grandPrixBetPointsMapper,
  );

  @override
  Stream<List<GrandPrixBetPoints>>
      getGrandPrixBetPointsForPlayersAndGrandPrixes({
    required List<String> idsOfPlayers,
    required List<String> idsOfGrandPrixes,
  }) async* {
    await _getGrandPrixesBetPointsForPlayersAndGrandPrixesMutex.acquire();
    final stream$ = repositoryState$.asyncMap(
      (List<GrandPrixBetPoints> existingBetPointsForGps) async {
        final List<GrandPrixBetPoints> betPointsForGps = [];
        final List<_GrandPrixBetPointsFetchData> dataOfMissingBetPointsForGps =
            [];
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
          final missingGpBetPoints = await _fetchManyGrandPrixBetPointsFromDb(
            dataOfMissingBetPointsForGps,
          );
          betPointsForGps.addAll(missingGpBetPoints);
        }
        if (_getGrandPrixesBetPointsForPlayersAndGrandPrixesMutex.isLocked) {
          _getGrandPrixesBetPointsForPlayersAndGrandPrixesMutex.release();
        }
        return betPointsForGps;
      },
    ).distinctList();
    await for (final data in stream$) {
      yield data;
    }
  }

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
            _grandPrixBetPointsMapper.mapFromDto(gpBetPointsDto);
        fetchedBetPoints.add(gpBetPoints);
      }
    }
    if (fetchedBetPoints.isNotEmpty) addEntities(fetchedBetPoints);
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
    final GrandPrixBetPoints entity = _grandPrixBetPointsMapper.mapFromDto(dto);
    addEntity(entity);
    return entity;
  }
}
