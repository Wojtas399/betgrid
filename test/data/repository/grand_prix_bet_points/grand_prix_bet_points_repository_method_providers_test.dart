import 'package:betgrid/data/repository/grand_prix_bet_points/grand_prix_bet_points_repository.dart';
import 'package:betgrid/data/repository/grand_prix_bet_points/grand_prix_bet_points_repository_method_providers.dart';
import 'package:betgrid/model/grand_prix_bet_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/grand_prix_bet_points_creator.dart';
import '../../../mock/data/repository/mock_grand_prix_bet_points_repository.dart';

void main() {
  final grandPrixBetPointsRepository = MockGrandPrixBetPointsRepository();

  ProviderContainer makeProviderContainer() {
    final container = ProviderContainer(
      overrides: [
        grandPrixBetPointsRepositoryProvider.overrideWithValue(
          grandPrixBetPointsRepository,
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test(
    'grandPrixBetPointsProvider, '
    'should get grand prix bet points from GrandPrixBetPointsRepository and '
    'should emit them',
    () async {
      const String playerId = 'p1';
      const String grandPrixId = 'gp1';
      final GrandPrixBetPoints grandPrixBetPoints = createGrandPrixBetPoints(
        id: 'gpbp1',
        playerId: playerId,
        grandPrixId: grandPrixId,
      );
      grandPrixBetPointsRepository.mockGetPointsForPlayerByGrandPrixId(
        grandPrixBetPoints: grandPrixBetPoints,
      );

      final container = makeProviderContainer();

      await expectLater(
        container.read(
          grandPrixBetPointsProvider(
            playerId: playerId,
            grandPrixId: grandPrixId,
          ).future,
        ),
        completion(grandPrixBetPoints),
      );
      verify(
        () => grandPrixBetPointsRepository.getPointsForPlayerByGrandPrixId(
          playerId: playerId,
          grandPrixId: grandPrixId,
        ),
      ).called(1);
    },
  );
}
