import 'package:betgrid/data/repository/grand_prix/grand_prix_repository.dart';
import 'package:betgrid/data/repository/grand_prix_bet_points/grand_prix_bet_points_repository.dart';
import 'package:betgrid/model/grand_prix.dart';
import 'package:betgrid/ui/provider/player_points_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../../creator/grand_prix_bet_points_creator.dart';
import '../../creator/grand_prix_creator.dart';
import '../../mock/data/repository/mock_grand_prix_bet_points_repository.dart';
import '../../mock/data/repository/mock_grand_prix_repository.dart';

void main() {
  final grandPrixRepository = MockGrandPrixRepository();
  final grandPrixBetPointsRepository = MockGrandPrixBetPointsRepository();
  const String playerId = 'p1';

  setUpAll(() {
    GetIt.I.registerLazySingleton<GrandPrixRepository>(
      () => grandPrixRepository,
    );
    GetIt.I.registerLazySingleton<GrandPrixBetPointsRepository>(
      () => grandPrixBetPointsRepository,
    );
  });

  test(
    'list of all grand prixes does not exist, '
    'should return null',
    () async {
      grandPrixRepository.mockGetAllGrandPrixes(null);
      final container = ProviderContainer();

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
      when(
        () => grandPrixBetPointsRepository.getPointsForPlayerByGrandPrixId(
          playerId: playerId,
          grandPrixId: grandPrixes.first.id,
        ),
      ).thenAnswer(
        (_) => Stream.value(
          createGrandPrixBetPoints(totalPoints: gp1Points),
        ),
      );
      when(
        () => grandPrixBetPointsRepository.getPointsForPlayerByGrandPrixId(
          playerId: playerId,
          grandPrixId: grandPrixes[1].id,
        ),
      ).thenAnswer(
        (_) => Stream.value(
          createGrandPrixBetPoints(totalPoints: gp2Points),
        ),
      );
      when(
        () => grandPrixBetPointsRepository.getPointsForPlayerByGrandPrixId(
          playerId: playerId,
          grandPrixId: grandPrixes.last.id,
        ),
      ).thenAnswer(
        (_) => Stream.value(
          createGrandPrixBetPoints(totalPoints: gp3Points),
        ),
      );
      final container = ProviderContainer();

      final double? playerPoints = await container.read(
        playerPointsProvider(playerId: playerId).future,
      );

      expect(playerPoints, gp1Points + gp2Points + gp3Points);
    },
  );
}
