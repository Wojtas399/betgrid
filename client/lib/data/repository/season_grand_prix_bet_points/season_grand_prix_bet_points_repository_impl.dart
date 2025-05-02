import 'package:betgrid_shared/firebase/model/season_grand_prix_bet_points_dto.dart';
import 'package:betgrid_shared/firebase/service/firebase_season_grand_prix_bet_points_service.dart';
import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:mutex/mutex.dart';

import '../../../model/season_grand_prix_bet_points.dart';
import '../../../ui/extensions/stream_extensions.dart';
import '../../mapper/season_grand_prix_bet_points_mapper.dart';
import '../repository.dart';
import 'season_grand_prix_bet_points_repository.dart';

@LazySingleton(as: SeasonGrandPrixBetPointsRepository)
class SeasonGrandPrixBetPointsRepositoryImpl
    extends Repository<SeasonGrandPrixBetPoints>
    implements SeasonGrandPrixBetPointsRepository {
  final FirebaseSeasonGrandPrixBetPointsService
  _fireSeasonGrandPrixBetPointsService;
  final SeasonGrandPrixBetPointsMapper _seasonGrandPrixBetPointsMapper;
  final _getGrandPrixesBetPointsForPlayersAndGrandPrixesMutex = Mutex();
  final _getBySeasonGrandPrixIdMutex = Mutex();

  SeasonGrandPrixBetPointsRepositoryImpl(
    this._fireSeasonGrandPrixBetPointsService,
    this._seasonGrandPrixBetPointsMapper,
  );

  @override
  Stream<List<SeasonGrandPrixBetPoints>> getForPlayersAndSeasonGrandPrixes({
    required int season,
    required List<String> idsOfPlayers,
    required List<String> idsOfSeasonGrandPrixes,
  }) async* {
    bool didRelease = false;
    await _getGrandPrixesBetPointsForPlayersAndGrandPrixesMutex.acquire();
    final stream$ =
        repositoryState$.asyncMap((
          List<SeasonGrandPrixBetPoints> existingBetPointsForGps,
        ) async {
          final List<SeasonGrandPrixBetPoints> betPointsForGps = [];
          final List<_GrandPrixBetPointsFetchData>
          dataOfMissingBetPointsForGps = [];
          for (final playerId in idsOfPlayers) {
            for (final gpId in idsOfSeasonGrandPrixes) {
              final SeasonGrandPrixBetPoints? existingGpBetPoints =
                  existingBetPointsForGps.firstWhereOrNull(
                    (SeasonGrandPrixBetPoints gpBetPoints) =>
                        gpBetPoints.season == season &&
                        gpBetPoints.seasonGrandPrixId == gpId &&
                        gpBetPoints.playerId == playerId,
                  );
              if (existingGpBetPoints != null) {
                betPointsForGps.add(existingGpBetPoints);
              } else {
                dataOfMissingBetPointsForGps.add((
                  playerId: playerId,
                  season: season,
                  seasonGrandPrixId: gpId,
                ));
              }
            }
          }
          if (dataOfMissingBetPointsForGps.isNotEmpty) {
            final missingGpBetPoints = await _fetchManyGrandPrixBetPoints(
              dataOfMissingBetPointsForGps,
            );
            betPointsForGps.addAll(missingGpBetPoints);
          }
          if (_getGrandPrixesBetPointsForPlayersAndGrandPrixesMutex.isLocked &&
              !didRelease) {
            _getGrandPrixesBetPointsForPlayersAndGrandPrixesMutex.release();
            didRelease = true;
          }
          return betPointsForGps;
        }).distinctList();
    await for (final data in stream$) {
      yield data;
    }
  }

  @override
  Stream<SeasonGrandPrixBetPoints?> getBySeasonGrandPrixId({
    required String playerId,
    required int season,
    required String seasonGrandPrixId,
  }) async* {
    bool didRelease = false;
    await _getBySeasonGrandPrixIdMutex.acquire();
    await for (final entities in repositoryState$) {
      SeasonGrandPrixBetPoints? points = entities.firstWhereOrNull(
        (entity) =>
            entity.playerId == playerId &&
            entity.season == season &&
            entity.seasonGrandPrixId == seasonGrandPrixId,
      );
      points ??= await _fetchGrandPrixBetPoints((
        playerId: playerId,
        season: season,
        seasonGrandPrixId: seasonGrandPrixId,
      ));
      if (_getBySeasonGrandPrixIdMutex.isLocked && !didRelease) {
        _getBySeasonGrandPrixIdMutex.release();
        didRelease = true;
      }
      yield points;
    }
  }

  Future<List<SeasonGrandPrixBetPoints>> _fetchManyGrandPrixBetPoints(
    Iterable<_GrandPrixBetPointsFetchData> dataOfPointsForGpBets,
  ) async {
    final List<SeasonGrandPrixBetPoints> fetchedBetPoints = [];
    for (final gpBetPointsData in dataOfPointsForGpBets) {
      final SeasonGrandPrixBetPointsDto? dto =
          await _fireSeasonGrandPrixBetPointsService.fetchBySeasonGrandPrixId(
            userId: gpBetPointsData.playerId,
            season: gpBetPointsData.season,
            seasonGrandPrixId: gpBetPointsData.seasonGrandPrixId,
          );
      if (dto != null) {
        final SeasonGrandPrixBetPoints gpBetPoints =
            _seasonGrandPrixBetPointsMapper.mapFromDto(dto);
        fetchedBetPoints.add(gpBetPoints);
      }
    }
    if (fetchedBetPoints.isNotEmpty) addEntities(fetchedBetPoints);
    return fetchedBetPoints;
  }

  Future<SeasonGrandPrixBetPoints?> _fetchGrandPrixBetPoints(
    _GrandPrixBetPointsFetchData gpBetPointsData,
  ) async {
    final SeasonGrandPrixBetPointsDto? dto =
        await _fireSeasonGrandPrixBetPointsService.fetchBySeasonGrandPrixId(
          userId: gpBetPointsData.playerId,
          season: gpBetPointsData.season,
          seasonGrandPrixId: gpBetPointsData.seasonGrandPrixId,
        );
    if (dto == null) return null;
    final SeasonGrandPrixBetPoints entity = _seasonGrandPrixBetPointsMapper
        .mapFromDto(dto);
    addEntity(entity);
    return entity;
  }
}

typedef _GrandPrixBetPointsFetchData =
    ({String playerId, int season, String seasonGrandPrixId});
