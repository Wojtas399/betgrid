import 'package:betgrid/model/driver.dart';
import 'package:betgrid/ui/screen/grand_prix_bet_editor/cubit/grand_prix_bet_editor_race_form.dart';
import 'package:betgrid/ui/screen/grand_prix_bet_editor/cubit/grand_prix_bet_editor_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../creator/driver_creator.dart';
import '../../../creator/grand_prix_bet_creator.dart';

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
    'canSave',
    () {
      test(
        'should be true if originalGrandPrixBet is null and '
        'qualiStandingsByDriverIds contains at least 1 not null value',
        () {
          final state = GrandPrixBetEditorState(
            qualiStandingsByDriverIds: List.generate(
              20,
              (int itemIndex) => itemIndex == 1 ? 'd2' : null,
            ),
          );

          expect(state.canSave, true);
        },
      );

      test(
        'should be true if qualiStandingsByDriverIds of originalGrandPrixBet '
        'differ from qualiStandingsByDriverIds of state',
        () {
          final state = GrandPrixBetEditorState(
            originalGrandPrixBet: GrandPrixBetCreator(
              qualiStandingsByDriverIds: List.generate(
                20,
                (int itemIndex) => itemIndex == 2 ? 'd2' : null,
              ),
            ).createEntity(),
            qualiStandingsByDriverIds: List.generate(
              20,
              (int itemIndex) => itemIndex == 1 ? 'd2' : null,
            ),
          );

          expect(state.canSave, true);
        },
      );

      test(
        'should be true if p1DriverId of originalGrandPrixBet differ from '
        'p1DriverId of raceForm',
        () {
          final state = GrandPrixBetEditorState(
            originalGrandPrixBet: GrandPrixBetCreator(
              p1DriverId: 'd1',
            ).createEntity(),
            raceForm: const GrandPrixBetEditorRaceForm(
              p1DriverId: 'd2',
            ),
          );

          expect(state.canSave, true);
        },
      );

      test(
        'should be true if p2DriverId of originalGrandPrixBet differ from '
        'p2DriverId of raceForm',
        () {
          final state = GrandPrixBetEditorState(
            originalGrandPrixBet: GrandPrixBetCreator(
              p2DriverId: 'd1',
            ).createEntity(),
            raceForm: const GrandPrixBetEditorRaceForm(
              p2DriverId: 'd2',
            ),
          );

          expect(state.canSave, true);
        },
      );

      test(
        'should be true if p3DriverId of originalGrandPrixBet differ from '
        'p3DriverId of raceForm',
        () {
          final state = GrandPrixBetEditorState(
            originalGrandPrixBet: GrandPrixBetCreator(
              p3DriverId: 'd1',
            ).createEntity(),
            raceForm: const GrandPrixBetEditorRaceForm(
              p3DriverId: 'd2',
            ),
          );

          expect(state.canSave, true);
        },
      );

      test(
        'should be true if p10DriverId of originalGrandPrixBet differ from '
        'p10DriverId of raceForm',
        () {
          final state = GrandPrixBetEditorState(
            originalGrandPrixBet: GrandPrixBetCreator(
              p10DriverId: 'd1',
            ).createEntity(),
            raceForm: const GrandPrixBetEditorRaceForm(
              p10DriverId: 'd2',
            ),
          );

          expect(state.canSave, true);
        },
      );

      test(
        'should be true if fastestLapDriverId of originalGrandPrixBet differ '
        'from fastestLapDriverId of raceForm',
        () {
          final state = GrandPrixBetEditorState(
            originalGrandPrixBet: GrandPrixBetCreator(
              fastestLapDriverId: 'd1',
            ).createEntity(),
            raceForm: const GrandPrixBetEditorRaceForm(
              fastestLapDriverId: 'd2',
            ),
          );

          expect(state.canSave, true);
        },
      );

      test(
        'should be true if dnfDriverIds of originalGrandPrix differ from '
        'ids of dnfDrivers of raceForm (different length)',
        () {
          final state = GrandPrixBetEditorState(
            originalGrandPrixBet: GrandPrixBetCreator(
              dnfDriverIds: ['d1', 'd2', null],
            ).createEntity(),
            raceForm: GrandPrixBetEditorRaceForm(
              dnfDrivers: [
                const DriverCreator(id: 'd1').createEntity(),
              ],
            ),
          );

          expect(state.canSave, true);
        },
      );

      test(
        'should be true if dnfDriverIds of originalGrandPrix differ from '
        'ids of dnfDrivers of raceForm (different drivers)',
        () {
          final state = GrandPrixBetEditorState(
            originalGrandPrixBet: GrandPrixBetCreator(
              dnfDriverIds: ['d1', 'd2', null],
            ).createEntity(),
            raceForm: GrandPrixBetEditorRaceForm(
              dnfDrivers: [
                const DriverCreator(id: 'd1').createEntity(),
                const DriverCreator(id: 'd3').createEntity(),
              ],
            ),
          );

          expect(state.canSave, true);
        },
      );

      test(
        'should be true if willBeSafetyCar of originalGrandPrixBet differ from '
        'willBeSafetyCar of raceForm',
        () {
          final state = GrandPrixBetEditorState(
            originalGrandPrixBet: GrandPrixBetCreator(
              willBeSafetyCar: true,
            ).createEntity(),
            raceForm: const GrandPrixBetEditorRaceForm(
              willBeSafetyCar: false,
            ),
          );

          expect(state.canSave, true);
        },
      );

      test(
        'should be true if willBeRedFlag of originalGrandPrixBet differ from '
        'willBeRedFlag of raceForm',
        () {
          final state = GrandPrixBetEditorState(
            originalGrandPrixBet: GrandPrixBetCreator(
              willBeRedFlag: true,
            ).createEntity(),
            raceForm: const GrandPrixBetEditorRaceForm(
              willBeRedFlag: false,
            ),
          );

          expect(state.canSave, true);
        },
      );

      test(
        'should be false if originalGrandPrixBet is null and '
        'qualiStandingsByDriverIds of state has only null values',
        () {
          final state = GrandPrixBetEditorState(
            originalGrandPrixBet: null,
            qualiStandingsByDriverIds: List.generate(20, (_) => null),
          );

          expect(state.canSave, false);
        },
      );

      test(
        'should be false if qualiStandingsByDriverIds of originalGrandPrixBet '
        'is equal to qualiStandingsByDriverIds of state',
        () {
          final state = GrandPrixBetEditorState(
            originalGrandPrixBet: GrandPrixBetCreator(
              qualiStandingsByDriverIds: List.generate(
                20,
                (int itemIndex) => switch (itemIndex) {
                  1 => 'd1',
                  10 => 'd10',
                  _ => null,
                },
              ),
            ).createEntity(),
            qualiStandingsByDriverIds: List.generate(
              20,
              (int itemIndex) => switch (itemIndex) {
                1 => 'd1',
                10 => 'd10',
                _ => null,
              },
            ),
          );

          expect(state.canSave, false);
        },
      );

      test(
        'should be false if ids of dnfDrivers are the same as dnfDriverIds'
        '(without null values) of originalGrandPrixBet',
        () {
          final state = GrandPrixBetEditorState(
            originalGrandPrixBet: GrandPrixBetCreator(
              dnfDriverIds: ['d1', 'd2', null],
            ).createEntity(),
            raceForm: GrandPrixBetEditorRaceForm(
              dnfDrivers: [
                const DriverCreator(id: 'd2').createEntity(),
                const DriverCreator(id: 'd1').createEntity(),
              ],
            ),
          );

          expect(state.canSave, false);
        },
      );

      test(
        'should be false if bets from state are the same as bets in '
        'originalGrandPrixBet',
        () {
          final state = GrandPrixBetEditorState(
            originalGrandPrixBet: GrandPrixBetCreator(
              qualiStandingsByDriverIds: List.generate(
                20,
                (int itemIndex) => itemIndex == 1 ? 'd1' : null,
              ),
              p1DriverId: 'd1',
              p2DriverId: 'd2',
              p3DriverId: 'd3',
              p10DriverId: 'd10',
              fastestLapDriverId: 'd1',
              dnfDriverIds: ['d1', 'd2', null],
              willBeSafetyCar: false,
              willBeRedFlag: true,
            ).createEntity(),
            qualiStandingsByDriverIds: List.generate(
              20,
              (int itemIndex) => itemIndex == 1 ? 'd1' : null,
            ),
            raceForm: GrandPrixBetEditorRaceForm(
              p1DriverId: 'd1',
              p2DriverId: 'd2',
              p3DriverId: 'd3',
              p10DriverId: 'd10',
              fastestLapDriverId: 'd1',
              dnfDrivers: [
                const DriverCreator(id: 'd2').createEntity(),
                const DriverCreator(id: 'd1').createEntity(),
              ],
              willBeSafetyCar: false,
              willBeRedFlag: true,
            ),
          );

          expect(state.canSave, false);
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
