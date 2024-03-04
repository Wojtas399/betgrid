import 'package:betgrid/ui/provider/bonus_bet_points_provider.dart';
import 'package:betgrid/ui/provider/grand_prix_bet_points_provider.dart';
import 'package:betgrid/ui/provider/qualifications_bet_points_provider.dart';
import 'package:betgrid/ui/provider/race_bet_points_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  ProviderContainer makeProviderContainer({
    required double qualiBetPoints,
    required double raceBetPoints,
    required double bonusBetPoints,
  }) {
    final container = ProviderContainer(
      overrides: [
        qualificationsBetPointsProvider.overrideWith(
          (ref) {
            ref.state = AsyncData(qualiBetPoints);
            return const Stream.empty();
          },
        ),
        raceBetPointsProvider.overrideWith(
          (ref) {
            ref.state = AsyncData(raceBetPoints);
            return const Stream.empty();
          },
        ),
        bonusBetPointsProvider.overrideWith(
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
        container.read(grandPrixBetPointsProvider),
        expectedPoints,
      );
    },
  );
}
