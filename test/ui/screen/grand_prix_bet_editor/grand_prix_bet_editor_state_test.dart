import 'package:betgrid/model/driver.dart';
import 'package:betgrid/ui/screen/grand_prix_bet_editor/cubit/grand_prix_bet_editor_race_form.dart';
import 'package:betgrid/ui/screen/grand_prix_bet_editor/cubit/grand_prix_bet_editor_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../creator/driver_creator.dart';

void main() {
  test(
    'default state',
    () {
      const expectedDefaultState = GrandPrixBetEditorState(
        status: GrandPrixBetEditorStateStatus.loading,
        allDrivers: null,
      );

      const defaultState = GrandPrixBetEditorState();

      expect(defaultState, expectedDefaultState);
    },
  );

  group(
    'canSelectNextDnfDriver',
    () {
      test(
        'should be false if length of dnfDrivers list is higher than 3',
        () {
          final List<Driver> dnfDrivers = [
            const DriverCreator(id: 'd1').createEntity(),
            const DriverCreator(id: 'd2').createEntity(),
            const DriverCreator(id: 'd3').createEntity(),
            const DriverCreator(id: 'd4').createEntity(),
          ];

          final state = GrandPrixBetEditorState(
            raceForm: GrandPrixBetEditorRaceForm(
              dnfDrivers: dnfDrivers,
            ),
          );

          expect(state.canSelectNextDnfDriver, false);
        },
      );

      test(
        'should be false if length of dnfDrivers list is equal to 3',
        () {
          final List<Driver> dnfDrivers = [
            const DriverCreator(id: 'd1').createEntity(),
            const DriverCreator(id: 'd2').createEntity(),
            const DriverCreator(id: 'd3').createEntity(),
          ];

          final state = GrandPrixBetEditorState(
            raceForm: GrandPrixBetEditorRaceForm(
              dnfDrivers: dnfDrivers,
            ),
          );

          expect(state.canSelectNextDnfDriver, false);
        },
      );

      test(
        'should be true if length of dnfDrivers list is lower than 3',
        () {
          final List<Driver> dnfDrivers = [
            const DriverCreator(id: 'd1').createEntity(),
            const DriverCreator(id: 'd2').createEntity(),
          ];

          final state = GrandPrixBetEditorState(
            raceForm: GrandPrixBetEditorRaceForm(
              dnfDrivers: dnfDrivers,
            ),
          );

          expect(state.canSelectNextDnfDriver, true);
        },
      );
    },
  );

  group(
    'copyWith status',
    () {
      GrandPrixBetEditorState state = const GrandPrixBetEditorState();

      test(
        'should set new value if passed value is not null',
        () {
          const GrandPrixBetEditorStateStatus newValue =
              GrandPrixBetEditorStateStatus.completed;

          state = state.copyWith(status: newValue);

          expect(state.status, newValue);
        },
      );

      test(
        'should not change current value if passed value is not specified',
        () {
          final GrandPrixBetEditorStateStatus currentValue = state.status;

          state = state.copyWith();

          expect(state.status, currentValue);
        },
      );
    },
  );

  group(
    'copyWith allDrivers',
    () {
      GrandPrixBetEditorState state = const GrandPrixBetEditorState();

      test(
        'should set new value if passed value is not null',
        () {
          final List<Driver> newValue = [
            const DriverCreator(id: 'd1').createEntity(),
            const DriverCreator(id: 'd2').createEntity(),
          ];

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

  group(
    'copyWith qualiStandingsByDriverIds',
    () {
      GrandPrixBetEditorState state = const GrandPrixBetEditorState();

      test(
        'should set new value if passed value is not null',
        () {
          final List<String> newValue = ['d2', 'd1', 'd3'];

          state = state.copyWith(qualiStandingsByDriverIds: newValue);

          expect(state.qualiStandingsByDriverIds, newValue);
        },
      );

      test(
        'should not change current value if passed value is not specified',
        () {
          final List<String?> currentValue = state.qualiStandingsByDriverIds;

          state = state.copyWith();

          expect(state.qualiStandingsByDriverIds, currentValue);
        },
      );
    },
  );

  group(
    'copyWith raceForm',
    () {
      GrandPrixBetEditorState state = const GrandPrixBetEditorState();

      test(
        'should set new value if passed value is not null',
        () {
          const GrandPrixBetEditorRaceForm newValue =
              GrandPrixBetEditorRaceForm(
            p10DriverId: 'd1',
            p3DriverId: 'd3',
          );

          state = state.copyWith(raceForm: newValue);

          expect(state.raceForm, newValue);
        },
      );

      test(
        'should not change current value if passed value is not specified',
        () {
          final GrandPrixBetEditorRaceForm currentValue = state.raceForm;

          state = state.copyWith();

          expect(state.raceForm, currentValue);
        },
      );
    },
  );
}
