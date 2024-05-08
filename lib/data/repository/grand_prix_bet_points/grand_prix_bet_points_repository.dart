import '../../../model/grand_prix_bet_points.dart';

abstract interface class GrandPrixBetPointsRepository {
  Stream<GrandPrixBetPoints?> getPointsForPlayerByGrandPrixId({
    required String playerId,
    required String grandPrixId,
  });
}
