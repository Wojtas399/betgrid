import 'package:betgrid_shared/firebase/model/grand_prix_bet_dto.dart';
import 'package:betgrid_shared/firebase/service/firebase_grand_prix_bet_service.dart';
import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:mutex/mutex.dart';

import '../../../model/season_grand_prix_bet.dart';
import '../../mapper/season_grand_prix_bet_mapper.dart';
import '../repository.dart';
import 'season_grand_prix_bet_repository.dart';

@LazySingleton(as: SeasonGrandPrixBetRepository)
class SeasonGrandPrixBetRepositoryImpl extends Repository<SeasonGrandPrixBet>
    implements SeasonGrandPrixBetRepository {
  final FirebaseGrandPrixBetService _fireGrandPrixBetService;
  final SeasonGrandPrixBetMapper _seasonGrandPrixBetMapper;
  final _getGrandPrixBetForPlayerAndGrandprixMutex = Mutex();

  SeasonGrandPrixBetRepositoryImpl(
    this._fireGrandPrixBetService,
    this._seasonGrandPrixBetMapper,
  );

  @override
  Stream<SeasonGrandPrixBet?> getSeasonGrandPrixBet({
    required String playerId,
    required int season,
    required String seasonGrandPrixId,
  }) async* {
    bool didRelease = false;
    await _getGrandPrixBetForPlayerAndGrandprixMutex.acquire();
    await for (final seasonGrandPrixBets in repositoryState$) {
      SeasonGrandPrixBet? seasonGrandPrixBet =
          seasonGrandPrixBets.firstWhereOrNull(
        (SeasonGrandPrixBet seasonGrandPrixBet) =>
            seasonGrandPrixBet.playerId == playerId &&
            seasonGrandPrixBet.season == season &&
            seasonGrandPrixBet.seasonGrandPrixId == seasonGrandPrixId,
      );
      seasonGrandPrixBet ??= await _fetchSeasonGrandPrixBetFromDb((
        playerId: playerId,
        season: season,
        seasonGrandPrixId: seasonGrandPrixId,
      ));
      if (_getGrandPrixBetForPlayerAndGrandprixMutex.isLocked && !didRelease) {
        _getGrandPrixBetForPlayerAndGrandprixMutex.release();
        didRelease = true;
      }
      yield seasonGrandPrixBet;
    }
  }

  @override
  Future<void> addSeasonGrandPrixBet({
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
      final SeasonGrandPrixBet addedSeasonGrandPrixBet =
          _seasonGrandPrixBetMapper.mapFromDto(addedGrandPrixBetDto);
      addEntity(addedSeasonGrandPrixBet);
    }
  }

  @override
  Future<void> updateSeasonGrandPrixBet({
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
      final SeasonGrandPrixBet updatedSeasonGrandPrixBet =
          _seasonGrandPrixBetMapper.mapFromDto(updatedGrandPrixBetDto);
      updateEntity(updatedSeasonGrandPrixBet);
    }
  }

  Future<SeasonGrandPrixBet?> _fetchSeasonGrandPrixBetFromDb(
    _SeasonGrandPrixBetFetchData seasonGrandPrixBetData,
  ) async {
    final GrandPrixBetDto? betDto =
        await _fireGrandPrixBetService.fetchGrandPrixBetBySeasonGrandPrixId(
      userId: seasonGrandPrixBetData.playerId,
      season: seasonGrandPrixBetData.season,
      seasonGrandPrixId: seasonGrandPrixBetData.seasonGrandPrixId,
    );
    if (betDto == null) return null;
    final SeasonGrandPrixBet bet = _seasonGrandPrixBetMapper.mapFromDto(betDto);
    addEntity(bet);
    return bet;
  }
}

typedef _SeasonGrandPrixBetFetchData = ({
  String playerId,
  int season,
  String seasonGrandPrixId,
});
