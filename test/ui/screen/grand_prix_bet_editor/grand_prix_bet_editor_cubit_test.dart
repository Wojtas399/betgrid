import 'package:betgrid/model/driver.dart';
import 'package:betgrid/ui/screen/grand_prix_bet_editor/cubit/grand_prix_bet_editor_cubit.dart';
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
}
