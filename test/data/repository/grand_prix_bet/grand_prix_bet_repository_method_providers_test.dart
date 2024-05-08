import 'package:betgrid/data/repository/grand_prix_bet/grand_prix_bet_repository.dart';
import 'package:betgrid/data/repository/grand_prix_bet/grand_prix_bet_repository_method_providers.dart';
import 'package:betgrid/model/grand_prix_bet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../creator/grand_prix_bet_creator.dart';
import '../../../mock/data/repository/mock_grand_prix_bet_repository.dart';

void main() {
  final grandPrixBetRepository = MockGrandPrixBetRepository();

  ProviderContainer makeProviderContainer() {
    final container = ProviderContainer(
      overrides: [
        grandPrixBetRepositoryProvider
            .overrideWithValue(grandPrixBetRepository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test(
    'grandPrixBetByPlayerIdAndGrandPrixIdProvider, '
    'should get matching grand prix bet from GrandPrixBetRepository and should '
    'emit it',
    () async {
      const String playerId = 'p1';
      const String grandPrixId = 'gp1';
      final GrandPrixBet expectedGrandPrixBet = createGrandPrixBet(
        id: 'gpb1',
        playerId: playerId,
        grandPrixId: grandPrixId,
      );
      grandPrixBetRepository.mockGetBetByGrandPrixIdAndPlayerId(
        expectedGrandPrixBet,
      );
      final container = makeProviderContainer();

      final GrandPrixBet? grandPrixBet = await container.read(
        grandPrixBetByPlayerIdAndGrandPrixIdProvider(
          playerId: playerId,
          grandPrixId: grandPrixId,
        ).future,
      );

      expect(grandPrixBet, expectedGrandPrixBet);
    },
  );
}
