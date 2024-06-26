import 'package:betgrid/model/grand_prix.dart';
import 'package:betgrid/use_case/get_player_points_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../creator/grand_prix_bet_points_creator.dart';
import '../creator/grand_prix_creator.dart';
import '../mock/data/repository/mock_grand_prix_bet_points_repository.dart';
import '../mock/data/repository/mock_grand_prix_repository.dart';

void main() {
  final grandPrixRepository = MockGrandPrixRepository();
  final grandPrixBetPointsRepository = MockGrandPrixBetPointsRepository();
  const String playerId = 'p1';
  late GetPlayerPointsUseCase useCase;

  setUp(() {
    useCase = GetPlayerPointsUseCase(
      grandPrixRepository,
      grandPrixBetPointsRepository,
    );
  });

  tearDown(() {
    reset(grandPrixRepository);
    reset(grandPrixBetPointsRepository);
  });

  test(
    'list of all grand prixes does not exist, '
    'should return null',
    () {
      grandPrixRepository.mockGetAllGrandPrixes(null);

      final Stream<double?> playerPoints$ = useCase(playerId: playerId);

      expect(playerPoints$, emits(null));
    },
  );

  test(
    'should sum points of each grand prix',
    () async {
      const double gp1Points = 10.0;
      const double gp2Points = 7.5;
      const double gp3Points = 12.25;
      const double expectedPoints = gp1Points + gp2Points + gp3Points;
      final List<GrandPrix> grandPrixes = [
        createGrandPrix(id: 'gp1'),
        createGrandPrix(id: 'gp2'),
        createGrandPrix(id: 'gp3'),
      ];
      grandPrixRepository.mockGetAllGrandPrixes(grandPrixes);
      when(
        () => grandPrixBetPointsRepository
            .getGrandPrixBetPointsForPlayerAndGrandPrix(
          playerId: playerId,
          grandPrixId: grandPrixes.first.id,
        ),
      ).thenAnswer(
        (_) => Stream.value(
          createGrandPrixBetPoints(totalPoints: gp1Points),
        ),
      );
      when(
        () => grandPrixBetPointsRepository
            .getGrandPrixBetPointsForPlayerAndGrandPrix(
          playerId: playerId,
          grandPrixId: grandPrixes[1].id,
        ),
      ).thenAnswer(
        (_) => Stream.value(
          createGrandPrixBetPoints(totalPoints: gp2Points),
        ),
      );
      when(
        () => grandPrixBetPointsRepository
            .getGrandPrixBetPointsForPlayerAndGrandPrix(
          playerId: playerId,
          grandPrixId: grandPrixes.last.id,
        ),
      ).thenAnswer(
        (_) => Stream.value(
          createGrandPrixBetPoints(totalPoints: gp3Points),
        ),
      );

      final Stream<double?> playerPoints$ = useCase(playerId: playerId);

      expect(playerPoints$, emits(expectedPoints));
    },
  );
}
