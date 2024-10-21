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
        const DriverCreator(id: 'd1').createEntity(),
        const DriverCreator(id: 'd2').createEntity(),
      ];

      blocTest(
        'should load and emit list of all drivers',
        build: () => createCubit(),
        setUp: () => driverRepository.mockGetAllDrivers(allDrivers: allDrivers),
        act: (cubit) async => await cubit.initialize(),
        expect: () => [
          GrandPrixBetEditorState(
            status: GrandPrixBetEditorStateStatus.completed,
            allDrivers: allDrivers,
          ),
        ],
        verify: (_) => verify(driverRepository.getAllDrivers).called(1),
      );
    },
  );
}
