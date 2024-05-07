import 'package:betgrid/data/repository/grand_prix/grand_prix_repository.dart';
import 'package:betgrid/data/repository/grand_prix_bet_points/grand_prix_bet_points_repository_method_providers.dart';
import 'package:betgrid/model/grand_prix.dart';
import 'package:betgrid/model/grand_prix_bet_points.dart';
import 'package:betgrid/ui/provider/player_points_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import '../../creator/grand_prix_bet_points_creator.dart';
import '../../creator/grand_prix_creator.dart';
import '../../mock/data/repository/mock_grand_prix_repository.dart';

void main() {
  final grandPrixRepository = MockGrandPrixRepository();
  const String playerId = 'p1';

  setUpAll(() {
    GetIt.I.registerLazySingleton<GrandPrixRepository>(
      () => grandPrixRepository,
    );
  });

  test(
    'list of all grand prixes does not exist, '
    'should return null',
    () async {
      grandPrixRepository.mockGetAllGrandPrixes(null);
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final double? playerPoints = await container.read(
        playerPointsProvider(playerId: playerId).future,
      );

      expect(playerPoints, null);
    },
  );

  test(
    'should sum points of each grand prix',
    () async {
      const double gp1Points = 10.0;
      const double gp2Points = 7.5;
      const double gp3Points = 12.25;
      final List<GrandPrix> grandPrixes = [
        createGrandPrix(id: 'gp1'),
        createGrandPrix(id: 'gp2'),
        createGrandPrix(id: 'gp3'),
      ];
      grandPrixRepository.mockGetAllGrandPrixes(grandPrixes);
      final container = ProviderContainer(
        overrides: [
          grandPrixBetPointsProvider(
            playerId: playerId,
            grandPrixId: grandPrixes.first.id,
          ).overrideWith(
            (ref) {
              ref.state = AsyncData<GrandPrixBetPoints?>(
                createGrandPrixBetPoints(totalPoints: gp1Points),
              );
              return const Stream.empty();
            },
          ),
          grandPrixBetPointsProvider(
            playerId: playerId,
            grandPrixId: grandPrixes[1].id,
          ).overrideWith(
            (ref) {
              ref.state = AsyncData<GrandPrixBetPoints?>(
                createGrandPrixBetPoints(totalPoints: gp2Points),
              );
              return const Stream.empty();
            },
          ),
          grandPrixBetPointsProvider(
            playerId: playerId,
            grandPrixId: grandPrixes.last.id,
          ).overrideWith(
            (ref) {
              ref.state = AsyncData<GrandPrixBetPoints?>(
                createGrandPrixBetPoints(totalPoints: gp3Points),
              );
              return const Stream.empty();
            },
          ),
        ],
      );
      addTearDown(container.dispose);

      final double? playerPoints = await container.read(
        playerPointsProvider(playerId: playerId).future,
      );

      expect(playerPoints, gp1Points + gp2Points + gp3Points);
    },
  );
}
