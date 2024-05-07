import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/grand_prix/grand_prix_repository.dart';
import '../../data/repository/grand_prix_bet_points/grand_prix_bet_points_repository_method_providers.dart';
import '../../dependency_injection.dart';

part 'player_points_provider.g.dart';

@riverpod
Future<double?> playerPoints(
  PlayerPointsRef ref, {
  required String playerId,
}) async {
  final allGrandPrixes =
      await getIt.get<GrandPrixRepository>().getAllGrandPrixes().first;
  if (allGrandPrixes == null) return null;
  double points = 0.0;
  for (final grandPrix in allGrandPrixes) {
    final grandPrixPoints = await ref.watch(
      grandPrixBetPointsProvider(
        grandPrixId: grandPrix.id,
        playerId: playerId,
      ).selectAsync((state) => state?.totalPoints),
    );
    points += grandPrixPoints ?? 0;
  }
  return points;
}
