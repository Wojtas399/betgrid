import 'package:betgrid/model/grand_prix.dart';
import 'package:betgrid/use_case/get_finished_grand_prixes_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../creator/grand_prix_creator.dart';
import '../mock/data/repository/mock_grand_prix_repository.dart';
import '../mock/ui/mock_date_service.dart';

void main() {
  final grandPrixRepository = MockGrandPrixRepository();
  final dateService = MockDateService();
  late GetFinishedGrandPrixesUseCase useCase;

  setUp(() {
    useCase = GetFinishedGrandPrixesUseCase(grandPrixRepository, dateService);
  });

  tearDown(() {
    reset(grandPrixRepository);
    reset(dateService);
  });

  test(
    'List of all grand prixes is null, '
    'should return empty list',
    () {
      grandPrixRepository.mockGetAllGrandPrixes(null);

      final Stream<List<GrandPrix>> finishedGrandPrixes$ = useCase();

      expect(finishedGrandPrixes$, emits([]));
    },
  );

  test(
    'List of all grand prixes is empty, '
    'should return empty list',
    () {
      grandPrixRepository.mockGetAllGrandPrixes([]);

      final Stream<List<GrandPrix>> finishedGrandPrixes$ = useCase();

      expect(finishedGrandPrixes$, emits([]));
    },
  );

  test(
    'Should return grand prixes which start date is before now date',
    () {
      final DateTime now = DateTime(2024, 05, 28, 14, 30);
      final List<GrandPrix> allGrandPrixes = [
        GrandPrixCreator(
          id: 'gp1',
          startDate: DateTime(2024, 05, 27),
          endDate: DateTime(2024, 05, 29),
        ).createEntity(),
        GrandPrixCreator(
          id: 'gp2',
          startDate: DateTime(2024, 05, 20),
          endDate: DateTime(2024, 05, 22),
        ).createEntity(),
        GrandPrixCreator(
          id: 'gp3',
          startDate: DateTime(2024, 06, 02),
          endDate: DateTime(2024, 06, 04),
        ).createEntity(),
        GrandPrixCreator(
          id: 'gp4',
          startDate: DateTime(2024, 05, 28),
          endDate: DateTime(2024, 05, 30),
        ).createEntity(),
        GrandPrixCreator(
          id: 'gp5',
          startDate: DateTime(2024, 07, 10),
          endDate: DateTime(2024, 07, 12),
        ).createEntity(),
      ];
      final List<GrandPrix> expectedGrandPrixes = [
        allGrandPrixes.first,
        allGrandPrixes[1],
        allGrandPrixes[3],
      ];
      grandPrixRepository.mockGetAllGrandPrixes(allGrandPrixes);
      dateService.mockGetNow(now: now);

      final Stream<List<GrandPrix>> finishedGrandPrixes$ = useCase();

      expect(finishedGrandPrixes$, emits(expectedGrandPrixes));
    },
  );
}
