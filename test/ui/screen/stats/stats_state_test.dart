import 'package:betgrid/model/driver_details.dart';
import 'package:betgrid/ui/screen/stats/cubit/stats_state.dart';
import 'package:betgrid/ui/screen/stats/stats_model/players_podium.dart';
import 'package:betgrid/ui/screen/stats/stats_model/points_by_driver.dart';
import 'package:betgrid/ui/screen/stats/stats_model/points_history.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../creator/player_creator.dart';

void main() {
  test(
    'default state',
    () {
      const expectedDefaultState = StatsState(
        status: StatsStateStatus.loading,
        playersPodium: null,
        pointsHistory: null,
        detailsOfDriversFromSeason: null,
        pointsByDriver: null,
      );

      const defaultState = StatsState();

      expect(defaultState, expectedDefaultState);
    },
  );

  group(
    'status.isLoading, ',
    () {
      test(
        'should return true if status is set as loading',
        () {
          const state = StatsState(
            status: StatsStateStatus.loading,
          );

          expect(state.status.isLoading, true);
        },
      );

      test(
        'should return false if status is set as pointsForDriverLoading',
        () {
          const state = StatsState(
            status: StatsStateStatus.pointsForDriverLoading,
          );

          expect(state.status.isLoading, false);
        },
      );

      test(
        'should return false if status is set as noData',
        () {
          const state = StatsState(
            status: StatsStateStatus.noData,
          );

          expect(state.status.isLoading, false);
        },
      );

      test(
        'should return false if status is set as completed',
        () {
          const state = StatsState(
            status: StatsStateStatus.completed,
          );

          expect(state.status.isLoading, false);
        },
      );

      test(
        'should return false if status is set as playersDontExist',
        () {
          const state = StatsState(
            status: StatsStateStatus.playersDontExist,
          );

          expect(state.status.isLoading, false);
        },
      );
    },
  );

  group(
    'status.arePointsForDriverLoading, ',
    () {
      test(
        'should return true if status is set as pointsForDriverLoading',
        () {
          const state = StatsState(
            status: StatsStateStatus.pointsForDriverLoading,
          );

          expect(state.status.arePointsForDriverLoading, true);
        },
      );

      test(
        'should return false if status is set as loading',
        () {
          const state = StatsState(
            status: StatsStateStatus.loading,
          );

          expect(state.status.arePointsForDriverLoading, false);
        },
      );

      test(
        'should return false if status is set as noData',
        () {
          const state = StatsState(
            status: StatsStateStatus.noData,
          );

          expect(state.status.arePointsForDriverLoading, false);
        },
      );

      test(
        'should return false if status is set as completed',
        () {
          const state = StatsState(
            status: StatsStateStatus.completed,
          );

          expect(state.status.arePointsForDriverLoading, false);
        },
      );

      test(
        'should return false if status is set as playersDontExist',
        () {
          const state = StatsState(
            status: StatsStateStatus.playersDontExist,
          );

          expect(state.status.arePointsForDriverLoading, false);
        },
      );
    },
  );

  group(
    'status.isNoData, ',
    () {
      test(
        'should return true if status is set as noData',
        () {
          const state = StatsState(
            status: StatsStateStatus.noData,
          );

          expect(state.status.isNoData, true);
        },
      );

      test(
        'should return false if status is set as loading',
        () {
          const state = StatsState(
            status: StatsStateStatus.loading,
          );

          expect(state.status.isNoData, false);
        },
      );

      test(
        'should return false if status is set as pointsForDriverLoading',
        () {
          const state = StatsState(
            status: StatsStateStatus.pointsForDriverLoading,
          );

          expect(state.status.isNoData, false);
        },
      );

      test(
        'should return false if status is set as completed',
        () {
          const state = StatsState(
            status: StatsStateStatus.completed,
          );

          expect(state.status.isNoData, false);
        },
      );

      test(
        'should return false if status is set as playersDontExist',
        () {
          const state = StatsState(
            status: StatsStateStatus.playersDontExist,
          );

          expect(state.status.isNoData, false);
        },
      );
    },
  );

  group(
    'copyWith status',
    () {
      StatsState state = const StatsState();

      test(
        'should set new value if passed value is not null',
        () {
          const StatsStateStatus newValue = StatsStateStatus.completed;

          state = state.copyWith(status: newValue);

          expect(state.status, newValue);
        },
      );

      test(
        'should not change current value if passed value is not specified',
        () {
          final StatsStateStatus currentValue = state.status;

          state = state.copyWith();

          expect(state.status, currentValue);
        },
      );
    },
  );

  group(
    'copyWith playersPodium',
    () {
      StatsState state = const StatsState();

      test(
        'should set new value if passed value is not null',
        () {
          final PlayersPodium newValue = PlayersPodium(
            p1Player: PlayersPodiumPlayer(
              player: const PlayerCreator(id: 'p1').createEntity(),
              points: 22.2,
            ),
          );

          state = state.copyWith(playersPodium: newValue);

          expect(state.playersPodium, newValue);
        },
      );

      test(
        'should not change current value if passed value is not specified',
        () {
          final PlayersPodium? currentValue = state.playersPodium;

          state = state.copyWith();

          expect(state.playersPodium, currentValue);
        },
      );

      test(
        'should set null if passed value is null',
        () {
          state = state.copyWith(playersPodium: null);

          expect(state.playersPodium, null);
        },
      );
    },
  );

  group(
    'copyWith pointsHistory',
    () {
      StatsState state = const StatsState();

      test(
        'should set new value if passed value is not null',
        () {
          const PointsHistory newValue = PointsHistory(
            players: [],
            grandPrixes: [],
          );

          state = state.copyWith(pointsHistory: newValue);

          expect(state.pointsHistory, newValue);
        },
      );

      test(
        'should not change current value if passed value is not specified',
        () {
          final PointsHistory? currentValue = state.pointsHistory;

          state = state.copyWith();

          expect(state.pointsHistory, currentValue);
        },
      );

      test(
        'should set null if passed value is null',
        () {
          state = state.copyWith(pointsHistory: null);

          expect(state.pointsHistory, null);
        },
      );
    },
  );

  group(
    'copyWith detailsOfDriversFromSeason',
    () {
      StatsState state = const StatsState();

      test(
        'should set new value if passed value is not null',
        () {
          final List<DriverDetails> newValue = [];

          state = state.copyWith(detailsOfDriversFromSeason: newValue);

          expect(state.detailsOfDriversFromSeason, newValue);
        },
      );

      test(
        'should not change current value if passed value is not specified',
        () {
          final List<DriverDetails>? currentValue =
              state.detailsOfDriversFromSeason;

          state = state.copyWith();

          expect(state.detailsOfDriversFromSeason, currentValue);
        },
      );

      test(
        'should set null if passed value is null',
        () {
          state = state.copyWith(detailsOfDriversFromSeason: null);

          expect(state.detailsOfDriversFromSeason, null);
        },
      );
    },
  );

  group(
    'copyWith pointsByDriver',
    () {
      StatsState state = const StatsState();

      test(
        'should set new value if passed value is not null',
        () {
          final List<PointsByDriverPlayerPoints> newValue = [];

          state = state.copyWith(pointsByDriver: newValue);

          expect(state.pointsByDriver, newValue);
        },
      );

      test(
        'should not change current value if passed value is not specified',
        () {
          final List<PointsByDriverPlayerPoints>? currentValue =
              state.pointsByDriver;

          state = state.copyWith();

          expect(state.pointsByDriver, currentValue);
        },
      );

      test(
        'should set null if passed value is null',
        () {
          state = state.copyWith(pointsByDriver: null);

          expect(state.pointsByDriver, null);
        },
      );
    },
  );
}
