import 'package:betgrid/data/repository/grand_prix/grand_prix_repository.dart';
import 'package:betgrid/model/grand_prix.dart';
import 'package:betgrid/ui/provider/grand_prix_id_provider.dart';
import 'package:betgrid/ui/provider/grand_prix_name_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../creator/grand_prix_creator.dart';
import '../../mock/data/repository/mock_grand_prix_repository.dart';
import '../../mock/listener.dart';

void main() {
  final grandPrixRepository = MockGrandPrixRepository();

  ProviderContainer makeProvideContainer(String? grandPrixId) {
    final container = ProviderContainer(
      overrides: [
        grandPrixIdProvider.overrideWithValue(grandPrixId),
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
    'grand prix id is null, '
    'should emit null',
    () async {
      final container = makeProvideContainer(null);
      final listener = Listener<AsyncValue<String?>>();
      container.listen(
        grandPrixNameProvider,
        listener,
        fireImmediately: true,
      );

      await expectLater(
        container.read(grandPrixNameProvider.future),
        completion(null),
      );
      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<String?>(),
            ),
        () => listener(
              const AsyncLoading<String?>(),
              const AsyncData<String?>(null),
            ),
      ]);
      verifyNoMoreInteractions(listener);
      verifyNever(
        () => grandPrixRepository.getGrandPrixById(
          grandPrixId: any(named: 'grandPrixId'),
        ),
      );
    },
  );

  test(
    'should get grand prix from grand prix repository and should emit its name',
    () async {
      const String gpId = 'gp1';
      const String expectedGpName = 'grand prix name';
      final GrandPrix grandPrix = createGrandPrix(
        id: gpId,
        name: expectedGpName,
      );
      grandPrixRepository.mockGetGrandPrixById(grandPrix);
      final container = makeProvideContainer(gpId);
      final listener = Listener<AsyncValue<String?>>();
      container.listen(
        grandPrixNameProvider,
        listener,
        fireImmediately: true,
      );

      await expectLater(
        container.read(grandPrixNameProvider.future),
        completion(expectedGpName),
      );
      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<String?>(),
            ),
        () => listener(
              const AsyncLoading<String?>(),
              const AsyncData<String?>(expectedGpName),
            ),
      ]);
      verifyNoMoreInteractions(listener);
      verify(
        () => grandPrixRepository.getGrandPrixById(grandPrixId: gpId),
      ).called(1);
    },
  );
}
