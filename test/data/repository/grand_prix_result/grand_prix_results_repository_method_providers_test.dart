import 'package:betgrid/data/repository/grand_prix_result/grand_prix_results_repository.dart';
import 'package:betgrid/data/repository/grand_prix_result/grand_prix_results_repository_method_providers.dart';
import 'package:betgrid/model/grand_prix_results.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../creator/grand_prix_results_creator.dart';
import '../../../mock/data/repository/mock_grand_prix_results_repository.dart';

void main() {
  test(
    'grandPrixResultsProvider, '
    'should get results for grand prix from GrandPrixResultsRepository and '
    'should emit them',
    () async {
      const String grandPrixId = 'gp1';
      final GrandPrixResults expectedResults = createGrandPrixResults(
        id: 'gpr1',
        grandPrixId: grandPrixId,
      );
      final grandPrixResultsRepository = MockGrandPrixResultsRepository();
      grandPrixResultsRepository.mockGetResultsForGrandPrix(
        results: expectedResults,
      );
      final container = ProviderContainer(
        overrides: [
          grandPrixResultsRepositoryProvider.overrideWithValue(
            grandPrixResultsRepository,
          ),
        ],
      );

      final GrandPrixResults? results = await container.read(
        grandPrixResultsProvider(grandPrixId: grandPrixId).future,
      );

      expect(results, expectedResults);
    },
  );
}
