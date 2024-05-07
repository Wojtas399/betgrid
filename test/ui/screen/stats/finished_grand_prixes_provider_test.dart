import 'package:betgrid/data/repository/grand_prix/grand_prix_repository.dart';
import 'package:betgrid/model/grand_prix.dart';
import 'package:betgrid/ui/screen/stats/provider/finished_grand_prixes_provider.dart';
import 'package:betgrid/ui/service/date_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import '../../../creator/grand_prix_creator.dart';
import '../../../mock/data/repository/mock_grand_prix_repository.dart';
import '../../../mock/ui/mock_date_service.dart';

void main() {
  final dateService = MockDateService();
  final grandPrixRepository = MockGrandPrixRepository();

  ProviderContainer makeProviderContainer() {
    final container = ProviderContainer(
      overrides: [
        dateServiceProvider.overrideWithValue(dateService),
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
    'grand prixes do not exist, '
    'should return null',
    () async {
      grandPrixRepository.mockGetAllGrandPrixes(null);
      final container = makeProviderContainer();

      final List<GrandPrix> grandPrixes = await container.read(
        finishedGrandPrixesProvider.future,
      );

      expect(grandPrixes, []);
    },
  );

  test(
    'should return grand prixes which start date is from the past',
    () async {
      final DateTime now = DateTime(2024, 3, 19, 15);
      final List<GrandPrix> allGrandPrixes = [
        createGrandPrix(id: 'gp1', startDate: DateTime(2024, 3, 15)),
        createGrandPrix(
          id: 'gp2',
          startDate: DateTime(2024, 3, 19, 13),
          endDate: DateTime(2024, 3, 20),
        ),
        createGrandPrix(id: 'gp3', startDate: DateTime(2024, 4)),
        createGrandPrix(id: 'gp3', startDate: DateTime(2024, 3, 19, 17)),
      ];
      final List<GrandPrix> expectedGrandPrixes = [
        allGrandPrixes[0],
        allGrandPrixes[1],
      ];
      dateService.mockGetNow(now: now);
      grandPrixRepository.mockGetAllGrandPrixes(allGrandPrixes);
      final container = makeProviderContainer();

      final List<GrandPrix> grandPrixes = await container.read(
        finishedGrandPrixesProvider.future,
      );

      expect(grandPrixes, expectedGrandPrixes);
    },
  );
}
