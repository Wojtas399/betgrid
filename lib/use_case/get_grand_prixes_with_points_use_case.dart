import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../data/repository/grand_prix_basic_info/grand_prix_basic_info_repository.dart';
import '../data/repository/season_grand_prix_bet_points/season_grand_prix_bet_points_repository.dart';
import '../data/repository/season_grand_prix/season_grand_prix_repository.dart';
import '../model/grand_prix_basic_info.dart';
import '../model/season_grand_prix_bet_points.dart';
import '../model/season_grand_prix.dart';

@injectable
class GetGrandPrixesWithPointsUseCase {
  final SeasonGrandPrixRepository _seasonGrandPrixRepository;
  final GrandPrixBasicInfoRepository _grandPrixBasicInfoRepository;
  final SeasonGrandPrixBetPointsRepository _seasonGrandPrixBetPointsRepository;

  const GetGrandPrixesWithPointsUseCase(
    this._seasonGrandPrixRepository,
    this._grandPrixBasicInfoRepository,
    this._seasonGrandPrixBetPointsRepository,
  );

  Stream<List<GrandPrixWithPoints>> call({
    required String playerId,
    required int season,
  }) {
    return _seasonGrandPrixRepository
        .getAllFromSeason(season)
        .switchMap(
          (List<SeasonGrandPrix> grandPrixesFromSeason) =>
              grandPrixesFromSeason.isEmpty
                  ? Stream.value([])
                  : _getPointsForEachGrandPrix(
                    playerId,
                    season,
                    grandPrixesFromSeason,
                  ),
        );
  }

  Stream<List<GrandPrixWithPoints>> _getPointsForEachGrandPrix(
    String playerId,
    int season,
    List<SeasonGrandPrix> grandPrixesFromSeason,
  ) {
    final grandPrixesWithPoints$ = grandPrixesFromSeason.map(
      (seasonGrandPrix) =>
          _getPointsForSingleSeasonGrandPrix(playerId, season, seasonGrandPrix),
    );
    return Rx.combineLatest(
      grandPrixesWithPoints$,
      (values) => values.whereType<GrandPrixWithPoints>().toList(),
    );
  }

  Stream<GrandPrixWithPoints?> _getPointsForSingleSeasonGrandPrix(
    String playerId,
    int season,
    SeasonGrandPrix seasonGrandPrix,
  ) {
    return Rx.combineLatest2(
      _grandPrixBasicInfoRepository.getGrandPrixBasicInfoById(
        seasonGrandPrix.grandPrixId,
      ),
      _seasonGrandPrixBetPointsRepository.getSeasonGrandPrixBetPoints(
        playerId: playerId,
        season: season,
        seasonGrandPrixId: seasonGrandPrix.id,
      ),
      (
        GrandPrixBasicInfo? grandPrix,
        SeasonGrandPrixBetPoints? seasonGrandPrixBetPoints,
      ) =>
          grandPrix != null
              ? GrandPrixWithPoints(
                seasonGrandPrixId: seasonGrandPrix.id,
                name: grandPrix.name,
                countryAlpha2Code: grandPrix.countryAlpha2Code,
                roundNumber: seasonGrandPrix.roundNumber,
                startDate: seasonGrandPrix.startDate,
                endDate: seasonGrandPrix.endDate,
                points: seasonGrandPrixBetPoints?.totalPoints,
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
