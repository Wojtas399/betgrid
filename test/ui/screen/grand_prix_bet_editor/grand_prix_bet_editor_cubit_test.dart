import 'dart:async';

import 'package:betgrid/model/driver.dart';
import 'package:betgrid/model/grand_prix_bet.dart';
import 'package:betgrid/ui/screen/grand_prix_bet_editor/cubit/grand_prix_bet_editor_cubit.dart';
import 'package:betgrid/ui/screen/grand_prix_bet_editor/cubit/grand_prix_bet_editor_race_form.dart';
import 'package:betgrid/ui/screen/grand_prix_bet_editor/cubit/grand_prix_bet_editor_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/driver_creator.dart';
import '../../../creator/grand_prix_bet_creator.dart';
import '../../../mock/data/repository/mock_auth_repository.dart';
import '../../../mock/data/repository/mock_driver_repository.dart';
import '../../../mock/data/repository/mock_grand_prix_bet_repository.dart';

void main() {
  final authRepository = MockAuthRepository();
  final grandPrixBetRepository = MockGrandPrixBetRepository();
  final driverRepository = MockDriverRepository();
  const String grandPrixId = 'gp1';

  GrandPrixBetEditorCubit createCubit() => GrandPrixBetEditorCubit(
        authRepository,
        grandPrixBetRepository,
        driverRepository,
      );

  tearDown(() {
    reset(authRepository);
    reset(grandPrixBetRepository);
    reset(driverRepository);
  });

  group(
    'initialize',
    () {
      const String loggedUserId = 'u1';
      final List<Driver> allDrivers = [
        const DriverCreator(
          id: 'd1',
          team: DriverCreatorTeam.mercedes,
          surname: 'Russel',
        ).createEntity(),
        const DriverCreator(
          id: 'd2',
          team: DriverCreatorTeam.alpine,
        ).createEntity(),
        const DriverCreator(
          id: 'd3',
          team: DriverCreatorTeam.mercedes,
          surname: 'Hamilton',
        ).createEntity(),
      ];
      final bet = GrandPrixBetCreator(
        qualiStandingsByDriverIds: List.generate(
          20,
          (int driverIndex) => 'd${driverIndex + 1}',
        ),
        p1DriverId: 'd1',
        p2DriverId: 'd2',
        p3DriverId: 'd3',
        p10DriverId: 'd10',
        fastestLapDriverId: 'd1',
        dnfDriverIds: ['d1', null, null],
        willBeSafetyCar: true,
        willBeRedFlag: false,
      ).createEntity();
      final updatedBet = GrandPrixBetCreator(
        qualiStandingsByDriverIds: List.generate(
          20,
          (int driverIndex) => 'd${driverIndex + 1}',
        ),
        p1DriverId: 'd1',
        p2DriverId: 'd2',
        p3DriverId: 'd3',
        p10DriverId: 'd10',
        fastestLapDriverId: 'd1',
        dnfDriverIds: ['d1', 'd2', null],
        willBeSafetyCar: true,
        willBeRedFlag: false,
      ).createEntity();
      final bet$ = StreamController<GrandPrixBet>()..add(bet);
      GrandPrixBetEditorState? state;

      blocTest(
        'should load all drivers, should listen to grand prix bet and should '
        'emit existing bets and all drivers sorted by team and surname',
        build: () => createCubit(),
        setUp: () {
          driverRepository.mockGetAllDrivers(allDrivers: allDrivers);
          authRepository.mockGetLoggedUserId(loggedUserId);
          when(
            () => grandPrixBetRepository.getGrandPrixBetForPlayerAndGrandPrix(
              playerId: loggedUserId,
              grandPrixId: grandPrixId,
            ),
          ).thenAnswer((_) => bet$.stream);
        },
        act: (cubit) async {
          await cubit.initialize(
            grandPrixId: grandPrixId,
          );
          bet$.add(updatedBet);
        },
        expect: () => [
          state = GrandPrixBetEditorState(
            status: GrandPrixBetEditorStateStatus.completed,
            allDrivers: [
              allDrivers[1],
              allDrivers.last,
              allDrivers.first,
            ],
            qualiStandingsByDriverIds: bet.qualiStandingsByDriverIds,
            raceForm: GrandPrixBetEditorRaceForm(
              p1DriverId: bet.p1DriverId,
              p2DriverId: bet.p2DriverId,
              p3DriverId: bet.p3DriverId,
              p10DriverId: bet.p10DriverId,
              fastestLapDriverId: bet.fastestLapDriverId,
              dnfDrivers: [
                allDrivers.first,
              ],
              willBeSafetyCar: bet.willBeSafetyCar,
              willBeRedFlag: bet.willBeRedFlag,
            ),
          ),
          state = state!.copyWith(
            raceForm: state!.raceForm.copyWith(
              dnfDrivers: [
                allDrivers.first,
                allDrivers[1],
              ],
            ),
          ),
        ],
        verify: (_) {
          verify(driverRepository.getAllDrivers).called(1);
          verify(() => authRepository.loggedUserId$).called(1);
          verify(
            () => grandPrixBetRepository.getGrandPrixBetForPlayerAndGrandPrix(
              playerId: loggedUserId,
              grandPrixId: grandPrixId,
            ),
          ).called(1);
        },
      );
    },
  );

  group(
    'onQualiStandingsChanged',
    () {
      const String driverId = 'd1';

      blocTest(
        'should set driverId at standing - 1 position in '
        'qualiStandingsByDriverIds',
        build: () => createCubit(),
        act: (cubit) => cubit.onQualiStandingsChanged(
          standing: 10,
          driverId: driverId,
        ),
        expect: () => [
          GrandPrixBetEditorState(
            status: GrandPrixBetEditorStateStatus.completed,
            qualiStandingsByDriverIds: List.generate(
              20,
              (int standingIndex) => standingIndex == 9 ? driverId : null,
            ),
          ),
        ],
      );

      blocTest(
        'should set null at index where the value is the same as driverId and '
        'then should set driverId at standing - 1 position',
        build: () => createCubit(),
        act: (cubit) {
          cubit.onQualiStandingsChanged(standing: 4, driverId: driverId);
          cubit.onQualiStandingsChanged(standing: 8, driverId: driverId);
        },
        expect: () => [
          GrandPrixBetEditorState(
            status: GrandPrixBetEditorStateStatus.completed,
            qualiStandingsByDriverIds: List.generate(
              20,
              (int standingIndex) => standingIndex == 3 ? driverId : null,
            ),
          ),
          GrandPrixBetEditorState(
            status: GrandPrixBetEditorStateStatus.completed,
            qualiStandingsByDriverIds: List.generate(
              20,
              (int standingIndex) => standingIndex == 7 ? driverId : null,
            ),
          ),
        ],
      );
    },
  );

  blocTest(
    'onRaceP1DriverChanged, '
    'should assign passed driverId to p1DriverId in raceForm',
    build: () => createCubit(),
    act: (cubit) => cubit.onRaceP1DriverChanged('d1'),
    expect: () => [
      const GrandPrixBetEditorState(
        status: GrandPrixBetEditorStateStatus.completed,
        raceForm: GrandPrixBetEditorRaceForm(
          p1DriverId: 'd1',
        ),
      ),
    ],
  );

  blocTest(
    'onRaceP2DriverChanged, '
    'should assign passed driverId to p2DriverId in raceForm',
    build: () => createCubit(),
    act: (cubit) => cubit.onRaceP2DriverChanged('d1'),
    expect: () => [
      const GrandPrixBetEditorState(
        status: GrandPrixBetEditorStateStatus.completed,
        raceForm: GrandPrixBetEditorRaceForm(
          p2DriverId: 'd1',
        ),
      ),
    ],
  );

  blocTest(
    'onRaceP3DriverChanged, '
    'should assign passed driverId to p3DriverId in raceForm',
    build: () => createCubit(),
    act: (cubit) => cubit.onRaceP3DriverChanged('d1'),
    expect: () => [
      const GrandPrixBetEditorState(
        status: GrandPrixBetEditorStateStatus.completed,
        raceForm: GrandPrixBetEditorRaceForm(
          p3DriverId: 'd1',
        ),
      ),
    ],
  );

  blocTest(
    'onRaceP10DriverChanged, '
    'should assign passed driverId to p10DriverId in raceForm',
    build: () => createCubit(),
    act: (cubit) => cubit.onRaceP10DriverChanged('d1'),
    expect: () => [
      const GrandPrixBetEditorState(
        status: GrandPrixBetEditorStateStatus.completed,
        raceForm: GrandPrixBetEditorRaceForm(
          p10DriverId: 'd1',
        ),
      ),
    ],
  );

  blocTest(
    'onRaceFastestLapDriverChanged, '
    'should assign passed driverId to fastestLapDriverId in raceForm',
    build: () => createCubit(),
    act: (cubit) => cubit.onRaceFastestLapDriverChanged('d1'),
    expect: () => [
      const GrandPrixBetEditorState(
        status: GrandPrixBetEditorStateStatus.completed,
        raceForm: GrandPrixBetEditorRaceForm(
          fastestLapDriverId: 'd1',
        ),
      ),
    ],
  );

  group(
    'onDnfDriverSelected',
    () {
      const String driverId = 'd1';
      final List<Driver> allDrivers = [
        const DriverCreator(id: driverId).createEntity(),
        const DriverCreator(id: 'd2').createEntity(),
      ];
      GrandPrixBetEditorState? state;

      setUp(() {
        authRepository.mockGetLoggedUserId('u1');
      });

      blocTest(
        'should do nothing if allDrivers list is empty',
        build: () => createCubit(),
        setUp: () =>
            grandPrixBetRepository.mockGetGrandPrixBetForPlayerAndGrandPrix(),
        act: (cubit) => cubit.onDnfDriverSelected(driverId),
        expect: () => [],
      );

      blocTest(
        'should do nothing if driver with matching id does not exist in '
        'allDrivers list',
        build: () => createCubit(),
        setUp: () {
          driverRepository.mockGetAllDrivers(allDrivers: allDrivers);
          grandPrixBetRepository.mockGetGrandPrixBetForPlayerAndGrandPrix();
        },
        act: (cubit) async {
          await cubit.initialize(grandPrixId: grandPrixId);
          await cubit.stream.first;
          cubit.onDnfDriverSelected('d3');
        },
        expect: () => [
          GrandPrixBetEditorState(
            status: GrandPrixBetEditorStateStatus.completed,
            allDrivers: allDrivers,
          ),
        ],
      );

      blocTest(
        'should do nothing if driver with matching id already exists in '
        'dnfDrivers list of raceForm',
        build: () => createCubit(),
        setUp: () {
          driverRepository.mockGetAllDrivers(allDrivers: allDrivers);
          grandPrixBetRepository.mockGetGrandPrixBetForPlayerAndGrandPrix(
            grandPrixBet: GrandPrixBetCreator(
              dnfDriverIds: [driverId, 'd2', null],
            ).createEntity(),
          );
        },
        act: (cubit) async {
          await cubit.initialize(grandPrixId: grandPrixId);
          await cubit.stream.first;
          cubit.onDnfDriverSelected(driverId);
        },
        expect: () => [
          GrandPrixBetEditorState(
            status: GrandPrixBetEditorStateStatus.completed,
            allDrivers: allDrivers,
            raceForm: GrandPrixBetEditorRaceForm(
              dnfDrivers: allDrivers,
            ),
          ),
        ],
      );

      blocTest(
        'should add driver to dnfDrivers list of raceForm if driver with '
        'matching id does not exist in this list',
        build: () => createCubit(),
        setUp: () {
          driverRepository.mockGetAllDrivers(allDrivers: allDrivers);
          grandPrixBetRepository.mockGetGrandPrixBetForPlayerAndGrandPrix(
            grandPrixBet: GrandPrixBetCreator(
              dnfDriverIds: ['d2', null, null],
            ).createEntity(),
          );
        },
        act: (cubit) async {
          await cubit.initialize(grandPrixId: grandPrixId);
          await cubit.stream.first;
          cubit.onDnfDriverSelected(driverId);
        },
        expect: () => [
          state = GrandPrixBetEditorState(
            status: GrandPrixBetEditorStateStatus.completed,
            allDrivers: allDrivers,
            raceForm: GrandPrixBetEditorRaceForm(
              dnfDrivers: [allDrivers.last],
            ),
          ),
          state = state!.copyWith(
            raceForm: state!.raceForm.copyWith(
              dnfDrivers: [allDrivers.last, allDrivers.first],
            ),
          ),
        ],
      );
    },
  );

  group(
    'onDnfDriverRemoved',
    () {
      const String driverId = 'd1';
      final List<Driver> allDrivers = [
        const DriverCreator(id: driverId).createEntity(),
        const DriverCreator(id: 'd2').createEntity(),
      ];
      GrandPrixBetEditorState? state;

      setUp(() {
        authRepository.mockGetLoggedUserId('u1');
      });

      blocTest(
        'should do nothing if allDrivers list is empty',
        build: () => createCubit(),
        setUp: () =>
            grandPrixBetRepository.mockGetGrandPrixBetForPlayerAndGrandPrix(),
        act: (cubit) => cubit.onDnfDriverRemoved(driverId),
        expect: () => [],
      );

      blocTest(
        'should do nothing if driver with matching id does not exist in '
        'dnfDrivers list of raceForm',
        build: () => createCubit(),
        setUp: () {
          driverRepository.mockGetAllDrivers(allDrivers: allDrivers);
          grandPrixBetRepository.mockGetGrandPrixBetForPlayerAndGrandPrix(
            grandPrixBet: GrandPrixBetCreator(
              dnfDriverIds: ['d2', null, null],
            ).createEntity(),
          );
        },
        act: (cubit) async {
          await cubit.initialize(grandPrixId: grandPrixId);
          await cubit.stream.first;
          cubit.onDnfDriverRemoved(driverId);
        },
        expect: () => [
          GrandPrixBetEditorState(
            status: GrandPrixBetEditorStateStatus.completed,
            allDrivers: allDrivers,
            raceForm: GrandPrixBetEditorRaceForm(
              dnfDrivers: [allDrivers.last],
            ),
          ),
        ],
      );

      blocTest(
        'should remove driver from dnfDrivers list of raceForm if driver with '
        'matching id exists in this list',
        build: () => createCubit(),
        setUp: () {
          driverRepository.mockGetAllDrivers(allDrivers: allDrivers);
          grandPrixBetRepository.mockGetGrandPrixBetForPlayerAndGrandPrix(
            grandPrixBet: GrandPrixBetCreator(
              dnfDriverIds: ['d2', driverId, null],
            ).createEntity(),
          );
        },
        act: (cubit) async {
          await cubit.initialize(grandPrixId: grandPrixId);
          await cubit.stream.first;
          cubit.onDnfDriverRemoved(driverId);
        },
        expect: () => [
          state = GrandPrixBetEditorState(
            status: GrandPrixBetEditorStateStatus.completed,
            allDrivers: allDrivers,
            raceForm: GrandPrixBetEditorRaceForm(
              dnfDrivers: [allDrivers.last, allDrivers.first],
            ),
          ),
          state = state!.copyWith(
            raceForm: state!.raceForm.copyWith(
              dnfDrivers: [allDrivers.last],
            ),
          ),
        ],
      );
    },
  );

  blocTest(
    'onSafetyCarPredictionChanged, '
    'should assign passed willBeSafetyCar to willBeSafetyCar of raceForm',
    build: () => createCubit(),
    act: (cubit) => cubit.onSafetyCarPredictionChanged(false),
    expect: () => [
      const GrandPrixBetEditorState(
        status: GrandPrixBetEditorStateStatus.completed,
        raceForm: GrandPrixBetEditorRaceForm(
          willBeSafetyCar: false,
        ),
      ),
    ],
  );

  blocTest(
    'onRedFlagPredictionChanged, '
    'should assign passed willBeRedFlag to willBeRedFlag of raceForm',
    build: () => createCubit(),
    act: (cubit) => cubit.onRedFlagPredictionChanged(false),
    expect: () => [
      const GrandPrixBetEditorState(
        status: GrandPrixBetEditorStateStatus.completed,
        raceForm: GrandPrixBetEditorRaceForm(
          willBeRedFlag: false,
        ),
      ),
    ],
  );
}
