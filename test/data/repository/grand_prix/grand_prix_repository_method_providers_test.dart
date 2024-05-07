import 'package:betgrid/data/repository/grand_prix/grand_prix_repository.dart';
import 'package:betgrid/data/repository/grand_prix/grand_prix_repository_method_providers.dart';
import 'package:betgrid/model/grand_prix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../creator/grand_prix_creator.dart';
import '../../../mock/data/repository/mock_grand_prix_repository.dart';

void main() {
  final grandPrixRepository = MockGrandPrixRepository();

  ProviderContainer makeProviderContainer() {
    final container = ProviderContainer(
      overrides: [
        grandPrixRepositoryProvider.overrideWithValue(grandPrixRepository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test(
    'grandPrixProvider, '
    'should get grand prix from GrandPrixRepository and should emit it',
    () async {
      const String grandPrixId = 'gp1';
      final GrandPrix expectedGrandPrix = createGrandPrix(id: grandPrixId);
      grandPrixRepository.mockGetGrandPrixById(expectedGrandPrix);
      final container = makeProviderContainer();

      final GrandPrix? grandPrix = await container.read(
        grandPrixProvider(grandPrixId: grandPrixId).future,
      );

      expect(grandPrix, expectedGrandPrix);
    },
  );
}
