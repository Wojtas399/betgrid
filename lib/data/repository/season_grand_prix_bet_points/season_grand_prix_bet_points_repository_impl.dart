import 'package:betgrid_shared/firebase/model/grand_prix_bet_points_dto.dart';
import 'package:betgrid_shared/firebase/service/firebase_grand_prix_bet_points_service.dart';
import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:mutex/mutex.dart';

import '../../../model/season_grand_prix_bet_points.dart';
import '../../../ui/extensions/stream_extensions.dart';
import '../../mapper/grand_prix_bet_points_mapper.dart';
import '../repository.dart';
import 'season_grand_prix_bet_points_repository.dart';

@LazySingleton(as: SeasonGrandPrixBetPointsRepository)
class SeasonGrandPrixBetPointsRepositoryImpl
    extends Repository<SeasonGrandPrixBetPoints>
    implements SeasonGrandPrixBetPointsRepository {
  final FirebaseGrandPrixBetPointsService _fireBetPointsService;
  final GrandPrixBetPointsMapper _grandPrixBetPointsMapper;
  final _getGrandPrixesBetPointsForPlayersAndGrandPrixesMutex = Mutex();

  SeasonGrandPrixBetPointsRepositoryImpl(
    this._fireBetPointsService,
    this._grandPrixBetPointsMapper,
  );

  @override
  Stream<List<SeasonGrandPrixBetPoints>>
      getSeasonGrandPrixBetPointsForPlayersAndSeasonGrandPrixes({
    required int season,
    required List<String> idsOfPlayers,
    required List<String> idsOfSeasonGrandPrixes,
  }) async* {
    bool didRelease = false;
    await _getGrandPrixesBetPointsForPlayersAndGrandPrixesMutex.acquire();
    final stream$ = repositoryState$.asyncMap(
      (List<SeasonGrandPrixBetPoints> existingBetPointsForGps) async {
        final List<SeasonGrandPrixBetPoints> betPointsForGps = [];
        final List<_GrandPrixBetPointsFetchData> dataOfMissingBetPointsForGps =
            [];
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
          final missingGpBetPoints = await _fetchManyGrandPrixBetPointsFromDb(
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
      },
    ).distinctList();
    await for (final data in stream$) {
      yield data;
    }
  }

  @override
  Stream<SeasonGrandPrixBetPoints?> getSeasonGrandPrixBetPoints({
    required String playerId,
    required int season,
    required String seasonGrandPrixId,
  }) async* {
    await for (final entities in repositoryState$) {
      SeasonGrandPrixBetPoints? points = entities.firstWhereOrNull(
        (entity) =>
            entity.playerId == playerId &&
            entity.season == season &&
            entity.seasonGrandPrixId == seasonGrandPrixId,
      );
      points ??= await _fetchGrandPrixBetPointsFromDb((
        playerId: playerId,
        season: season,
        seasonGrandPrixId: seasonGrandPrixId,
      ));
      yield points;
    }
  }

  Future<List<SeasonGrandPrixBetPoints>> _fetchManyGrandPrixBetPointsFromDb(
    Iterable<_GrandPrixBetPointsFetchData> dataOfPointsForGpBets,
  ) async {
    final List<SeasonGrandPrixBetPoints> fetchedBetPoints = [];
    for (final gpBetPointsData in dataOfPointsForGpBets) {
      final GrandPrixBetPointsDto? gpBetPointsDto =
          await _fireBetPointsService.fetchGrandPrixBetPoints(
        userId: gpBetPointsData.playerId,
        season: gpBetPointsData.season,
        seasonGrandPrixId: gpBetPointsData.seasonGrandPrixId,
      );
      if (gpBetPointsDto != null) {
        final SeasonGrandPrixBetPoints gpBetPoints =
            _grandPrixBetPointsMapper.mapFromDto(gpBetPointsDto);
        fetchedBetPoints.add(gpBetPoints);
      }
    }
    if (fetchedBetPoints.isNotEmpty) addEntities(fetchedBetPoints);
    return fetchedBetPoints;
  }

  Future<SeasonGrandPrixBetPoints?> _fetchGrandPrixBetPointsFromDb(
    _GrandPrixBetPointsFetchData gpBetPointsData,
  ) async {
    final GrandPrixBetPointsDto? dto =
        await _fireBetPointsService.fetchGrandPrixBetPoints(
      userId: gpBetPointsData.playerId,
      season: gpBetPointsData.season,
      seasonGrandPrixId: gpBetPointsData.seasonGrandPrixId,
    );
    if (dto == null) return null;
    final SeasonGrandPrixBetPoints entity =
        _grandPrixBetPointsMapper.mapFromDto(dto);
    addEntity(entity);
    return entity;
  }
}

typedef _GrandPrixBetPointsFetchData = ({
  String playerId,
  int season,
  String seasonGrandPrixId,
});
