import 'package:betgrid/data/repository/grand_prix/grand_prix_repository_method_providers.dart';
import 'package:betgrid/model/grand_prix.dart';
import 'package:betgrid/ui/provider/grand_prix_id_provider.dart';
import 'package:betgrid/ui/screen/grand_prix_bet/provider/grand_prix_name_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../creator/grand_prix_creator.dart';

void main() {
  ProviderContainer makeProvideContainer({
    String? grandPrixId,
    GrandPrix? grandPrix,
  }) {
    final container = ProviderContainer(
      overrides: [
        grandPrixIdProvider.overrideWithValue(grandPrixId),
        if (grandPrixId != null)
          grandPrixProvider(grandPrixId: grandPrixId).overrideWith(
            (_) => Stream.value(grandPrix),
          ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

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
      final container = makeProvideContainer(
        grandPrixId: grandPrixId,
        grandPrix: grandPrix,
      );

      final String? grandPrixName = await container.read(
        grandPrixNameProvider.future,
      );

      expect(grandPrixName, expectedGrandPrixName);
    },
  );
}
