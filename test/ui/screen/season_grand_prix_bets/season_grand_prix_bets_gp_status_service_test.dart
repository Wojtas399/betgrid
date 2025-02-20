import 'package:betgrid/ui/screen/season_grand_prix_bets/cubit/season_grand_prix_bets_gp_status_service.dart';
import 'package:betgrid/ui/screen/season_grand_prix_bets/cubit/season_grand_prix_bets_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const service = SeasonGrandPrixBetsGpStatusService();

  group('defineStatusForGp, ', () {
    test(
      'should return GrandPrixStatusOngoing if now date is equal to gp start '
      'date',
      () {
        final now = DateTime(2025, 2, 1, 14, 30);
        final gpStartDateTime = DateTime(2025, 2, 1, 16, 30);
        final gpEndDateTime = DateTime(2025, 2, 1, 18, 30);

        final status = service.defineStatusForGp(
          gpStartDateTime: gpStartDateTime,
          gpEndDateTime: gpEndDateTime,
          now: now,
        );

        expect(status, const SeasonGrandPrixStatusOngoing());
      },
    );

    test('should return GrandPrixStatusOngoing if now date is equal to gp end '
        'date', () {
      final now = DateTime(2025, 2, 1, 14, 30);
      final gpStartDateTime = DateTime(2025, 2, 1, 16, 30);
      final gpEndDateTime = DateTime(2025, 2, 1, 18, 30);

      final status = service.defineStatusForGp(
        gpStartDateTime: gpStartDateTime,
        gpEndDateTime: gpEndDateTime,
        now: now,
      );

      expect(status, const SeasonGrandPrixStatusOngoing());
    });

    test('should return GrandPrixStatusOngoing if now date is after gp start '
        'date and before gp end date', () {
      final now = DateTime(2025, 2, 2);
      final gpStartDateTime = DateTime(2025, 2, 1);
      final gpEndDateTime = DateTime(2025, 2, 3);

      final status = service.defineStatusForGp(
        gpStartDateTime: gpStartDateTime,
        gpEndDateTime: gpEndDateTime,
        now: now,
      );

      expect(status, const SeasonGrandPrixStatusOngoing());
    });

    test(
      'should return GrandPrixStatusFinished if now date is after gp end date',
      () {
        final now = DateTime(2025, 2, 4);
        final gpStartDateTime = DateTime(2025, 2, 1);
        final gpEndDateTime = DateTime(2025, 2, 3);

        final status = service.defineStatusForGp(
          gpStartDateTime: gpStartDateTime,
          gpEndDateTime: gpEndDateTime,
          now: now,
        );

        expect(status, const SeasonGrandPrixStatusFinished());
      },
    );

    test('should return GrandPrixStatusUpcoming if now date is before gp start '
        'date', () {
      final now = DateTime(2025, 2, 1);
      final gpStartDateTime = DateTime(2025, 2, 3);
      final gpEndDateTime = DateTime(2025, 2, 4);

      final status = service.defineStatusForGp(
        gpStartDateTime: gpStartDateTime,
        gpEndDateTime: gpEndDateTime,
        now: now,
      );

      expect(status, const SeasonGrandPrixStatusUpcoming());
    });
  });
}
