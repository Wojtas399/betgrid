import 'package:collection/collection.dart';

import '../../../dependency_injection.dart';
import '../../../firebase/model/grand_prix_bet/grand_prix_bet_dto.dart';
import '../../../firebase/service/firebase_grand_prix_bet_service.dart';
import '../../../model/grand_prix_bet.dart';
import '../../mapper/grand_prix_bet_mapper.dart';
import '../repository.dart';
import 'grand_prix_bet_repository.dart';

class GrandPrixBetRepositoryImpl extends Repository<GrandPrixBet>
    implements GrandPrixBetRepository {
  final FirebaseGrandPrixBetService _dbGrandPrixBetService;

  GrandPrixBetRepositoryImpl({super.initialData})
      : _dbGrandPrixBetService = getIt<FirebaseGrandPrixBetService>();

  @override
  Stream<List<GrandPrixBet>?> getAllGrandPrixBets({
    required String userId,
  }) async* {
    if (isRepositoryStateNotInitialized || isRepositoryStateEmpty) {
      await _loadAllGrandPrixBetsFromDb(userId);
    }
    await for (final grandPrixBets in repositoryState$) {
      yield grandPrixBets;
    }
  }

  @override
  Stream<GrandPrixBet?> getGrandPrixBetByGrandPrixId({
    required String userId,
    required String grandPrixId,
  }) async* {
    await for (final grandPrixBets in repositoryState$) {
      GrandPrixBet? grandPrixBet = grandPrixBets?.firstWhereOrNull(
        (GrandPrixBet grandPrixBet) => grandPrixBet.grandPrixId == grandPrixId,
      );
      grandPrixBet ??=
          await _loadGrandPrixBetByGrandPrixIdFromDb(userId, grandPrixId);
      yield grandPrixBet;
    }
  }

  @override
  Future<void> addGrandPrixBets({
    required String userId,
    required List<GrandPrixBet> grandPrixBets,
  }) async {
    for (final grandPrixBet in grandPrixBets) {
      await _dbGrandPrixBetService.addGrandPrixBet(
        userId: userId,
        grandPrixBetDto: mapGrandPrixBetToDto(grandPrixBet),
      );
    }
  }

  @override
  Future<void> updateGrandPrixBet({
    required String userId,
    required String grandPrixBetId,
    List<String?>? qualiStandingsByDriverIds,
    String? p1DriverId,
    String? p2DriverId,
    String? p3DriverId,
    String? p10DriverId,
    String? fastestLapDriverId,
    List<String?>? dnfDriverIds,
    bool? willBeSafetyCar,
    bool? willBeRedFlag,
  }) async {
    final GrandPrixBetDto? updatedBetDto =
        await _dbGrandPrixBetService.updateGrandPrixBet(
      userId: userId,
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
    if (updatedBetDto != null) {
      final GrandPrixBet updatedBet = mapGrandPrixBetFromDto(updatedBetDto);
      updateEntity(updatedBet);
    }
  }

  Future<void> _loadAllGrandPrixBetsFromDb(String userId) async {
    final List<GrandPrixBetDto> grandPrixBetDtos =
        await _dbGrandPrixBetService.loadAllGrandPrixBets(userId: userId);
    final List<GrandPrixBet> grandPrixBets =
        grandPrixBetDtos.map(mapGrandPrixBetFromDto).toList();
    setEntities(grandPrixBets);
  }

  Future<GrandPrixBet?> _loadGrandPrixBetByGrandPrixIdFromDb(
    String userId,
    String grandPrixId,
  ) async {
    final GrandPrixBetDto? betDto =
        await _dbGrandPrixBetService.loadGrandPrixBetByGrandPrixId(
      userId: userId,
      grandPrixId: grandPrixId,
    );
    if (betDto == null) return null;
    final GrandPrixBet bet = mapGrandPrixBetFromDto(betDto);
    addEntity(bet);
    return bet;
  }
}
