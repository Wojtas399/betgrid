import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../firebase/service/firebase_grand_prix_bet_points_service.dart';
import '../../../model/grand_prix_bet_points.dart';
import 'grand_prix_bet_points_repository_impl.dart';

part 'grand_prix_bet_points_repository.g.dart';

abstract interface class GrandPrixBetPointsRepository {
  Stream<GrandPrixBetPoints?> getPointsForPlayerByGrandPrixId({
    required String playerId,
    required String grandPrixId,
  });
}

@Riverpod(keepAlive: true)
GrandPrixBetPointsRepository grandPrixBetPointsRepository(
  GrandPrixBetPointsRepositoryRef ref,
) =>
    GrandPrixBetPointsRepositoryImpl(
      firebaseGrandPrixBetPointsService: ref.read(
        firebaseGrandPrixBetPointsServiceProvider,
      ),
    );
