import 'package:betgrid/ui/provider/bet_points/bonus_bet_points_provider.dart';
import 'package:betgrid/ui/provider/bet_points/grand_prix_bet_points_provider.dart';
import 'package:betgrid/ui/provider/bet_points/quali_bet_points_provider.dart';
import 'package:betgrid/ui/provider/bet_points/race_bet_points_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String grandPrixId = 'gp1';
  const String playerId = 'p1';

  ProviderContainer makeProviderContainer({
    required double qualiBetPoints,
    required double raceBetPoints,
    required double bonusBetPoints,
  }) {
    final container = ProviderContainer(
      overrides: [
        qualiBetPointsProvider(
          grandPrixId: grandPrixId,
          playerId: playerId,
        ).overrideWith(
          (ref) {
            ref.state = AsyncData(qualiBetPoints);
            return const Stream.empty();
          },
        ),
        raceBetPointsProvider(
          grandPrixId: grandPrixId,
          playerId: playerId,
        ).overrideWith(
          (ref) {
            ref.state = AsyncData(raceBetPoints);
            return const Stream.empty();
          },
        ),
        bonusBetPointsProvider(
          grandPrixId: grandPrixId,
          playerId: playerId,
        ).overrideWith(
          (ref) {
            ref.state = AsyncData(bonusBetPoints);
            return const Stream.empty();
          },
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test(
    'should sum points of quali, race and bonus bets',
    () async {
      const double qualiBetPoints = 20.0;
      const double raceBetPoints = 11.4;
      const double bonusBetPoints = 5.0;
      const double expectedPoints =
          qualiBetPoints + raceBetPoints + bonusBetPoints;
      final container = makeProviderContainer(
        qualiBetPoints: qualiBetPoints,
        raceBetPoints: raceBetPoints,
        bonusBetPoints: bonusBetPoints,
      );

      expect(
        container.read(
          grandPrixBetPointsProvider(
            grandPrixId: grandPrixId,
            playerId: playerId,
          ),
        ),
        expectedPoints,
      );
    },
  );
}
