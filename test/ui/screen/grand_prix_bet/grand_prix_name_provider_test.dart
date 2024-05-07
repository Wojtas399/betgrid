import 'package:betgrid/data/repository/grand_prix/grand_prix_repository.dart';
import 'package:betgrid/model/grand_prix.dart';
import 'package:betgrid/ui/provider/grand_prix_id_provider.dart';
import 'package:betgrid/ui/screen/grand_prix_bet/provider/grand_prix_name_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import '../../../creator/grand_prix_creator.dart';
import '../../../mock/data/repository/mock_grand_prix_repository.dart';

void main() {
  final grandPrixRepository = MockGrandPrixRepository();

  ProviderContainer makeProvideContainer({
    String? grandPrixId,
  }) {
    final container = ProviderContainer(
      overrides: [
        grandPrixIdProvider.overrideWithValue(grandPrixId),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUpAll(() {
    GetIt.I.registerLazySingleton<GrandPrixRepository>(
      () => grandPrixRepository,
    );
  });

  test(
    'grand prix id is null, '
    'should return null',
    () async {
      final container = makeProvideContainer();

      final String? grandPrixName = await container.read(
        grandPrixNameProvider.future,
      );

      expect(grandPrixName, null);
    },
  );

  test(
    'should get grand prix and should emit its name',
    () async {
      const String grandPrixId = 'gp1';
      const String expectedGrandPrixName = 'grand prix name';
      final GrandPrix grandPrix = createGrandPrix(
        id: grandPrixId,
        name: expectedGrandPrixName,
      );
      grandPrixRepository.mockGetGrandPrixById(grandPrix);
      final container = makeProvideContainer(
        grandPrixId: grandPrixId,
      );

      final String? grandPrixName = await container.read(
        grandPrixNameProvider.future,
      );

      expect(grandPrixName, expectedGrandPrixName);
    },
  );
}
