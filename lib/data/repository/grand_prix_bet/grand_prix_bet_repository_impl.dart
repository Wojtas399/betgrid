import 'package:betgrid_shared/firebase/model/grand_prix_bet_dto.dart';
import 'package:betgrid_shared/firebase/service/firebase_grand_prix_bet_service.dart';
import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:mutex/mutex.dart';

import '../../../model/grand_prix_bet.dart';
import '../../mapper/grand_prix_bet_mapper.dart';
import '../repository.dart';
import 'grand_prix_bet_repository.dart';

@LazySingleton(as: GrandPrixBetRepository)
class GrandPrixBetRepositoryImpl extends Repository<GrandPrixBet>
    implements GrandPrixBetRepository {
  final FirebaseGrandPrixBetService _fireGrandPrixBetService;
  final GrandPrixBetMapper _grandPrixBetMapper;
  final _getGrandPrixBetForPlayerAndGrandprixMutex = Mutex();

  GrandPrixBetRepositoryImpl(
    this._fireGrandPrixBetService,
    this._grandPrixBetMapper,
  );

  @override
  Stream<GrandPrixBet?> getGrandPrixBet({
    required String playerId,
    required int season,
    required String seasonGrandPrixId,
  }) async* {
    bool didRelease = false;
    await _getGrandPrixBetForPlayerAndGrandprixMutex.acquire();
    await for (final grandPrixBets in repositoryState$) {
      GrandPrixBet? grandPrixBet = grandPrixBets.firstWhereOrNull(
        (GrandPrixBet grandPrixBet) =>
            grandPrixBet.playerId == playerId &&
            grandPrixBet.season == season &&
            grandPrixBet.seasonGrandPrixId == seasonGrandPrixId,
      );
      grandPrixBet ??= await _fetchGrandPrixBetFromDb((
        playerId: playerId,
        season: season,
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
    required int season,
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
        await _fireGrandPrixBetService.addGrandPrixBet(
      userId: playerId,
      season: season,
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
    required int season,
    required String seasonGrandPrixId,
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
        await _fireGrandPrixBetService.updateGrandPrixBet(
      userId: playerId,
      season: season,
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
    if (updatedGrandPrixBetDto != null) {
      final GrandPrixBet updatedGrandPrixBet =
          _grandPrixBetMapper.mapFromDto(updatedGrandPrixBetDto);
      updateEntity(updatedGrandPrixBet);
    }
  }

  Future<GrandPrixBet?> _fetchGrandPrixBetFromDb(
    _GrandPrixBetFetchData gpBetData,
  ) async {
    final GrandPrixBetDto? betDto =
        await _fireGrandPrixBetService.fetchGrandPrixBetBySeasonGrandPrixId(
      userId: gpBetData.playerId,
      season: gpBetData.season,
      seasonGrandPrixId: gpBetData.seasonGrandPrixId,
    );
    if (betDto == null) return null;
    final GrandPrixBet bet = _grandPrixBetMapper.mapFromDto(betDto);
    addEntity(bet);
    return bet;
  }
}

typedef _GrandPrixBetFetchData = ({
  String playerId,
  int season,
  String seasonGrandPrixId,
});
