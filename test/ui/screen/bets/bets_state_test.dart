import 'package:betgrid/ui/screen/bets/cubit/bets_state.dart';
import 'package:betgrid/use_case/get_grand_prixes_with_points_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../creator/grand_prix_creator.dart';

void main() {
  test(
    'default state',
    () {
      const BetsState expectedDefaultState = BetsState(
        status: BetsStateStatus.loading,
        loggedUserId: null,
        totalPoints: null,
        grandPrixesWithPoints: null,
      );

      const BetsState defaultState = BetsState();

      expect(defaultState, expectedDefaultState);
    },
  );

  group(
    'status.isLoading, ',
    () {
      test(
        'should return true if status is set as loading',
        () {
          const state = BetsState(
            status: BetsStateStatus.loading,
          );

          expect(state.status.isLoading, true);
        },
      );

      test(
        'should return false if status is set as completed',
        () {
          const state = BetsState(
            status: BetsStateStatus.completed,
          );

          expect(state.status.isLoading, false);
        },
      );

      test(
        'should return false if status is set as loggedUserDoesNotExist',
        () {
          const state = BetsState(
            status: BetsStateStatus.loggedUserDoesNotExist,
          );

          expect(state.status.isLoading, false);
        },
      );

      test(
        'should return false if status is set as noBets',
        () {
          const state = BetsState(
            status: BetsStateStatus.noBets,
          );

          expect(state.status.isLoading, false);
        },
      );
    },
  );

  group(
    'status.areNoBets, ',
    () {
      test(
        'should return true if status is set as noBets',
        () {
          const state = BetsState(
            status: BetsStateStatus.noBets,
          );

          expect(state.status.areNoBets, true);
        },
      );

      test(
        'should return false if status is set as loading',
        () {
          const state = BetsState(
            status: BetsStateStatus.loading,
          );

          expect(state.status.areNoBets, false);
        },
      );

      test(
        'should return false if status is set as completed',
        () {
          const state = BetsState(
            status: BetsStateStatus.completed,
          );

          expect(state.status.areNoBets, false);
        },
      );

      test(
        'should return false if status is set as loggedUserDoesNotExist',
        () {
          const state = BetsState(
            status: BetsStateStatus.loggedUserDoesNotExist,
          );

          expect(state.status.areNoBets, false);
        },
      );
    },
  );

  group(
    'copyWith status',
    () {
      BetsState state = const BetsState();

      test(
        'should set new value if passed value is not null',
        () {
          const BetsStateStatus newValue = BetsStateStatus.completed;

          state = state.copyWith(status: newValue);

          expect(state.status, newValue);
        },
      );

      test(
        'should not change current value if passed value is not specified',
        () {
          final BetsStateStatus currentValue = state.status;

          state = state.copyWith();

          expect(state.status, currentValue);
        },
      );
    },
  );

  group(
    'copyWith loggedUserId',
    () {
      BetsState state = const BetsState();

      test(
        'should set new value if passed value is not null',
        () {
          const String newValue = 'u1';

          state = state.copyWith(loggedUserId: newValue);

          expect(state.loggedUserId, newValue);
        },
      );

      test(
        'should not change current value if passed value is not specified',
        () {
          final String? currentValue = state.loggedUserId;

          state = state.copyWith();

          expect(state.loggedUserId, currentValue);
        },
      );

      test(
        'should set null if passed value is null',
        () {
          state = state.copyWith(loggedUserId: null);

          expect(state.loggedUserId, null);
        },
      );
    },
  );

  group(
    'copyWith totalPoints',
    () {
      BetsState state = const BetsState();

      test(
        'should set new value if passed value is not null',
        () {
          const double newValue = 11.1;

          state = state.copyWith(totalPoints: newValue);

          expect(state.totalPoints, newValue);
        },
      );

      test(
        'should not change current value if passed value is not specified',
        () {
          final double? currentValue = state.totalPoints;

          state = state.copyWith();

          expect(state.totalPoints, currentValue);
        },
      );

      test(
        'should set null if passed value is null',
        () {
          state = state.copyWith(totalPoints: null);

          expect(state.totalPoints, null);
        },
      );
    },
  );

  group(
    'copyWith grandPrixesWithPoints',
    () {
      BetsState state = const BetsState();

      test(
        'should set new value if passed value is not null',
        () {
          final List<GrandPrixWithPoints> newValue = [
            GrandPrixWithPoints(
              grandPrix: GrandPrixCreator().createEntity(),
            ),
          ];

          state = state.copyWith(grandPrixesWithPoints: newValue);

          expect(state.grandPrixesWithPoints, newValue);
        },
      );

      test(
        'should not change current value if passed value is not specified',
        () {
          final List<GrandPrixWithPoints>? currentValue =
              state.grandPrixesWithPoints;

          state = state.copyWith();

          expect(state.grandPrixesWithPoints, currentValue);
        },
      );

      test(
        'should set null if passed value is null',
        () {
          state = state.copyWith(grandPrixesWithPoints: null);

          expect(state.grandPrixesWithPoints, null);
        },
      );
    },
  );
}
