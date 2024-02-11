import 'package:betgrid/data/repository/grand_prix/grand_prix_repository.dart';
import 'package:betgrid/model/grand_prix.dart';
import 'package:betgrid/ui/riverpod_provider/grand_prix/grand_prix_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../creator/grand_prix_creator.dart';
import '../../mock/data/repository/mock_grand_prix_repository.dart';
import '../../mock/listener.dart';

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
    'should load and return grand prix from GrandPrixRepository, ',
    () async {
      const String grandPrixId = 'gp1';
      final GrandPrix grandPrix = createGrandPrix(id: grandPrixId);
      grandPrixRepository.mockLoadGrandPrixById(grandPrix);
      final container = makeProviderContainer(grandPrixRepository);
      final listener = Listener<AsyncValue<GrandPrix?>>();
      container.listen(
        grandPrixProvider(grandPrixId),
        listener,
        fireImmediately: true,
      );

      await expectLater(
        container.read(grandPrixProvider(grandPrixId).future),
        completion(grandPrix),
      );
      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<GrandPrix?>(),
            ),
        () => listener(
              const AsyncLoading<GrandPrix?>(),
              AsyncData<GrandPrix?>(grandPrix),
            )
      ]);
      verifyNoMoreInteractions(listener);
      verify(
        () => grandPrixRepository.loadGrandPrixById(grandPrixId: grandPrixId),
      ).called(1);
    },
  );
}
