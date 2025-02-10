import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../data/repository/seasongrand_prix_bet_points/season_grand_prix_bet_points_repository.dart';
import '../data/repository/season_grand_prix/season_grand_prix_repository.dart';
import '../model/season_grand_prix_bet_points.dart';
import '../model/season_grand_prix.dart';

@injectable
class GetPlayerPointsUseCase {
  final SeasonGrandPrixRepository _seasonGrandPrixRepository;
  final SeasonGrandPrixBetPointsRepository _seasonGrandPrixBetPointsRepository;

  const GetPlayerPointsUseCase(
    this._seasonGrandPrixRepository,
    this._seasonGrandPrixBetPointsRepository,
  );

  Stream<double?> call({
    required String playerId,
    required int season,
  }) async* {
    final Stream<List<SeasonGrandPrix>> allSeasonGrandPrixes$ =
        _seasonGrandPrixRepository.getAllSeasonGrandPrixesFromSeason(season);
    await for (final allSeasonGrandPrixes in allSeasonGrandPrixes$) {
      if (allSeasonGrandPrixes.isNotEmpty) {
        final idsOfAllSeasonGrandPrixes = allSeasonGrandPrixes.map(
          (seasonGrandPrix) => seasonGrandPrix.id,
        );
        final Stream<double?> totalPoints$ = _calculateTotalPoints(
          playerId,
          season,
          idsOfAllSeasonGrandPrixes,
        );
        await for (final totalPoints in totalPoints$) {
          yield totalPoints;
        }
      } else {
        yield null;
      }
    }
  }

  Stream<double?> _calculateTotalPoints(
    String playerId,
    int season,
    Iterable<String> idsOfAllSeasonGrandPrixes,
  ) {
    final List<Stream<SeasonGrandPrixBetPoints?>>
        betPointsForSeasonGrandPrixes = [];
    for (final seasonGrandPrixId in idsOfAllSeasonGrandPrixes) {
      final Stream<SeasonGrandPrixBetPoints?> gpPoints$ =
          _seasonGrandPrixBetPointsRepository.getSeasonGrandPrixBetPoints(
        playerId: playerId,
        season: season,
        seasonGrandPrixId: seasonGrandPrixId,
      );
      betPointsForSeasonGrandPrixes.add(gpPoints$);
    }
    return Rx.combineLatest(
      betPointsForSeasonGrandPrixes,
      (values) => values
          .map((betPoints) => betPoints?.totalPoints ?? 0)
          .reduce((totalPoints, pointsForGp) => totalPoints + pointsForGp),
    );
  }
}
