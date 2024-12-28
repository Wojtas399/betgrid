import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../data/repository/grand_prix_basic_info/grand_prix_basic_info_repository.dart';
import '../data/repository/grand_prix_bet_points/grand_prix_bet_points_repository.dart';
import '../data/repository/season_grand_prix/season_grand_prix_repository.dart';
import '../model/grand_prix_basic_info.dart';
import '../model/grand_prix_bet_points.dart';
import '../model/season_grand_prix.dart';

@injectable
class GetGrandPrixesWithPointsUseCase {
  final SeasonGrandPrixRepository _seasonGrandPrixRepository;
  final GrandPrixBasicInfoRepository _grandPrixBasicInfoRepository;
  final GrandPrixBetPointsRepository _grandPrixBetPointsRepository;

  const GetGrandPrixesWithPointsUseCase(
    this._seasonGrandPrixRepository,
    this._grandPrixBasicInfoRepository,
    this._grandPrixBetPointsRepository,
  );

  Stream<List<GrandPrixWithPoints>> call({
    required String playerId,
    required int season,
  }) {
    return _seasonGrandPrixRepository
        .getAllSeasonGrandPrixesFromSeason(season)
        .switchMap(
          (List<SeasonGrandPrix> grandPrixesFromSeason) =>
              grandPrixesFromSeason.isEmpty
                  ? Stream.value([])
                  : _getPointsForEachGrandPrix(playerId, grandPrixesFromSeason),
        );
  }

  Stream<List<GrandPrixWithPoints>> _getPointsForEachGrandPrix(
    String playerId,
    List<SeasonGrandPrix> grandPrixesFromSeason,
  ) {
    final grandPrixesWithPoints$ = grandPrixesFromSeason.map(
      (seasonGrandPrix) => _getPointsForSingleSeasonGrandPrix(
        seasonGrandPrix,
        playerId,
      ),
    );
    return Rx.combineLatest(
      grandPrixesWithPoints$,
      (values) => values.whereType<GrandPrixWithPoints>().toList(),
    );
  }

  Stream<GrandPrixWithPoints?> _getPointsForSingleSeasonGrandPrix(
    SeasonGrandPrix seasonGrandPrix,
    String playerId,
  ) {
    return Rx.combineLatest2(
      _grandPrixBasicInfoRepository.getGrandPrixBasicInfoById(
        seasonGrandPrix.grandPrixId,
      ),
      _grandPrixBetPointsRepository
          .getGrandPrixBetPointsForPlayerAndSeasonGrandPrix(
        playerId: playerId,
        seasonGrandPrixId: seasonGrandPrix.id,
      ),
      (
        GrandPrixBasicInfo? grandPrix,
        GrandPrixBetPoints? grandPrixPoints,
      ) =>
          grandPrix != null
              ? GrandPrixWithPoints(
                  seasonGrandPrixId: seasonGrandPrix.id,
                  name: grandPrix.name,
                  countryAlpha2Code: grandPrix.countryAlpha2Code,
                  roundNumber: seasonGrandPrix.roundNumber,
                  startDate: seasonGrandPrix.startDate,
                  endDate: seasonGrandPrix.endDate,
                  points: grandPrixPoints?.totalPoints,
                )
              : null,
    );
  }
}

class GrandPrixWithPoints extends Equatable {
  final String seasonGrandPrixId;
  final String name;
  final String countryAlpha2Code;
  final int roundNumber;
  final DateTime startDate;
  final DateTime endDate;
  final double? points;

  const GrandPrixWithPoints({
    required this.seasonGrandPrixId,
    required this.name,
    required this.countryAlpha2Code,
    required this.roundNumber,
    required this.startDate,
    required this.endDate,
    this.points,
  });

  @override
  List<Object?> get props => [
        seasonGrandPrixId,
        name,
        countryAlpha2Code,
        roundNumber,
        startDate,
        endDate,
        points,
      ];
}
