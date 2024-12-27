import 'package:betgrid/ui/screen/bets/cubit/bets_gp_status_service.dart';
import 'package:betgrid/ui/screen/bets/cubit/bets_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../creator/grand_prix_v2_creator.dart';

void main() {
  const service = BetsGpStatusService();

  group(
    'defineStatusForGp, ',
    () {
      test(
        'should return GrandPrixStatusOngoing if now date is equal to gp start '
        'date',
        () {
          final now = DateTime(2025, 2, 1, 14, 30);
          final gp = GrandPrixV2Creator(
            startDate: DateTime(2025, 2, 1, 16, 30),
          ).create();

          final status = service.defineStatusForGp(
            gp: gp,
            now: now,
          );

          expect(status, const GrandPrixStatusOngoing());
        },
      );

      test(
        'should return GrandPrixStatusOngoing if now date is equal to gp end '
        'date',
        () {
          final now = DateTime(2025, 2, 1, 14, 30);
          final gp = GrandPrixV2Creator(
            endDate: DateTime(2025, 2, 1, 11, 30),
          ).create();

          final status = service.defineStatusForGp(
            gp: gp,
            now: now,
          );

          expect(status, const GrandPrixStatusOngoing());
        },
      );

      test(
        'should return GrandPrixStatusOngoing if now date is after gp start '
        'date and before gp end date',
        () {
          final now = DateTime(2025, 2, 2);
          final gp = GrandPrixV2Creator(
            startDate: DateTime(2025, 2, 1),
            endDate: DateTime(2025, 2, 3),
          ).create();

          final status = service.defineStatusForGp(
            gp: gp,
            now: now,
          );

          expect(status, const GrandPrixStatusOngoing());
        },
      );

      test(
        'should return GrandPrixStatusFinished if now date is after gp end date',
        () {
          final now = DateTime(2025, 2, 4);
          final gp = GrandPrixV2Creator(
            startDate: DateTime(2025, 2, 1),
            endDate: DateTime(2025, 2, 3),
          ).create();

          final status = service.defineStatusForGp(
            gp: gp,
            now: now,
          );

          expect(status, const GrandPrixStatusFinished());
        },
      );

      test(
        'should return GrandPrixStatusUpcoming if now date is before gp start '
        'date',
        () {
          final now = DateTime(2025, 2, 1);
          final gp = GrandPrixV2Creator(
            startDate: DateTime(2025, 2, 3),
            endDate: DateTime(2025, 2, 4),
          ).create();

          final status = service.defineStatusForGp(
            gp: gp,
            now: now,
          );

          expect(status, const GrandPrixStatusUpcoming());
        },
      );
    },
  );
}
