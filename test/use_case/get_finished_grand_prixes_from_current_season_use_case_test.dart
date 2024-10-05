import 'package:betgrid/model/grand_prix.dart';
import 'package:betgrid/use_case/get_finished_grand_prixes_from_current_season_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../creator/grand_prix_creator.dart';
import '../mock/data/repository/mock_grand_prix_repository.dart';
import '../mock/ui/mock_date_service.dart';

void main() {
  final grandPrixRepository = MockGrandPrixRepository();
  final dateService = MockDateService();
  late GetFinishedGrandPrixesFromCurrentSeasonUseCase useCase;
  final DateTime now = DateTime(2024, 05, 28, 14, 30);

  setUp(() {
    useCase = GetFinishedGrandPrixesFromCurrentSeasonUseCase(
      grandPrixRepository,
      dateService,
    );
    dateService.mockGetNow(now: now);
  });

  tearDown(() {
    verify(
      () => grandPrixRepository.getAllGrandPrixesFromSeason(now.year),
    ).called(1);
    reset(grandPrixRepository);
    reset(dateService);
  });

  test(
    'should return empty list if list of all grand prixes is null',
    () {
      grandPrixRepository.mockGetAllGrandPrixesFromSeason();

      final Stream<List<GrandPrix>> finishedGrandPrixes$ = useCase();

      expect(finishedGrandPrixes$, emits([]));
    },
  );

  test(
    'should return empty list if list of all grand prixes is empty',
    () {
      grandPrixRepository.mockGetAllGrandPrixesFromSeason(
        expectedGrandPrixes: [],
      );

      final Stream<List<GrandPrix>> finishedGrandPrixes$ = useCase();

      expect(finishedGrandPrixes$, emits([]));
    },
  );

  test(
    'should return grand prixes which start date is before now date',
    () {
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
      grandPrixRepository.mockGetAllGrandPrixesFromSeason(
        expectedGrandPrixes: allGrandPrixes,
      );

      final Stream<List<GrandPrix>> finishedGrandPrixes$ = useCase();

      expect(finishedGrandPrixes$, emits(expectedGrandPrixes));
    },
  );
}
