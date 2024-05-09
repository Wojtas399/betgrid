import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../data/repository/grand_prix/grand_prix_repository.dart';
import '../data/repository/grand_prix_bet_points/grand_prix_bet_points_repository.dart';
import '../model/grand_prix.dart';

@injectable
class GetGrandPrixesWithPointsUseCase {
  final GrandPrixRepository _grandPrixRepository;
  final GrandPrixBetPointsRepository _grandPrixBetPointsRepository;

  const GetGrandPrixesWithPointsUseCase(
    this._grandPrixRepository,
    this._grandPrixBetPointsRepository,
  );

  Future<List<GrandPrixWithPoints>> call({
    required String playerId,
  }) async {
    final List<GrandPrix>? allGrandPrixes =
        await _grandPrixRepository.getAllGrandPrixes().first;
    allGrandPrixes?.sort(
      (gp1, gp2) => gp1.roundNumber.compareTo(gp2.roundNumber),
    );
    final List<GrandPrixWithPoints> grandPrixesWithPoints = [];
    for (final gp in [...?allGrandPrixes]) {
      final pointsForGp = (await _grandPrixBetPointsRepository
              .getPointsForPlayerByGrandPrixId(
                playerId: playerId,
                grandPrixId: gp.id,
              )
              .first)
          ?.totalPoints;
      grandPrixesWithPoints.add(
        GrandPrixWithPoints(
          grandPrix: gp,
          points: pointsForGp,
        ),
      );
    }
    return grandPrixesWithPoints;
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
