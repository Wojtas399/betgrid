import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

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
  }) async* {
    final Stream<List<GrandPrix>?> allGrandPrixes$ =
        _grandPrixRepository.getAllGrandPrixes();
    await for (final allGrandPrixes in allGrandPrixes$) {
      if (allGrandPrixes == null) {
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
  ) async* {
    final List<GrandPrix> sortedGrandPrixes = [...allGrandPrixes];
    sortedGrandPrixes.sort(
      (gp1, gp2) => gp1.roundNumber.compareTo(gp2.roundNumber),
    );
    final List<GrandPrixWithPoints> grandPrixesWithPoints = [];
    for (final gp in [...sortedGrandPrixes]) {
      final Stream<GrandPrixBetPoints?> gpPoints$ =
          _grandPrixBetPointsRepository.getPointsForPlayerByGrandPrixId(
        playerId: playerId,
        grandPrixId: gp.id,
      );
      await for (final gpPoints in gpPoints$) {
        grandPrixesWithPoints.add(
          GrandPrixWithPoints(
            grandPrix: gp,
            points: gpPoints?.totalPoints,
          ),
        );
      }
    }
    yield grandPrixesWithPoints;
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
