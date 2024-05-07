import 'package:betgrid/data/repository/grand_prix/grand_prix_repository.dart';
import 'package:betgrid/data/repository/grand_prix_bet_points/grand_prix_bet_points_repository_method_providers.dart';
import 'package:betgrid/model/grand_prix.dart';
import 'package:betgrid/ui/provider/grand_prixes_with_points_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import '../../creator/grand_prix_bet_points_creator.dart';
import '../../creator/grand_prix_creator.dart';
import '../../mock/data/repository/mock_grand_prix_repository.dart';

void main() {
  final grandPrixRepository = MockGrandPrixRepository();
  const String playerId = 'p1';

  ProviderContainer createContainer() {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    return container;
  }

  setUpAll(() {
    GetIt.I.registerLazySingleton<GrandPrixRepository>(
      () => grandPrixRepository,
    );
  });

  test(
    'list of all grand prixes is null, '
    'should return empty array',
    () async {
      grandPrixRepository.mockGetAllGrandPrixes(null);
      final container = createContainer();

      final grandPrixesWithPoints = await container.read(
        grandPrixesWithPointsProvider(
          playerId: playerId,
        ).future,
      );

      expect(grandPrixesWithPoints, []);
    },
  );

  test(
    'list of all grand prixes is empty, '
    'should return empty array',
    () async {
      grandPrixRepository.mockGetAllGrandPrixes([]);
      final container = createContainer();

      final grandPrixesWithPoints = await container.read(
        grandPrixesWithPointsProvider(
          playerId: playerId,
        ).future,
      );

      expect(grandPrixesWithPoints, []);
    },
  );

  test(
    'should sort grand prixes by round number in ascending order and '
    'should load total points for each grand prix',
    () async {
      final List<GrandPrix> allGrandPrixes = [
        createGrandPrix(id: 'gp1', roundNumber: 3),
        createGrandPrix(id: 'gp2', roundNumber: 1),
        createGrandPrix(id: 'gp3', roundNumber: 2),
      ];
      const double gp1TotalPoints = 10.2;
      const double gp2TotalPoints = 6.5;
      const double gp3TotalPoints = 3.0;
      final List<GrandPrixWithPoints> expectedGrandPrixesWithPoints = [
        GrandPrixWithPoints(
          grandPrix: allGrandPrixes[1],
          points: gp2TotalPoints,
        ),
        GrandPrixWithPoints(
          grandPrix: allGrandPrixes.last,
          points: gp3TotalPoints,
        ),
        GrandPrixWithPoints(
          grandPrix: allGrandPrixes.first,
          points: gp1TotalPoints,
        ),
      ];
      grandPrixRepository.mockGetAllGrandPrixes(allGrandPrixes);
      final container = ProviderContainer(
        overrides: [
          grandPrixBetPointsProvider(
            grandPrixId: 'gp1',
            playerId: playerId,
          ).overrideWith(
            (_) => Stream.value(
              createGrandPrixBetPoints(totalPoints: gp1TotalPoints),
            ),
          ),
          grandPrixBetPointsProvider(
            grandPrixId: 'gp2',
            playerId: playerId,
          ).overrideWith(
            (_) => Stream.value(
              createGrandPrixBetPoints(totalPoints: gp2TotalPoints),
            ),
          ),
          grandPrixBetPointsProvider(
            grandPrixId: 'gp3',
            playerId: playerId,
          ).overrideWith(
            (_) => Stream.value(
              createGrandPrixBetPoints(totalPoints: gp3TotalPoints),
            ),
          ),
        ],
      );

      final grandPrixesWithPoints = await container.read(
        grandPrixesWithPointsProvider(playerId: playerId).future,
      );

      expect(grandPrixesWithPoints, expectedGrandPrixesWithPoints);
    },
  );
}
