import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';

import '../../../firebase/model/grand_prix_bet_dto/grand_prix_bet_dto.dart';
import '../../../firebase/service/firebase_grand_prix_bet_service.dart';
import '../../../model/grand_prix_bet.dart';
import '../../mapper/grand_prix_bet_mapper.dart';
import '../repository.dart';
import 'grand_prix_bet_repository.dart';

@LazySingleton(as: GrandPrixBetRepository)
class GrandPrixBetRepositoryImpl extends Repository<GrandPrixBet>
    implements GrandPrixBetRepository {
  final FirebaseGrandPrixBetService _dbGrandPrixBetService;

  GrandPrixBetRepositoryImpl(this._dbGrandPrixBetService);

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
  Stream<GrandPrixBet?> getBetByGrandPrixIdAndPlayerId({
    required String playerId,
    required String grandPrixId,
  }) async* {
    await for (final grandPrixBets in repositoryState$) {
      GrandPrixBet? grandPrixBet = grandPrixBets.firstWhereOrNull(
        (GrandPrixBet grandPrixBet) =>
            grandPrixBet.playerId == playerId &&
            grandPrixBet.grandPrixId == grandPrixId,
      );
      grandPrixBet ??=
          await _fetchGrandPrixBetByGrandPrixIdFromDb(playerId, grandPrixId);
      yield grandPrixBet;
    }
  }

  @override
  Future<void> addGrandPrixBets({
    required String playerId,
    required List<GrandPrixBet> grandPrixBets,
  }) async {
    for (final grandPrixBet in grandPrixBets) {
      await _dbGrandPrixBetService.addGrandPrixBet(
        userId: playerId,
        grandPrixBetDto: mapGrandPrixBetToDto(grandPrixBet),
      );
    }
    addEntities(grandPrixBets);
  }

  Future<void> _fetchAllGrandPrixBetsFromDb(String playerId) async {
    final List<GrandPrixBetDto> grandPrixBetDtos =
        await _dbGrandPrixBetService.fetchAllGrandPrixBets(userId: playerId);
    final List<GrandPrixBet> grandPrixBets =
        grandPrixBetDtos.map(mapGrandPrixBetFromDto).toList();
    setEntities(grandPrixBets);
  }

  Future<GrandPrixBet?> _fetchGrandPrixBetByGrandPrixIdFromDb(
    String userId,
    String grandPrixId,
  ) async {
    final GrandPrixBetDto? betDto =
        await _dbGrandPrixBetService.fetchGrandPrixBetByGrandPrixId(
      userId: userId,
      grandPrixId: grandPrixId,
    );
    if (betDto == null) return null;
    final GrandPrixBet bet = mapGrandPrixBetFromDto(betDto);
    addEntity(bet);
    return bet;
  }
}
