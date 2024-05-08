import 'package:betgrid/data/repository/grand_prix_bet/grand_prix_bet_repository.dart';
import 'package:betgrid/model/grand_prix_bet.dart';
import 'package:betgrid/ui/provider/grand_prix_id_provider.dart';
import 'package:betgrid/ui/screen/grand_prix_bet/provider/grand_prix_bet_provider.dart';
import 'package:betgrid/ui/screen/grand_prix_bet/provider/player_id_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import '../../../creator/grand_prix_bet_creator.dart';
import '../../../mock/data/repository/mock_grand_prix_bet_repository.dart';

void main() {
  final grandPrixBetRepository = MockGrandPrixBetRepository();
  const String grandPrixId = 'gp1';
  const String playerId = 'p1';

  ProviderContainer makeProviderContainer({
    String? grandPrixId,
    String? playerId,
    GrandPrixBet? grandPrixBet,
  }) {
    final container = ProviderContainer(
      overrides: [
        grandPrixIdProvider.overrideWithValue(grandPrixId),
        playerIdProvider.overrideWithValue(playerId),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUpAll(() {
    GetIt.I.registerLazySingleton<GrandPrixBetRepository>(
      () => grandPrixBetRepository,
    );
  });

  test(
    'player id is null, '
    'should throw exception',
    () async {
      final container = makeProviderContainer(grandPrixId: 'gp1');

      Object? exception;
      try {
        await container.read(
          grandPrixBetProvider.future,
        );
      } catch (e) {
        exception = e;
      }

      expect(
        exception,
        '[GrandPrixBetProvider] Cannot find grand prix id or player id',
      );
    },
  );

  test(
    'grand prix id is null, '
    'should throw exception',
    () async {
      final container = makeProviderContainer(playerId: 'p1');

      Object? exception;
      try {
        await container.read(
          grandPrixBetProvider.future,
        );
      } catch (e) {
        exception = e;
      }

      expect(
        exception,
        '[GrandPrixBetProvider] Cannot find grand prix id or player id',
      );
    },
  );

  test(
    'should emit grand prix bet got directly from GrandPrixBetRepository',
    () async {
      final GrandPrixBet expectedBet = createGrandPrixBet(
        id: 'gpb1',
        grandPrixId: grandPrixId,
        playerId: playerId,
      );
      grandPrixBetRepository.mockGetBetByGrandPrixIdAndPlayerId(expectedBet);
      final container = makeProviderContainer(
        playerId: playerId,
        grandPrixId: grandPrixId,
      );

      final GrandPrixBet? bet = await container.read(
        grandPrixBetProvider.future,
      );

      expect(bet, expectedBet);
    },
  );
}
