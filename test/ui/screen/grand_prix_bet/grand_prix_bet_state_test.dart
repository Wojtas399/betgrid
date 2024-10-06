import 'package:betgrid/model/driver.dart';
import 'package:betgrid/model/grand_prix_bet.dart';
import 'package:betgrid/model/grand_prix_bet_points.dart';
import 'package:betgrid/model/grand_prix_results.dart';
import 'package:betgrid/ui/screen/grand_prix_bet/cubit/grand_prix_bet_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../creator/driver_creator.dart';
import '../../../creator/grand_prix_bet_creator.dart';
import '../../../creator/grand_prix_bet_points_creator.dart';
import '../../../creator/grand_prix_results_creator.dart';

void main() {
  test(
    'default state',
    () {
      const expectedDefaultState = GrandPrixBetState(
        status: GrandPrixBetStateStatus.loading,
        grandPrixName: null,
        playerUsername: null,
        isPlayerIdSameAsLoggedUserId: null,
        grandPrixBet: null,
        grandPrixBetPoints: null,
        allDrivers: null,
      );

      const defaultState = GrandPrixBetState();

      expect(defaultState, expectedDefaultState);
    },
  );

  group(
    'status.isLoading, ',
    () {
      test(
        'should return true if status is set as loading',
        () {
          const state = GrandPrixBetState(
            status: GrandPrixBetStateStatus.loading,
          );

          expect(state.status.isLoading, true);
        },
      );

      test(
        'should be false if status is set as completed',
        () {
          const state = GrandPrixBetState(
            status: GrandPrixBetStateStatus.completed,
          );

          expect(state.status.isLoading, false);
        },
      );

      test(
        'should be false if status is set as loggedUserDoesNotExist',
        () {
          const state = GrandPrixBetState(
            status: GrandPrixBetStateStatus.loggedUserDoesNotExist,
          );

          expect(state.status.isLoading, false);
        },
      );
    },
  );

  group(
    'getDriveById, ',
    () {
      test(
        'should return null if list of all drivers is null',
        () {
          const state = GrandPrixBetState();

          final Driver? driver = state.getDriverById('d1');

          expect(driver, null);
        },
      );

      test(
        'should return null if list of all drivers is empty',
        () {
          const state = GrandPrixBetState(
            allDrivers: [],
          );

          final Driver? driver = state.getDriverById('d1');

          expect(driver, null);
        },
      );

      test(
        'should return null if driver does not exist in the list of all '
        'drivers',
        () {
          final state = GrandPrixBetState(
            allDrivers: [
              const DriverCreator(id: 'd2').createEntity(),
              const DriverCreator(id: 'd3').createEntity(),
              const DriverCreator(id: 'd4').createEntity(),
            ],
          );

          final Driver? driver = state.getDriverById('d1');

          expect(driver, null);
        },
      );

      test(
        'should return matching driver from the list of all drivers',
        () {
          final state = GrandPrixBetState(
            allDrivers: [
              const DriverCreator(id: 'd1').createEntity(),
              const DriverCreator(id: 'd2').createEntity(),
              const DriverCreator(id: 'd3').createEntity(),
              const DriverCreator(id: 'd4').createEntity(),
            ],
          );

          final Driver? driver = state.getDriverById('d1');

          expect(driver, const DriverCreator(id: 'd1').createEntity());
        },
      );
    },
  );

  group(
    'copyWith status',
    () {
      GrandPrixBetState state = const GrandPrixBetState();

      test(
        'should set new value if passed value is not null',
        () {
          const GrandPrixBetStateStatus newValue =
              GrandPrixBetStateStatus.completed;

          state = state.copyWith(status: newValue);

          expect(state.status, newValue);
        },
      );

      test(
        'should not change current value if passed value is not specified',
        () {
          final GrandPrixBetStateStatus currentValue = state.status;

          state = state.copyWith();

          expect(state.status, currentValue);
        },
      );
    },
  );

  group(
    'copyWith grandPrixName',
    () {
      GrandPrixBetState state = const GrandPrixBetState();

      test(
        'should set new value if passed value is not null',
        () {
          const String newValue = 'grand prix';

          state = state.copyWith(grandPrixName: newValue);

          expect(state.grandPrixName, newValue);
        },
      );

      test(
        'should not change current value if passed value is not specified',
        () {
          final String? currentValue = state.grandPrixName;

          state = state.copyWith();

          expect(state.grandPrixName, currentValue);
        },
      );

      test(
        'should set null if passed value is null',
        () {
          state = state.copyWith(grandPrixName: null);

          expect(state.grandPrixName, null);
        },
      );
    },
  );

  group(
    'copyWith playerUsername',
    () {
      GrandPrixBetState state = const GrandPrixBetState();

      test(
        'should set new value if passed value is not null',
        () {
          const String newValue = 'user';

          state = state.copyWith(playerUsername: newValue);

          expect(state.playerUsername, newValue);
        },
      );

      test(
        'should not change current value if passed value is not specified',
        () {
          final String? currentValue = state.playerUsername;

          state = state.copyWith();

          expect(state.playerUsername, currentValue);
        },
      );

      test(
        'should set null if passed value is null',
        () {
          state = state.copyWith(playerUsername: null);

          expect(state.playerUsername, null);
        },
      );
    },
  );

  group(
    'copyWith isPlayerIdSameAsLoggedUserId',
    () {
      GrandPrixBetState state = const GrandPrixBetState();

      test(
        'should set new value if passed value is not null',
        () {
          const bool newValue = true;

          state = state.copyWith(isPlayerIdSameAsLoggedUserId: newValue);

          expect(state.isPlayerIdSameAsLoggedUserId, newValue);
        },
      );

      test(
        'should not change current value if passed value is not specified',
        () {
          final bool? currentValue = state.isPlayerIdSameAsLoggedUserId;

          state = state.copyWith();

          expect(state.isPlayerIdSameAsLoggedUserId, currentValue);
        },
      );

      test(
        'should set null if passed value is null',
        () {
          state = state.copyWith(isPlayerIdSameAsLoggedUserId: null);

          expect(state.isPlayerIdSameAsLoggedUserId, null);
        },
      );
    },
  );

  group(
    'copyWith grandPrixBet',
    () {
      GrandPrixBetState state = const GrandPrixBetState();

      test(
        'should set new value if passed value is not null',
        () {
          final GrandPrixBet newValue =
              GrandPrixBetCreator(id: 'gbp1').createEntity();

          state = state.copyWith(grandPrixBet: newValue);

          expect(state.grandPrixBet, newValue);
        },
      );

      test(
        'should not change current value if passed value is not specified',
        () {
          final GrandPrixBet? currentValue = state.grandPrixBet;

          state = state.copyWith();

          expect(state.grandPrixBet, currentValue);
        },
      );

      test(
        'should set null if passed value is null',
        () {
          state = state.copyWith(grandPrixBet: null);

          expect(state.grandPrixBet, null);
        },
      );
    },
  );

  group(
    'copyWith grandPrixResults',
    () {
      GrandPrixBetState state = const GrandPrixBetState();

      test(
        'should set new value if passed value is not null',
        () {
          final GrandPrixResults newValue =
              const GrandPrixResultsCreator(id: 'gpr1').createEntity();

          state = state.copyWith(grandPrixResults: newValue);

          expect(state.grandPrixResults, newValue);
        },
      );

      test(
        'should not change current value if passed value is not specified',
        () {
          final GrandPrixResults? currentValue = state.grandPrixResults;

          state = state.copyWith();

          expect(state.grandPrixResults, currentValue);
        },
      );

      test(
        'should set null if passed value is null',
        () {
          state = state.copyWith(grandPrixResults: null);

          expect(state.grandPrixResults, null);
        },
      );
    },
  );

  group(
    'copyWith grandPrixBetPoints',
    () {
      GrandPrixBetState state = const GrandPrixBetState();

      test(
        'should set new value if passed value is not null',
        () {
          final GrandPrixBetPoints newValue =
              const GrandPrixBetPointsCreator(id: 'gpbpr 1').createEntity();

          state = state.copyWith(grandPrixBetPoints: newValue);

          expect(state.grandPrixBetPoints, newValue);
        },
      );

      test(
        'should not change current value if passed value is not specified',
        () {
          final GrandPrixBetPoints? currentValue = state.grandPrixBetPoints;

          state = state.copyWith();

          expect(state.grandPrixBetPoints, currentValue);
        },
      );

      test(
        'should set null if passed value is null',
        () {
          state = state.copyWith(grandPrixBetPoints: null);

          expect(state.grandPrixBetPoints, null);
        },
      );
    },
  );

  group(
    'copyWith allDrivers',
    () {
      GrandPrixBetState state = const GrandPrixBetState();

      test(
        'should set new value if passed value is not null',
        () {
          const List<Driver> newValue = [];

          state = state.copyWith(allDrivers: newValue);

          expect(state.allDrivers, newValue);
        },
      );

      test(
        'should not change current value if passed value is not specified',
        () {
          final List<Driver>? currentValue = state.allDrivers;

          state = state.copyWith();

          expect(state.allDrivers, currentValue);
        },
      );

      test(
        'should set null if passed value is null',
        () {
          state = state.copyWith(allDrivers: null);

          expect(state.allDrivers, null);
        },
      );
    },
  );
}
