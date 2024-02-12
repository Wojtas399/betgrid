import 'package:betgrid/data/repository/grand_prix/grand_prix_repository.dart';
import 'package:betgrid/ui/riverpod_provider/grand_prix_id/grand_prix_id_provider.dart';
import 'package:betgrid/ui/screen/qualifications_bet/provider/qualifications_bet_grand_prix_name_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../creator/grand_prix_creator.dart';
import '../../../mock/data/repository/mock_grand_prix_repository.dart';
import '../../../mock/listener.dart';

void main() {
  final grandPrixRepository = MockGrandPrixRepository();

  ProviderContainer makeProviderContainer(
    String grandPrixId,
    MockGrandPrixRepository grandPrixRepository,
  ) {
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
    'should load grand prix from repository and return its name',
    () async {
      const String grandPrixId = 'gp1';
      const String grandPrixName = 'grand prix 1';
      grandPrixRepository.mockLoadGrandPrixById(
        createGrandPrix(
          id: grandPrixId,
          name: grandPrixName,
        ),
      );
      final container = makeProviderContainer(
        grandPrixId,
        grandPrixRepository,
      );
      final listener = Listener<AsyncValue<String?>>();
      container.listen(
        qualificationsBetGrandPrixNameProvider,
        listener,
        fireImmediately: true,
      );

      await expectLater(
        container.read(qualificationsBetGrandPrixNameProvider.future),
        completion(grandPrixName),
      );
      verify(
        () => grandPrixRepository.loadGrandPrixById(grandPrixId: grandPrixId),
      ).called(1);
    },
  );
}
