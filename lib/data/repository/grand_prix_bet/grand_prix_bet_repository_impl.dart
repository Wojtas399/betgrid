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

typedef _GrandPrixBetFetchData = ({String playerId, String grandPrixId});

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
  Stream<List<GrandPrixBet>> getGrandPrixBetsForPlayersAndGrandPrixes({
    required List<String> idsOfPlayers,
    required List<String> idsOfGrandPrixes,
  }) =>
      repositoryState$.asyncMap(
        (List<GrandPrixBet> existingGpBets) async {
          final List<GrandPrixBet> gpBets = [];
          final List<_GrandPrixBetFetchData> dataOfMissingGpBets = [];
          for (final playerId in idsOfPlayers) {
            for (final grandPrixId in idsOfGrandPrixes) {
              final GrandPrixBet? existingGpBet =
                  existingGpBets.firstWhereOrNull(
                (GrandPrixBet gpBet) =>
                    gpBet.grandPrixId == grandPrixId &&
                    gpBet.playerId == playerId,
              );
              if (existingGpBet != null) {
                gpBets.add(existingGpBet);
              } else {
                dataOfMissingGpBets.add((
                  playerId: playerId,
                  grandPrixId: grandPrixId,
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
  Stream<GrandPrixBet?> getGrandPrixBetForPlayerAndGrandPrix({
    required String playerId,
    required String grandPrixId,
  }) async* {
    bool didRelease = false;
    await _getGrandPrixBetForPlayerAndGrandprixMutex.acquire();
    await for (final grandPrixBets in repositoryState$) {
      GrandPrixBet? grandPrixBet = grandPrixBets.firstWhereOrNull(
        (GrandPrixBet grandPrixBet) =>
            grandPrixBet.playerId == playerId &&
            grandPrixBet.grandPrixId == grandPrixId,
      );
      grandPrixBet ??= await _fetchGrandPrixBetFromDb((
        playerId: playerId,
        grandPrixId: grandPrixId,
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
    required String grandPrixId,
    List<String?> qualiStandingsByDriverIds = const [],
    String? p1DriverId,
    String? p2DriverId,
    String? p3DriverId,
    String? p10DriverId,
    String? fastestLapDriverId,
    List<String> dnfDriverIds = const [],
    bool? willBeSafetyCar,
    bool? willBeRedFlag,
  }) async {
    final GrandPrixBetDto? addedGrandPrixBetDto =
        await _dbGrandPrixBetService.addGrandPrixBet(
      userId: playerId,
      grandPrixId: grandPrixId,
      qualiStandingsByDriverIds: qualiStandingsByDriverIds,
      p1DriverId: p1DriverId,
      p2DriverId: p2DriverId,
      p3DriverId: p3DriverId,
      p10DriverId: p10DriverId,
      fastestLapDriverId: fastestLapDriverId,
      dnfDriverIds: dnfDriverIds,
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
    List<String?>? qualiStandingsByDriverIds,
    String? p1DriverId,
    String? p2DriverId,
    String? p3DriverId,
    String? p10DriverId,
    String? fastestLapDriverId,
    List<String>? dnfDriverIds,
    bool? willBeSafetyCar,
    bool? willBeRedFlag,
  }) async {
    final GrandPrixBetDto? updatedGrandPrixBetDto =
        await _dbGrandPrixBetService.updateGrandPrixBet(
      userId: playerId,
      grandPrixBetId: grandPrixBetId,
      qualiStandingsByDriverIds: qualiStandingsByDriverIds,
      p1DriverId: p1DriverId,
      p2DriverId: p2DriverId,
      p3DriverId: p3DriverId,
      p10DriverId: p10DriverId,
      fastestLapDriverId: fastestLapDriverId,
      dnfDriverIds: dnfDriverIds,
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
          await _dbGrandPrixBetService.fetchGrandPrixBetByGrandPrixId(
        playerId: gpBetData.playerId,
        grandPrixId: gpBetData.grandPrixId,
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
        await _dbGrandPrixBetService.fetchGrandPrixBetByGrandPrixId(
      playerId: gpBetData.playerId,
      grandPrixId: gpBetData.grandPrixId,
    );
    if (betDto == null) return null;
    final GrandPrixBet bet = _grandPrixBetMapper.mapFromDto(betDto);
    addEntity(bet);
    return bet;
  }
}
