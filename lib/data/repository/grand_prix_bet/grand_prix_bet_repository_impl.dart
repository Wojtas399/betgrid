import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:mutex/mutex.dart';

import '../../../model/grand_prix_bet.dart';
import '../../../ui/extensions/stream_extensions.dart';
import '../../firebase/model/grand_prix_bet_dto.dart';
import '../../firebase/service/firebase_grand_prix_bet_service.dart';
import '../../mapper/grand_prix_bet_mapper.dart';
import '../repository.dart';
import 'grand_prix_bet_repository.dart';

@LazySingleton(as: GrandPrixBetRepository)
class GrandPrixBetRepositoryImpl extends Repository<GrandPrixBet>
    implements GrandPrixBetRepository {
  final FirebaseGrandPrixBetService _dbGrandPrixBetService;
  final GrandPrixBetMapper _grandPrixBetMapper;
  final _getGrandPrixBetForPlayerAndGrandprixMutex = Mutex();

  GrandPrixBetRepositoryImpl(
    this._dbGrandPrixBetService,
    this._grandPrixBetMapper,
  );

  @override
  Stream<List<GrandPrixBet>> getGrandPrixBetsForPlayersAndSeasonGrandPrixes({
    required List<String> idsOfPlayers,
    required List<String> idsOfSeasonGrandPrixes,
  }) =>
      repositoryState$.asyncMap(
        (List<GrandPrixBet> existingGpBets) async {
          final List<GrandPrixBet> gpBets = [];
          final List<_GrandPrixBetFetchData> dataOfMissingGpBets = [];
          for (final playerId in idsOfPlayers) {
            for (final seasonGrandPrixId in idsOfSeasonGrandPrixes) {
              final GrandPrixBet? existingGpBet =
                  existingGpBets.firstWhereOrNull(
                (GrandPrixBet gpBet) =>
                    gpBet.seasonGrandPrixId == seasonGrandPrixId &&
                    gpBet.playerId == playerId,
              );
              if (existingGpBet != null) {
                gpBets.add(existingGpBet);
              } else {
                dataOfMissingGpBets.add((
                  playerId: playerId,
                  seasonGrandPrixId: seasonGrandPrixId,
                ));
              }
            }
          }
          if (dataOfMissingGpBets.isNotEmpty) {
            final missingGpBets = await _fetchManyGrandPrixBetsFromDb(
              dataOfMissingGpBets,
            );
            gpBets.addAll(missingGpBets);
          }
          return gpBets;
        },
      ).distinctList();

  @override
  Stream<GrandPrixBet?> getGrandPrixBetForPlayerAndSeasonGrandPrix({
    required String playerId,
    required String seasonGrandPrixId,
  }) async* {
    bool didRelease = false;
    await _getGrandPrixBetForPlayerAndGrandprixMutex.acquire();
    await for (final grandPrixBets in repositoryState$) {
      GrandPrixBet? grandPrixBet = grandPrixBets.firstWhereOrNull(
        (GrandPrixBet grandPrixBet) =>
            grandPrixBet.playerId == playerId &&
            grandPrixBet.seasonGrandPrixId == seasonGrandPrixId,
      );
      grandPrixBet ??= await _fetchGrandPrixBetFromDb((
        playerId: playerId,
        seasonGrandPrixId: seasonGrandPrixId,
      ));
      if (_getGrandPrixBetForPlayerAndGrandprixMutex.isLocked && !didRelease) {
        _getGrandPrixBetForPlayerAndGrandprixMutex.release();
        didRelease = true;
      }
      yield grandPrixBet;
    }
  }

  @override
  Future<void> addGrandPrixBet({
    required String playerId,
    required String seasonGrandPrixId,
    List<String?> qualiStandingsBySeasonDriverIds = const [],
    String? p1SeasonDriverId,
    String? p2SeasonDriverId,
    String? p3SeasonDriverId,
    String? p10SeasonDriverId,
    String? fastestLapSeasonDriverId,
    List<String> dnfSeasonDriverIds = const [],
    bool? willBeSafetyCar,
    bool? willBeRedFlag,
  }) async {
    final GrandPrixBetDto? addedGrandPrixBetDto =
        await _dbGrandPrixBetService.addGrandPrixBet(
      userId: playerId,
      seasonGrandPrixId: seasonGrandPrixId,
      qualiStandingsBySeasonDriverIds: qualiStandingsBySeasonDriverIds,
      p1SeasonDriverId: p1SeasonDriverId,
      p2SeasonDriverId: p2SeasonDriverId,
      p3SeasonDriverId: p3SeasonDriverId,
      p10SeasonDriverId: p10SeasonDriverId,
      fastestLapSeasonDriverId: fastestLapSeasonDriverId,
      dnfSeasonDriverIds: dnfSeasonDriverIds,
      willBeSafetyCar: willBeSafetyCar,
      willBeRedFlag: willBeRedFlag,
    );
    if (addedGrandPrixBetDto != null) {
      final GrandPrixBet addedGrandPrixBet =
          _grandPrixBetMapper.mapFromDto(addedGrandPrixBetDto);
      addEntity(addedGrandPrixBet);
    }
  }

  @override
  Future<void> updateGrandPrixBet({
    required String playerId,
    required String grandPrixBetId,
    List<String?>? qualiStandingsBySeasonDriverIds,
    String? p1SeasonDriverId,
    String? p2SeasonDriverId,
    String? p3SeasonDriverId,
    String? p10SeasonDriverId,
    String? fastestLapSeasonDriverId,
    List<String>? dnfSeasonDriverIds,
    bool? willBeSafetyCar,
    bool? willBeRedFlag,
  }) async {
    final GrandPrixBetDto? updatedGrandPrixBetDto =
        await _dbGrandPrixBetService.updateGrandPrixBet(
      userId: playerId,
      grandPrixBetId: grandPrixBetId,
      qualiStandingsBySeasonDriverIds: qualiStandingsBySeasonDriverIds,
      p1SeasonDriverId: p1SeasonDriverId,
      p2SeasonDriverId: p2SeasonDriverId,
      p3SeasonDriverId: p3SeasonDriverId,
      p10SeasonDriverId: p10SeasonDriverId,
      fastestLapSeasonDriverId: fastestLapSeasonDriverId,
      dnfSeasonDriverIds: dnfSeasonDriverIds,
      willBeSafetyCar: willBeSafetyCar,
      willBeRedFlag: willBeRedFlag,
    );
    if (updatedGrandPrixBetDto != null) {
      final GrandPrixBet updatedGrandPrixBet =
          _grandPrixBetMapper.mapFromDto(updatedGrandPrixBetDto);
      updateEntity(updatedGrandPrixBet);
    }
  }

  Future<List<GrandPrixBet>> _fetchManyGrandPrixBetsFromDb(
    List<_GrandPrixBetFetchData> gpBetsData,
  ) async {
    final List<GrandPrixBet> fetchedGpBets = [];
    for (final _GrandPrixBetFetchData gpBetData in gpBetsData) {
      final GrandPrixBetDto? gpBetDto =
          await _dbGrandPrixBetService.fetchGrandPrixBetBySeasonGrandPrixId(
        playerId: gpBetData.playerId,
        seasonGrandPrixId: gpBetData.seasonGrandPrixId,
      );
      if (gpBetDto != null) {
        final GrandPrixBet gpBet = _grandPrixBetMapper.mapFromDto(gpBetDto);
        fetchedGpBets.add(gpBet);
      }
    }
    if (fetchedGpBets.isNotEmpty) addEntities(fetchedGpBets);
    return fetchedGpBets;
  }

  Future<GrandPrixBet?> _fetchGrandPrixBetFromDb(
    _GrandPrixBetFetchData gpBetData,
  ) async {
    final GrandPrixBetDto? betDto =
        await _dbGrandPrixBetService.fetchGrandPrixBetBySeasonGrandPrixId(
      playerId: gpBetData.playerId,
      seasonGrandPrixId: gpBetData.seasonGrandPrixId,
    );
    if (betDto == null) return null;
    final GrandPrixBet bet = _grandPrixBetMapper.mapFromDto(betDto);
    addEntity(bet);
    return bet;
  }
}

typedef _GrandPrixBetFetchData = ({String playerId, String seasonGrandPrixId});
