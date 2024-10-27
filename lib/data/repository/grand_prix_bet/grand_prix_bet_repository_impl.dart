import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';

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

  GrandPrixBetRepositoryImpl(
    this._dbGrandPrixBetService,
    this._grandPrixBetMapper,
  );

  @override
  Stream<List<GrandPrixBet>?> getAllGrandPrixBetsForPlayer({
    required String playerId,
  }) async* {
    if (isRepositoryStateEmpty) await _fetchAllGrandPrixBetsFromDb(playerId);
    await for (final grandPrixBets in repositoryState$) {
      yield grandPrixBets;
    }
  }

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
      yield grandPrixBet;
    }
  }

  Future<void> _fetchAllGrandPrixBetsFromDb(String playerId) async {
    final List<GrandPrixBetDto> grandPrixBetDtos =
        await _dbGrandPrixBetService.fetchAllGrandPrixBets(userId: playerId);
    final List<GrandPrixBet> grandPrixBets =
        grandPrixBetDtos.map(_grandPrixBetMapper.mapFromDto).toList();
    setEntities(grandPrixBets);
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
