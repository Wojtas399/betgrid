import 'package:betgrid/data/repository/grand_prix/grand_prix_repository.dart';
import 'package:betgrid/model/grand_prix.dart';
import 'package:betgrid/ui/screen/home/controller/home_controller.dart';
import 'package:betgrid/ui/screen/home/state/home_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mock/data/repository/mock_grand_prix_repository.dart';
import '../../../mock/listener.dart';

void main() {
  final grandPrixRepository = MockGrandPrixRepository();

  ProviderContainer makeProviderContainer(
    MockGrandPrixRepository grandPrixRepository,
  ) {
    final container = ProviderContainer(
      overrides: [
        grandPrixRepositoryProvider.overrideWithValue(grandPrixRepository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  tearDown(() {
    reset(grandPrixRepository);
  });

  test(
    'build, '
    'should load all grand prixes from GrandPrixRepository and '
    'should emit them in HomeStateDataLoaded state sorted by date',
    () async {
      final GrandPrix gp1 = GrandPrix(
        id: 'gp1',
        name: 'Grand Prix 1',
        startDate: DateTime(2023, 1, 1),
        endDate: DateTime(2023, 1, 3),
      );
      final GrandPrix gp2 = GrandPrix(
        id: 'gp2',
        name: 'Grand Prix 2',
        startDate: DateTime(2023, 1, 5),
        endDate: DateTime(2023, 1, 7),
      );
      final GrandPrix gp3 = GrandPrix(
        id: 'gp3',
        name: 'Grand Prix 3',
        startDate: DateTime(2023, 1, 9),
        endDate: DateTime(2023, 1, 11),
      );
      grandPrixRepository.mockLoadAllGrandPrixes([gp3, gp1, gp2]);
      final container = makeProviderContainer(grandPrixRepository);
      final listener = Listener<AsyncValue<HomeState>>();
      container.listen(
        homeControllerProvider,
        listener,
        fireImmediately: true,
      );
      final controller = container.read(homeControllerProvider.notifier);

      await controller.future;

      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<HomeState>(),
            ),
        () => listener(
              const AsyncLoading<HomeState>(),
              AsyncData<HomeState>(
                HomeStateDataLoaded(grandPrixes: [gp1, gp2, gp3]),
              ),
            ),
      ]);
      verifyNoMoreInteractions(listener);
      verify(grandPrixRepository.loadAllGrandPrixes).called(1);
    },
  );
}
