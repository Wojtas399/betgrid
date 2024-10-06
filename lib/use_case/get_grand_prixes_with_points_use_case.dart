import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../data/repository/grand_prix/grand_prix_repository.dart';
import '../data/repository/grand_prix_bet_points/grand_prix_bet_points_repository.dart';
import '../model/grand_prix.dart';
import '../model/grand_prix_bet_points.dart';

@injectable
class GetGrandPrixesWithPointsUseCase {
  final GrandPrixRepository _grandPrixRepository;
  final GrandPrixBetPointsRepository _grandPrixBetPointsRepository;

  const GetGrandPrixesWithPointsUseCase(
    this._grandPrixRepository,
    this._grandPrixBetPointsRepository,
  );

  Stream<List<GrandPrixWithPoints>> call({
    required String playerId,
    required int season,
  }) async* {
    final Stream<List<GrandPrix>?> allGrandPrixes$ =
        _grandPrixRepository.getAllGrandPrixesFromSeason(season);
    await for (final allGrandPrixes in allGrandPrixes$) {
      if (allGrandPrixes == null || allGrandPrixes.isEmpty) {
        yield [];
      } else {
        final Stream<List<GrandPrixWithPoints>> grandPrixesWithPoints$ =
            _getPointsForEachGrandPrix(playerId, allGrandPrixes);
        await for (final grandPrixesWithPoints in grandPrixesWithPoints$) {
          yield grandPrixesWithPoints;
        }
      }
    }
  }

  Stream<List<GrandPrixWithPoints>> _getPointsForEachGrandPrix(
    String playerId,
    List<GrandPrix> allGrandPrixes,
  ) {
    final List<GrandPrix> sortedGrandPrixes = [...allGrandPrixes];
    sortedGrandPrixes.sort(
      (gp1, gp2) => gp1.roundNumber.compareTo(gp2.roundNumber),
    );
    final List<Stream<GrandPrixWithPoints>> grandPrixesWithPoints = [];
    for (final gp in [...sortedGrandPrixes]) {
      final Stream<GrandPrixWithPoints> gpWithPoints$ = Rx.combineLatest2(
        Stream.value(gp),
        _grandPrixBetPointsRepository
            .getGrandPrixBetPointsForPlayerAndGrandPrix(
          playerId: playerId,
          grandPrixId: gp.id,
        ),
        (
          GrandPrix grandPrix,
          GrandPrixBetPoints? grandPrixPoints,
        ) =>
            GrandPrixWithPoints(
          grandPrix: grandPrix,
          points: grandPrixPoints?.totalPoints,
        ),
      );
      grandPrixesWithPoints.add(gpWithPoints$);
    }
    return Rx.combineLatest(grandPrixesWithPoints, (values) => values);
  }
}

class GrandPrixWithPoints extends Equatable {
  final GrandPrix grandPrix;
  final double? points;

  const GrandPrixWithPoints({
    required this.grandPrix,
    this.points,
  });

  @override
  List<Object?> get props => [grandPrix, points];
}
