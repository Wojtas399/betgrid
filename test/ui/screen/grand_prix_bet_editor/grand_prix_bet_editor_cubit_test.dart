import 'package:betgrid/model/driver.dart';
import 'package:betgrid/ui/screen/grand_prix_bet_editor/cubit/grand_prix_bet_editor_cubit.dart';
import 'package:betgrid/ui/screen/grand_prix_bet_editor/cubit/grand_prix_bet_editor_race_form.dart';
import 'package:betgrid/ui/screen/grand_prix_bet_editor/cubit/grand_prix_bet_editor_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/driver_creator.dart';
import '../../../mock/data/repository/mock_driver_repository.dart';

void main() {
  final driverRepository = MockDriverRepository();

  GrandPrixBetEditorCubit createCubit() => GrandPrixBetEditorCubit(
        driverRepository,
      );

  tearDown(() {
    reset(driverRepository);
  });

  group(
    'initialize',
    () {
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
      final List<Driver> expectedSortedDrivers = [
        allDrivers[1],
        allDrivers.last,
        allDrivers.first,
      ];

      blocTest(
        'should load all drivers and should emit them sorted by team and surname',
        build: () => createCubit(),
        setUp: () => driverRepository.mockGetAllDrivers(allDrivers: allDrivers),
        act: (cubit) async => await cubit.initialize(),
        expect: () => [
          GrandPrixBetEditorState(
            status: GrandPrixBetEditorStateStatus.completed,
            allDrivers: expectedSortedDrivers,
          ),
        ],
        verify: (_) => verify(driverRepository.getAllDrivers).called(1),
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
    'onRaceP1Changed, '
    'should assign passed driverId to p1DriverId in raceForm',
    build: () => createCubit(),
    act: (cubit) => cubit.onRaceP1Changed(driverId: 'd1'),
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
    'onRaceP2Changed, '
    'should assign passed driverId to p2DriverId in raceForm',
    build: () => createCubit(),
    act: (cubit) => cubit.onRaceP2Changed(driverId: 'd1'),
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
    'onRaceP3Changed, '
    'should assign passed driverId to p3DriverId in raceForm',
    build: () => createCubit(),
    act: (cubit) => cubit.onRaceP3Changed(driverId: 'd1'),
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
    'onRaceP10Changed, '
    'should assign passed driverId to p10DriverId in raceForm',
    build: () => createCubit(),
    act: (cubit) => cubit.onRaceP10Changed(driverId: 'd1'),
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
    'onRaceFastestLapChanged, '
    'should assign passed driverId to fastestLapDriverId in raceForm',
    build: () => createCubit(),
    act: (cubit) => cubit.onRaceFastestLapChanged(driverId: 'd1'),
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
    'onDnfDriverAdded',
    () {
      const String driver1Id = 'd1';
      const String driver2Id = 'd2';
      GrandPrixBetEditorState? state;

      blocTest(
        'should add driverId to dnfDriverIds list in raceForm',
        build: () => createCubit(),
        act: (cubit) {
          cubit.onDnfDriverAdded(driverId: driver1Id);
          cubit.onDnfDriverAdded(driverId: driver2Id);
        },
        expect: () => [
          state = const GrandPrixBetEditorState(
            status: GrandPrixBetEditorStateStatus.completed,
            raceForm: GrandPrixBetEditorRaceForm(
              dnfDriverIds: [driver1Id],
            ),
          ),
          state = state?.copyWith(
            raceForm: const GrandPrixBetEditorRaceForm(
              dnfDriverIds: [driver1Id, driver2Id],
            ),
          ),
        ],
      );

      blocTest(
        'should do nothing if driverId already exists in dnfDriverIds list of '
        'raceForm',
        build: () => createCubit(),
        act: (cubit) {
          cubit.onDnfDriverAdded(driverId: driver1Id);
          cubit.onDnfDriverAdded(driverId: driver1Id);
        },
        expect: () => [
          const GrandPrixBetEditorState(
            status: GrandPrixBetEditorStateStatus.completed,
            raceForm: GrandPrixBetEditorRaceForm(
              dnfDriverIds: [driver1Id],
            ),
          ),
        ],
      );
    },
  );

  group(
    'onDnfDriverRemoved',
    () {
      const String driver1Id = 'd1';
      const String driver2Id = 'd2';
      GrandPrixBetEditorState? state;

      blocTest(
        'should remove driverId from dnfDriverIds list of raceForm',
        build: () => createCubit(),
        act: (cubit) {
          cubit.onDnfDriverAdded(driverId: driver1Id);
          cubit.onDnfDriverAdded(driverId: driver2Id);
          cubit.onDnfDriverRemoved(driverId: driver1Id);
        },
        expect: () => [
          state = const GrandPrixBetEditorState(
            status: GrandPrixBetEditorStateStatus.completed,
            raceForm: GrandPrixBetEditorRaceForm(
              dnfDriverIds: [driver1Id],
            ),
          ),
          state = state?.copyWith(
            raceForm: const GrandPrixBetEditorRaceForm(
              dnfDriverIds: [driver1Id, driver2Id],
            ),
          ),
          state = state?.copyWith(
            raceForm: const GrandPrixBetEditorRaceForm(
              dnfDriverIds: [driver2Id],
            ),
          ),
        ],
      );

      blocTest(
        'should do nothing if driverId does not exist in dnfDriverIds list of '
        'raceForm',
        build: () => createCubit(),
        act: (cubit) {
          cubit.onDnfDriverAdded(driverId: driver1Id);
          cubit.onDnfDriverAdded(driverId: driver2Id);
          cubit.onDnfDriverRemoved(driverId: 'd3');
        },
        expect: () => [
          state = const GrandPrixBetEditorState(
            status: GrandPrixBetEditorStateStatus.completed,
            raceForm: GrandPrixBetEditorRaceForm(
              dnfDriverIds: [driver1Id],
            ),
          ),
          state = state?.copyWith(
            raceForm: const GrandPrixBetEditorRaceForm(
              dnfDriverIds: [driver1Id, driver2Id],
            ),
          ),
        ],
      );
    },
  );

  blocTest(
    'onSafetyCarChanged, '
    'should assign passed willBeSafetyCar to willBeSafetyCar of raceForm',
    build: () => createCubit(),
    act: (cubit) => cubit.onSafetyCarChanged(
      willBeSafetyCar: false,
    ),
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
    'onRedFlagChanged, '
    'should assign passed willBeRedFlag to willBeRedFlag of raceForm',
    build: () => createCubit(),
    act: (cubit) => cubit.onRedFlagChanged(
      willBeRedFlag: false,
    ),
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
