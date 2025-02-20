import 'package:betgrid/ui/screen/season_grand_prix_bet_preview/cubit/season_grand_prix_bet_preview_state.dart';
import 'package:betgrid/ui/screen/season_grand_prix_bet_preview/cubit/season_grand_prix_bet_preview_status_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final service = SeasonGrandPrixBetPreviewStatusService();

  group('selectStatusBasedOnPoints', () {
    test('should return pending status if points are null', () {
      final BetStatus status = service.selectStatusBasedOnPoints(null);

      expect(status, BetStatus.pending);
    });

    test('should return loss status if points are equal to 0', () {
      final BetStatus status = service.selectStatusBasedOnPoints(0);

      expect(status, BetStatus.loss);
    });

    test('should return win status if points are higher than 0', () {
      final BetStatus status = service.selectStatusBasedOnPoints(12);

      expect(status, BetStatus.win);
    });

    test('should throw exception if points are lower than 0', () {
      Object? exception;
      try {
        service.selectStatusBasedOnPoints(-2);
      } catch (e) {
        exception = e;
      }

      expect(
        exception,
        '[SeasonGrandPrixBetPreviewStatusService] Points cannot be negative',
      );
    });
  });
}
