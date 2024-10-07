import 'package:betgrid/ui/screen/players/cubit/players_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'default state',
    () {
      const expectedDefaultState = PlayersState(
        status: PlayersStateStatus.loading,
        playersWithTheirPoints: null,
      );

      const defaultState = PlayersState();

      expect(defaultState, expectedDefaultState);
    },
  );

  group(
    'status.isLoading',
    () {
      test(
        'should return true if status is set as loading',
        () {
          const state = PlayersState(
            status: PlayersStateStatus.loading,
          );

          expect(state.status.isLoading, true);
        },
      );

      test(
        'should return false if status is set as completed',
        () {
          const state = PlayersState(
            status: PlayersStateStatus.completed,
          );

          expect(state.status.isLoading, false);
        },
      );
    },
  );

  group(
    'copyWith status',
    () {
      PlayersState state = const PlayersState();

      test(
        'should set new value if passed value is not null',
        () {
          const PlayersStateStatus newValue = PlayersStateStatus.completed;

          state = state.copyWith(status: newValue);

          expect(state.status, newValue);
        },
      );

      test(
        'should not change current value if passed value is not specified',
        () {
          final PlayersStateStatus currentValue = state.status;

          state = state.copyWith();

          expect(state.status, currentValue);
        },
      );
    },
  );

  group(
    'copyWith playersWithTheirPoints',
    () {
      PlayersState state = const PlayersState();

      test(
        'should set new value if passed value is not null',
        () {
          const List<PlayerWithPoints> newValue = [];

          state = state.copyWith(playersWithTheirPoints: newValue);

          expect(state.playersWithTheirPoints, newValue);
        },
      );

      test(
        'should not change current value if passed value is not specified',
        () {
          final List<PlayerWithPoints>? currentValue =
              state.playersWithTheirPoints;

          state = state.copyWith();

          expect(state.playersWithTheirPoints, currentValue);
        },
      );

      test(
        'should set null if passed value is null',
        () {
          state = state.copyWith(playersWithTheirPoints: null);

          expect(state.playersWithTheirPoints, null);
        },
      );
    },
  );
}
