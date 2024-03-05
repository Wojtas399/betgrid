import 'package:betgrid/data/repository/grand_prix_result/grand_prix_results_repository.dart';
import 'package:betgrid/ui/provider/grand_prix_id_provider.dart';
import 'package:betgrid/ui/provider/grand_prix_results_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../creator/grand_prix_results_creator.dart';
import '../../mock/data/repository/mock_grand_prix_results_repository.dart';

void main() {
  final grandPrixResultsRepository = MockGrandPrixResultsRepository();

  ProviderContainer makeProviderContainer({String? grandPrixId}) {
    final container = ProviderContainer(
      overrides: [
        grandPrixIdProvider.overrideWithValue(grandPrixId),
        grandPrixResultsRepositoryProvider.overrideWithValue(
          grandPrixResultsRepository,
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  tearDown(() {
    reset(grandPrixResultsRepository);
  });

  test(
    'grand prix id is null, '
    'should emit null',
    () async {
      final container = makeProviderContainer(grandPrixId: null);

      await expectLater(
        container.read(grandPrixResultsProvider.future),
        completion(null),
      );
    },
  );

  test(
    'should get grand prix results from GrandPrixResultsRepository and '
    'should emit them',
    () async {
      const String grandPrixId = 'gp1';
      final expectedResults = createGrandPrixResults(
        p1DriverId: 'd1',
        p2DriverId: 'd2',
      );
      grandPrixResultsRepository.mockGetResultsForGrandPrix(
        results: expectedResults,
      );
      final container = makeProviderContainer(grandPrixId: grandPrixId);

      await expectLater(
        container.read(grandPrixResultsProvider.future),
        completion(expectedResults),
      );
      verify(
        () => grandPrixResultsRepository.getResultForGrandPrix(
          grandPrixId: grandPrixId,
        ),
      ).called(1);
    },
  );
}
