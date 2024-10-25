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

      blocTest(
        'should load all drivers and should emit them sorted by team and surname',
        build: () => createCubit(),
        setUp: () => driverRepository.mockGetAllDrivers(allDrivers: allDrivers),
        act: (cubit) async => await cubit.initialize(),
        expect: () => [
          GrandPrixBetEditorState(
            status: GrandPrixBetEditorStateStatus.completed,
            allDrivers: [
              allDrivers[1],
              allDrivers.last,
              allDrivers.first,
            ],
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
      final List<Driver> allDrivers = [
        const DriverCreator(
          id: 'd1',
          team: DriverCreatorTeam.mercedes,
          surname: 'Russel',
        ).createEntity(),
        const DriverCreator(
          id: 'd2',
          team: DriverCreatorTeam.mercedes,
          surname: 'Hamilton',
        ).createEntity(),
        const DriverCreator(
          id: 'd3',
          team: DriverCreatorTeam.alpine,
        ).createEntity(),
      ];
      GrandPrixBetEditorState? state;

      blocTest(
        'should do nothing if allDrivers list does not exist',
        build: () => createCubit(),
        act: (cubit) => cubit.onDnfDriverSelected('d1'),
        expect: () => [],
      );

      blocTest(
        'should do nothing if driver with matching id does not exist in '
        'allDrivers list',
        build: () => createCubit(),
        setUp: () => driverRepository.mockGetAllDrivers(allDrivers: allDrivers),
        act: (cubit) async {
          await cubit.initialize();
          cubit.onDnfDriverSelected('d4');
        },
        expect: () => [
          GrandPrixBetEditorState(
            status: GrandPrixBetEditorStateStatus.completed,
            allDrivers: allDrivers.reversed.toList(),
          ),
        ],
      );

      blocTest(
        'should add driver with matching id to dnfDrivers list of raceForm and '
        'should sort this list by team and surname',
        build: () => createCubit(),
        setUp: () => driverRepository.mockGetAllDrivers(allDrivers: allDrivers),
        act: (cubit) async {
          await cubit.initialize();
          cubit.onDnfDriverSelected('d1');
          cubit.onDnfDriverSelected('d2');
          cubit.onDnfDriverSelected('d3');
        },
        expect: () => [
          state = GrandPrixBetEditorState(
            status: GrandPrixBetEditorStateStatus.completed,
            allDrivers: allDrivers.reversed.toList(),
          ),
          state = state?.copyWith(
            raceForm: GrandPrixBetEditorRaceForm(
              dnfDrivers: [
                allDrivers.first,
              ],
            ),
          ),
          state = state?.copyWith(
            raceForm: GrandPrixBetEditorRaceForm(
              dnfDrivers: [
                allDrivers[1],
                allDrivers.first,
              ],
            ),
          ),
          state = state?.copyWith(
            raceForm: GrandPrixBetEditorRaceForm(
              dnfDrivers: allDrivers.reversed.toList(),
            ),
          ),
        ],
      );

      blocTest(
        'should remove driver from dnfDrivers list of raceForm if it already '
        'exists in it',
        build: () => createCubit(),
        setUp: () => driverRepository.mockGetAllDrivers(allDrivers: allDrivers),
        act: (cubit) async {
          await cubit.initialize();
          cubit.onDnfDriverSelected('d1');
          cubit.onDnfDriverSelected('d2');
          cubit.onDnfDriverSelected('d1');
        },
        expect: () => [
          state = GrandPrixBetEditorState(
            status: GrandPrixBetEditorStateStatus.completed,
            allDrivers: allDrivers.reversed.toList(),
          ),
          state = state?.copyWith(
            raceForm: GrandPrixBetEditorRaceForm(
              dnfDrivers: [
                allDrivers.first,
              ],
            ),
          ),
          state = state?.copyWith(
            raceForm: GrandPrixBetEditorRaceForm(
              dnfDrivers: [
                allDrivers[1],
                allDrivers.first,
              ],
            ),
          ),
          state = state?.copyWith(
            raceForm: GrandPrixBetEditorRaceForm(
              dnfDrivers: [
                allDrivers[1],
              ],
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
