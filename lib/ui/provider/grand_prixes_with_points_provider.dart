import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/grand_prix/grand_prix_repository_method_providers.dart';
import '../../data/repository/grand_prix_bet_points/grand_prix_bet_points_repository_method_providers.dart';
import '../../model/grand_prix.dart';

part 'grand_prixes_with_points_provider.g.dart';

@riverpod
Future<List<GrandPrixWithPoints>> grandPrixesWithPoints(
  GrandPrixesWithPointsRef ref, {
  required String playerId,
}) async {
  final allGrandPrixes = await ref.watch(allGrandPrixesProvider.future);
  allGrandPrixes?.sort((gp1, gp2) => gp1.startDate.compareTo(gp2.startDate));
  final List<GrandPrixWithPoints> grandPrixesWithPoints = [];
  for (final gp in [...?allGrandPrixes]) {
    final pointsForGp = await ref.watch(grandPrixBetPointsProvider(
      grandPrixId: gp.id,
      playerId: playerId,
    ).selectAsync((data) => data?.totalPoints));
    grandPrixesWithPoints.add(
      GrandPrixWithPoints(
        grandPrix: gp,
        points: pointsForGp,
      ),
    );
  }
  return grandPrixesWithPoints;
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
