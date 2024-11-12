import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../data/repository/grand_prix_bet_points/grand_prix_bet_points_repository.dart';
import '../data/repository/season_grand_prix/season_grand_prix_repository.dart';
import '../model/grand_prix_bet_points.dart';
import '../model/season_grand_prix.dart';

@injectable
class GetPlayerPointsUseCase {
  final SeasonGrandPrixRepository _seasonGrandPrixRepository;
  final GrandPrixBetPointsRepository _grandPrixBetPointsRepository;

  const GetPlayerPointsUseCase(
    this._seasonGrandPrixRepository,
    this._grandPrixBetPointsRepository,
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
    Iterable<String> idsOfAllSeasonGrandPrixes,
  ) {
    final List<Stream<GrandPrixBetPoints?>> betPointsForGrandPrixes = [];
    for (final seasonGrandPrixId in idsOfAllSeasonGrandPrixes) {
      final Stream<GrandPrixBetPoints?> gpPoints$ =
          _grandPrixBetPointsRepository
              .getGrandPrixBetPointsForPlayerAndSeasonGrandPrix(
        playerId: playerId,
        seasonGrandPrixId: seasonGrandPrixId,
      );
      betPointsForGrandPrixes.add(gpPoints$);
    }
    return Rx.combineLatest(
      betPointsForGrandPrixes,
      (values) => values
          .map((betPoints) => betPoints?.totalPoints ?? 0)
          .reduce((totalPoints, pointsForGp) => totalPoints + pointsForGp),
    );
  }
}
