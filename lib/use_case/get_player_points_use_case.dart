import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../data/repository/grand_prix/grand_prix_repository.dart';
import '../data/repository/grand_prix_bet_points/grand_prix_bet_points_repository.dart';
import '../model/grand_prix.dart';
import '../model/grand_prix_bet_points.dart';

@injectable
class GetPlayerPointsUseCase {
  final GrandPrixRepository _grandPrixRepository;
  final GrandPrixBetPointsRepository _grandPrixBetPointsRepository;

  const GetPlayerPointsUseCase(
    this._grandPrixRepository,
    this._grandPrixBetPointsRepository,
  );

  Stream<double?> call({
    required String playerId,
  }) async* {
    final Stream<List<GrandPrix>?> allGrandPrixes$ =
        _grandPrixRepository.getAllGrandPrixes();
    await for (final allGrandPrixes in allGrandPrixes$) {
      if (allGrandPrixes == null) {
        yield null;
      } else {
        final Stream<double?> totalPoints$ =
            _calculateTotalPoints(playerId, allGrandPrixes);
        await for (final totalPoints in totalPoints$) {
          yield totalPoints;
        }
      }
    }
  }

  Stream<double?> _calculateTotalPoints(
    String playerId,
    List<GrandPrix> allGrandPrixes,
  ) {
    final List<Stream<GrandPrixBetPoints?>> betPointsForGrandPrixes = [];
    for (final grandPrix in allGrandPrixes) {
      final Stream<GrandPrixBetPoints?> gpPoints$ =
          _grandPrixBetPointsRepository
              .getGrandPrixBetPointsForPlayerAndGrandPrix(
        playerId: playerId,
        grandPrixId: grandPrix.id,
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
