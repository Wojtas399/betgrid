import 'package:betgrid/data/repository/grand_prix/grand_prix_repository.dart';
import 'package:betgrid/data/repository/grand_prix/grand_prix_repository_method_providers.dart';
import 'package:betgrid/model/grand_prix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

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
    'allGrandPrixesProvider, '
    'should get all grand prixes from GrandPrixRepository and should emit them',
    () async {
      final expectedGrandPrixes = [
        GrandPrix(
          id: 'gp1',
          name: 'Grand Prix 1',
          countryAlpha2Code: 'BH',
          startDate: DateTime(2023, 1, 1),
          endDate: DateTime(2023, 1, 3),
        ),
        GrandPrix(
          id: 'gp2',
          name: 'Grand Prix 2',
          countryAlpha2Code: 'PL',
          startDate: DateTime(2023, 1, 5),
          endDate: DateTime(2023, 1, 7),
        ),
        GrandPrix(
          id: 'gp3',
          name: 'Grand Prix 3',
          countryAlpha2Code: 'XD',
          startDate: DateTime(2023, 1, 9),
          endDate: DateTime(2023, 1, 11),
        ),
      ];
      grandPrixRepository.mockGetAllGrandPrixes(expectedGrandPrixes);
      final container = makeProviderContainer();

      final List<GrandPrix>? grandPrixes =
          await container.read(allGrandPrixesProvider.future);

      expect(grandPrixes, expectedGrandPrixes);
    },
  );
}
