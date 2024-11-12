import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../data/repository/grand_prix_bet_points/grand_prix_bet_points_repository.dart';
import '../data/repository/season_grand_prix/season_grand_prix_repository.dart';
import '../model/grand_prix_bet_points.dart';
import '../model/grand_prix_v2.dart';
import '../model/season_grand_prix.dart';
import 'get_grand_prix_based_on_season_grand_prix_use_case.dart';

@injectable
class GetGrandPrixesWithPointsUseCase {
  final SeasonGrandPrixRepository _seasonGrandPrixRepository;
  final GrandPrixBetPointsRepository _grandPrixBetPointsRepository;
  final GetGrandPrixBasedOnSeasonGrandPrixUseCase
      _getGrandPrixBasedOnSeasonGrandPrixUseCase;

  const GetGrandPrixesWithPointsUseCase(
    this._seasonGrandPrixRepository,
    this._grandPrixBetPointsRepository,
    this._getGrandPrixBasedOnSeasonGrandPrixUseCase,
  );

  Stream<List<GrandPrixWithPoints>> call({
    required String playerId,
    required int season,
  }) async* {
    final Stream<List<SeasonGrandPrix>> allSeasonGrandPrixes$ =
        _seasonGrandPrixRepository.getAllSeasonGrandPrixesFromSeason(season);
    await for (final allSeasonGrandPrixes in allSeasonGrandPrixes$) {
      if (allSeasonGrandPrixes.isEmpty) {
        yield [];
      } else {
        final Stream<List<GrandPrixWithPoints>> grandPrixesWithPoints$ =
            _getPointsForEachGrandPrix(playerId, allSeasonGrandPrixes);
        await for (final grandPrixesWithPoints in grandPrixesWithPoints$) {
          yield grandPrixesWithPoints;
        }
      }
    }
  }

  Stream<List<GrandPrixWithPoints>> _getPointsForEachGrandPrix(
    String playerId,
    List<SeasonGrandPrix> allSeasonGrandPrixes,
  ) {
    final List<SeasonGrandPrix> sortedSeasonGrandPrixes = [
      ...allSeasonGrandPrixes,
    ];
    sortedSeasonGrandPrixes.sort(
      (gp1, gp2) => gp1.roundNumber.compareTo(gp2.roundNumber),
    );
    final List<Stream<GrandPrixWithPoints?>> grandPrixesWithPoints = [];
    for (final seasonGrandPrix in [...sortedSeasonGrandPrixes]) {
      final Stream<GrandPrixWithPoints?> gpWithPoints$ =
          _getPointsForSingleSeasonGrandPrix(seasonGrandPrix, playerId);
      grandPrixesWithPoints.add(gpWithPoints$);
    }
    return Rx.combineLatest(
      grandPrixesWithPoints,
      (values) => values.whereNotNull().toList(),
    );
  }

  Stream<GrandPrixWithPoints?> _getPointsForSingleSeasonGrandPrix(
    SeasonGrandPrix seasonGrandPrix,
    String playerId,
  ) {
    return Rx.combineLatest2(
      _getGrandPrixBasedOnSeasonGrandPrixUseCase(seasonGrandPrix),
      _grandPrixBetPointsRepository
          .getGrandPrixBetPointsForPlayerAndSeasonGrandPrix(
        playerId: playerId,
        seasonGrandPrixId: seasonGrandPrix.id,
      ),
      (
        GrandPrixV2? grandPrix,
        GrandPrixBetPoints? grandPrixPoints,
      ) =>
          grandPrix != null
              ? GrandPrixWithPoints(
                  grandPrix: grandPrix,
                  points: grandPrixPoints?.totalPoints,
                )
              : null,
    );
  }
}

class GrandPrixWithPoints extends Equatable {
  final GrandPrixV2 grandPrix;
  final double? points;

  const GrandPrixWithPoints({
    required this.grandPrix,
    this.points,
  });

  @override
  List<Object?> get props => [grandPrix, points];
}
