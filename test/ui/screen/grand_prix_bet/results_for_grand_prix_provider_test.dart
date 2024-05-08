import 'package:betgrid/data/repository/grand_prix_result/grand_prix_results_repository.dart';
import 'package:betgrid/model/grand_prix_results.dart';
import 'package:betgrid/ui/provider/grand_prix_id_provider.dart';
import 'package:betgrid/ui/screen/grand_prix_bet/provider/results_for_grand_prix_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import '../../../creator/grand_prix_results_creator.dart';
import '../../../mock/data/repository/mock_grand_prix_results_repository.dart';

void main() {
  final grandPrixResultsRepository = MockGrandPrixResultsRepository();

  ProviderContainer makeProviderContainer({
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
    GetIt.I.registerLazySingleton<GrandPrixResultsRepository>(
      () => grandPrixResultsRepository,
    );
  });

  test(
    'grand prix id is null, '
    'should return null',
    () async {
      final container = makeProviderContainer(grandPrixId: null);

      final GrandPrixResults? results = await container.read(
        resultsForGrandPrixProvider.future,
      );

      expect(results, null);
    },
  );

  test(
    'should get grand prix results and should return them',
    () async {
      const String grandPrixId = 'gp1';
      final expectedResults = createGrandPrixResults(
        raceResults: createRaceResults(p1DriverId: 'd1', p2DriverId: 'd2'),
      );
      grandPrixResultsRepository.mockGetResultsForGrandPrix(
        results: expectedResults,
      );
      final container = makeProviderContainer(
        grandPrixId: grandPrixId,
      );

      final GrandPrixResults? results = await container.read(
        resultsForGrandPrixProvider.future,
      );

      expect(results, expectedResults);
    },
  );
}
