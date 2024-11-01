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
        qualiBets: null,
        racePodiumBets: null,
        raceP10Bet: null,
        raceFastestLapBet: null,
        raceDnfDriversBet: null,
        raceSafetyCarBet: null,
        raceRedFlagBet: null,
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
    'copyWith canEdit',
    () {
      GrandPrixBetState state = const GrandPrixBetState();

      test(
        'should set new value if passed value is not null',
        () {
          const bool newValue = true;

          state = state.copyWith(canEdit: newValue);

          expect(state.canEdit, newValue);
        },
      );

      test(
        'should not change current value if passed value is not specified',
        () {
          final bool? currentValue = state.canEdit;

          state = state.copyWith();

          expect(state.canEdit, currentValue);
        },
      );

      test(
        'should set null if passed value is null',
        () {
          state = state.copyWith(canEdit: null);

          expect(state.canEdit, null);
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

  group(
    'copyWith qualiBets',
    () {
      GrandPrixBetState state = const GrandPrixBetState();

      test(
        'should set new value if passed value is not null',
        () {
          final List<SingleDriverBet> newValue = List.generate(
            20,
            (int i) => SingleDriverBet(
              status: BetStatus.pending,
              betDriver: DriverCreator(id: 'd${i + 1}').createEntity(),
              resultDriver: DriverCreator(id: 'd${i + 1}').createEntity(),
              points: 10.2,
            ),
          );

          state = state.copyWith(qualiBets: newValue);

          expect(state.qualiBets, newValue);
        },
      );

      test(
        'should not change current value if passed value is not specified',
        () {
          final List<SingleDriverBet>? currentValue = state.qualiBets;

          state = state.copyWith();

          expect(state.qualiBets, currentValue);
        },
      );

      test(
        'should set null if passed value is null',
        () {
          state = state.copyWith(qualiBets: null);

          expect(state.qualiBets, null);
        },
      );
    },
  );

  group(
    'copyWith racePodiumBets',
    () {
      GrandPrixBetState state = const GrandPrixBetState();

      test(
        'should set new value if passed value is not null',
        () {
          final List<SingleDriverBet> newValue = List.generate(
            3,
            (int i) => SingleDriverBet(
              status: BetStatus.pending,
              betDriver: DriverCreator(id: 'd${i + 1}').createEntity(),
              resultDriver: DriverCreator(id: 'd${i + 1}').createEntity(),
              points: 10.2,
            ),
          );

          state = state.copyWith(racePodiumBets: newValue);

          expect(state.racePodiumBets, newValue);
        },
      );

      test(
        'should not change current value if passed value is not specified',
        () {
          final List<SingleDriverBet>? currentValue = state.racePodiumBets;

          state = state.copyWith();

          expect(state.racePodiumBets, currentValue);
        },
      );

      test(
        'should set null if passed value is null',
        () {
          state = state.copyWith(racePodiumBets: null);

          expect(state.racePodiumBets, null);
        },
      );
    },
  );

  group(
    'copyWith raceP10Bet',
    () {
      GrandPrixBetState state = const GrandPrixBetState();

      test(
        'should set new value if passed value is not null',
        () {
          final SingleDriverBet newValue = SingleDriverBet(
            status: BetStatus.pending,
            betDriver: const DriverCreator(id: 'd1').createEntity(),
            resultDriver: const DriverCreator(id: 'd1').createEntity(),
            points: 10.2,
          );

          state = state.copyWith(raceP10Bet: newValue);

          expect(state.raceP10Bet, newValue);
        },
      );

      test(
        'should not change current value if passed value is not specified',
        () {
          final SingleDriverBet? currentValue = state.raceP10Bet;

          state = state.copyWith();

          expect(state.raceP10Bet, currentValue);
        },
      );

      test(
        'should set null if passed value is null',
        () {
          state = state.copyWith(raceP10Bet: null);

          expect(state.raceP10Bet, null);
        },
      );
    },
  );

  group(
    'copyWith raceFastestLapBet',
    () {
      GrandPrixBetState state = const GrandPrixBetState();

      test(
        'should set new value if passed value is not null',
        () {
          final SingleDriverBet newValue = SingleDriverBet(
            status: BetStatus.pending,
            betDriver: const DriverCreator(id: 'd1').createEntity(),
            resultDriver: const DriverCreator(id: 'd1').createEntity(),
            points: 10.2,
          );

          state = state.copyWith(raceFastestLapBet: newValue);

          expect(state.raceFastestLapBet, newValue);
        },
      );

      test(
        'should not change current value if passed value is not specified',
        () {
          final SingleDriverBet? currentValue = state.raceFastestLapBet;

          state = state.copyWith();

          expect(state.raceFastestLapBet, currentValue);
        },
      );

      test(
        'should set null if passed value is null',
        () {
          state = state.copyWith(raceFastestLapBet: null);

          expect(state.raceFastestLapBet, null);
        },
      );
    },
  );

  group(
    'copyWith raceDnfDriversBet',
    () {
      GrandPrixBetState state = const GrandPrixBetState();

      test(
        'should set new value if passed value is not null',
        () {
          final MultipleDriversBet newValue = MultipleDriversBet(
            status: BetStatus.pending,
            betDrivers: [
              const DriverCreator(id: 'd1').createEntity(),
            ],
            resultDrivers: [
              const DriverCreator(id: 'd1').createEntity(),
            ],
            points: 10.2,
          );

          state = state.copyWith(raceDnfDriversBet: newValue);

          expect(state.raceDnfDriversBet, newValue);
        },
      );

      test(
        'should not change current value if passed value is not specified',
        () {
          final MultipleDriversBet? currentValue = state.raceDnfDriversBet;

          state = state.copyWith();

          expect(state.raceDnfDriversBet, currentValue);
        },
      );

      test(
        'should set null if passed value is null',
        () {
          state = state.copyWith(raceDnfDriversBet: null);

          expect(state.raceDnfDriversBet, null);
        },
      );
    },
  );

  group(
    'copyWith raceSafetyCarBet',
    () {
      GrandPrixBetState state = const GrandPrixBetState();

      test(
        'should set new value if passed value is not null',
        () {
          const BooleanBet newValue = BooleanBet(
            status: BetStatus.pending,
            betValue: true,
            resultValue: true,
            points: 10.2,
          );

          state = state.copyWith(raceSafetyCarBet: newValue);

          expect(state.raceSafetyCarBet, newValue);
        },
      );

      test(
        'should not change current value if passed value is not specified',
        () {
          final BooleanBet? currentValue = state.raceSafetyCarBet;

          state = state.copyWith();

          expect(state.raceSafetyCarBet, currentValue);
        },
      );

      test(
        'should set null if passed value is null',
        () {
          state = state.copyWith(raceSafetyCarBet: null);

          expect(state.raceSafetyCarBet, null);
        },
      );
    },
  );

  group(
    'copyWithraceRedFlagBet',
    () {
      GrandPrixBetState state = const GrandPrixBetState();

      test(
        'should set new value if passed value is not null',
        () {
          const BooleanBet newValue = BooleanBet(
            status: BetStatus.pending,
            betValue: true,
            resultValue: true,
            points: 10.2,
          );

          state = state.copyWith(raceRedFlagBet: newValue);

          expect(state.raceRedFlagBet, newValue);
        },
      );

      test(
        'should not change current value if passed value is not specified',
        () {
          final BooleanBet? currentValue = state.raceRedFlagBet;

          state = state.copyWith();

          expect(state.raceRedFlagBet, currentValue);
        },
      );

      test(
        'should set null if passed value is null',
        () {
          state = state.copyWith(raceRedFlagBet: null);

          expect(state.raceRedFlagBet, null);
        },
      );
    },
  );
}
