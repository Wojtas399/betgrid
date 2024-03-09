import 'package:betgrid/data/repository/grand_prix_bet/grand_prix_bet_repository.dart';
import 'package:betgrid/model/grand_prix_bet.dart';
import 'package:betgrid/ui/provider/grand_prix/grand_prix_id_provider.dart';
import 'package:betgrid/ui/provider/grand_prix_bet_provider.dart';
import 'package:betgrid/ui/provider/player/player_id_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../creator/grand_prix_bet_creator.dart';
import '../../mock/data/repository/mock_grand_prix_bet_repository.dart';
import '../../mock/listener.dart';

void main() {
  final grandPrixBetRepository = MockGrandPrixBetRepository();
  const String grandPrixId = 'gp1';
  const String playerId = 'p1';

  ProviderContainer makeProviderContainer() {
    final container = ProviderContainer(
      overrides: [
        grandPrixIdProvider.overrideWithValue(grandPrixId),
        playerIdProvider.overrideWithValue(playerId),
        grandPrixBetRepositoryProvider.overrideWithValue(
          grandPrixBetRepository,
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  tearDown(() {
    reset(grandPrixBetRepository);
  });

  test(
    'build, '
    'should emit grand prix bet got directly from GrandPrixBetRepository',
    () async {
      final GrandPrixBet grandPrixBet = createGrandPrixBet(
        grandPrixId: grandPrixId,
        qualiStandingsByDriverIds: List.generate(
          20,
          (index) => switch (index) {
            1 => 'd2',
            5 => 'd10',
            11 => 'd15',
            _ => null,
          },
        ),
        p1DriverId: 'd1',
        p2DriverId: 'd2',
        p3DriverId: 'd3',
        p10DriverId: 'd4',
        fastestLapDriverId: 'd1',
        dnfDriverIds: ['d17', 'd18', 'd19'],
        willBeSafetyCar: true,
        willBeRedFlag: false,
      );
      grandPrixBetRepository.mockGetBetByGrandPrixIdAndPlayerId(grandPrixBet);
      final container = makeProviderContainer();
      final listener = Listener<AsyncValue<GrandPrixBet?>>();
      container.listen(
        grandPrixBetProvider,
        listener,
        fireImmediately: true,
      );

      await expectLater(
        container.read(grandPrixBetProvider.future),
        completion(grandPrixBet),
      );
      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<GrandPrixBet?>(),
            ),
        () => listener(
              const AsyncLoading<GrandPrixBet?>(),
              AsyncData(grandPrixBet),
            ),
      ]);
      verifyNoMoreInteractions(listener);
      verify(
        () => grandPrixBetRepository.getBetByGrandPrixIdAndPlayerId(
          playerId: playerId,
          grandPrixId: grandPrixId,
        ),
      ).called(1);
    },
  );
}
