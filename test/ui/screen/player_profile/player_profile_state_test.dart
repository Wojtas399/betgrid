import 'package:betgrid/model/player.dart';
import 'package:betgrid/ui/screen/player_profile/cubit/player_profile_state.dart';
import 'package:betgrid/use_case/get_grand_prixes_with_points_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../creator/player_creator.dart';

void main() {
  test(
    'default state',
    () {
      const expectedDefaultState = PlayerProfileState(
        status: PlayerProfileStateStatus.loading,
        player: null,
        totalPoints: null,
        grandPrixesWithPoints: [],
      );

      const defaultState = PlayerProfileState();

      expect(defaultState, expectedDefaultState);
    },
  );

  group(
    'status.isLoading, ',
    () {
      test(
        'should be true if status is set as loading',
        () {
          const state = PlayerProfileState(
            status: PlayerProfileStateStatus.loading,
          );

          expect(state.status.isLoading, true);
        },
      );

      test(
        'should be true if status is set as completed',
        () {
          const state = PlayerProfileState(
            status: PlayerProfileStateStatus.completed,
          );

          expect(state.status.isLoading, false);
        },
      );
    },
  );

  group(
    'copyWith status',
    () {
      PlayerProfileState state = const PlayerProfileState();

      test(
        'should set new value if passed value is not null',
        () {
          const PlayerProfileStateStatus newValue =
              PlayerProfileStateStatus.completed;

          state = state.copyWith(status: newValue);

          expect(state.status, newValue);
        },
      );

      test(
        'should not change current value if passed value is not specified',
        () {
          final PlayerProfileStateStatus currentValue = state.status;

          state = state.copyWith();

          expect(state.status, currentValue);
        },
      );
    },
  );

  group(
    'copyWith player',
    () {
      PlayerProfileState state = const PlayerProfileState();

      test(
        'should set new value if passed value is not null',
        () {
          final Player newValue = const PlayerCreator(id: 'p1').create();

          state = state.copyWith(player: newValue);

          expect(state.player, newValue);
        },
      );

      test(
        'should not change current value if passed value is not specified',
        () {
          final Player? currentValue = state.player;

          state = state.copyWith();

          expect(state.player, currentValue);
        },
      );

      test(
        'should set null if passed value is null',
        () {
          state = state.copyWith(player: null);

          expect(state.player, null);
        },
      );
    },
  );

  group(
    'copyWith totalPoints',
    () {
      PlayerProfileState state = const PlayerProfileState();

      test(
        'should set new value if passed value is not null',
        () {
          const double newValue = 22.2;

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
      PlayerProfileState state = const PlayerProfileState();

      test(
        'should set new value if passed value is not null',
        () {
          const List<GrandPrixWithPoints> newValue = [];

          state = state.copyWith(grandPrixesWithPoints: newValue);

          expect(state.grandPrixesWithPoints, newValue);
        },
      );

      test(
        'should not change current value if passed value is not specified',
        () {
          final List<GrandPrixWithPoints> currentValue =
              state.grandPrixesWithPoints;

          state = state.copyWith();

          expect(state.grandPrixesWithPoints, currentValue);
        },
      );
    },
  );
}
