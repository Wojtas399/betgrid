import 'package:betgrid/data/repository/grand_prix_bet_points/grand_prix_bet_points_repository.dart';
import 'package:betgrid/model/grand_prix_bet_points.dart';
import 'package:betgrid/ui/provider/grand_prix_bet_points_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mock/data/repository/mock_grand_prix_bet_points_repository.dart';

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

  tearDown(() {
    reset(grandPrixBetPointsRepository);
  });

  test(
    'should emit grand prix bet points got directly from GrandPrixBetPointsRepository',
    () async {
      const String playerId = 'p1';
      const String grandPrixId = 'gp1';
      const GrandPrixBetPoints grandPrixBetPoints = GrandPrixBetPoints(
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
