import 'package:betgrid/model/season_grand_prix.dart';
import 'package:betgrid/use_case/get_finished_grand_prixes_from_current_season_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../creator/season_grand_prix_creator.dart';
import '../mock/repository/mock_season_grand_prix_repository.dart';
import '../mock/ui/mock_date_service.dart';

void main() {
  final seasonGrandPrixRepository = MockSeasonGrandPrixRepository();
  final dateService = MockDateService();
  late GetFinishedGrandPrixesFromCurrentSeasonUseCase useCase;
  final DateTime now = DateTime(2024, 05, 28, 14, 30);

  setUp(() {
    useCase = GetFinishedGrandPrixesFromCurrentSeasonUseCase(
      seasonGrandPrixRepository,
      dateService,
    );
    dateService.mockGetNow(now: now);
  });

  tearDown(() {
    verify(
      () => seasonGrandPrixRepository.getAllSeasonGrandPrixesFromSeason(
        now.year,
      ),
    ).called(1);
    reset(seasonGrandPrixRepository);
    reset(dateService);
  });

  test(
    'should return empty list if list of all grand prixes from season is empty',
    () {
      seasonGrandPrixRepository.mockGetAllSeasonGrandPrixesFromSeason(
        expectedSeasonGrandPrixes: [],
      );

      final Stream<List<SeasonGrandPrix>> finishedGrandPrixes$ = useCase();

      expect(finishedGrandPrixes$, emits([]));
    },
  );

  test(
    'should return empty list if there are no finished grand prixes from season',
    () async {
      final List<SeasonGrandPrix> grandPrixesFromSeason = [
        SeasonGrandPrixCreator(
          startDate: DateTime(2024, 5, 30),
        ).create(),
        SeasonGrandPrixCreator(
          startDate: DateTime(2024, 5, 28, 14, 30),
        ).create(),
        SeasonGrandPrixCreator(
          startDate: DateTime(2024, 5, 28, 14, 31),
        ).create(),
      ];
      seasonGrandPrixRepository.mockGetAllSeasonGrandPrixesFromSeason(
        expectedSeasonGrandPrixes: grandPrixesFromSeason,
      );

      final Stream<List<SeasonGrandPrix>> finishedGrandPrixes$ = useCase();

      expect(finishedGrandPrixes$, emits([]));
    },
  );

  test(
    'should return grand prixes which start date is before now date',
    () {
      final List<SeasonGrandPrix> grandPrixesFromSeason = [
        SeasonGrandPrixCreator(
          id: 'sgp1',
          startDate: DateTime(2024, 05, 27),
          endDate: DateTime(2024, 05, 29),
        ).create(),
        SeasonGrandPrixCreator(
          id: 'sgp2',
          startDate: DateTime(2024, 05, 20),
          endDate: DateTime(2024, 05, 22),
        ).create(),
        SeasonGrandPrixCreator(
          id: 'sgp3',
          startDate: DateTime(2024, 06, 02),
          endDate: DateTime(2024, 06, 04),
        ).create(),
        SeasonGrandPrixCreator(
          id: 'sgp4',
          startDate: DateTime(2024, 05, 28),
          endDate: DateTime(2024, 05, 30),
        ).create(),
        SeasonGrandPrixCreator(
          id: 'sgp5',
          startDate: DateTime(2024, 07, 10),
          endDate: DateTime(2024, 07, 12),
        ).create(),
      ];
      final List<SeasonGrandPrix> expectedFinishedGrandPrixes = [
        grandPrixesFromSeason.first,
        grandPrixesFromSeason[1],
        grandPrixesFromSeason[3],
      ];
      seasonGrandPrixRepository.mockGetAllSeasonGrandPrixesFromSeason(
        expectedSeasonGrandPrixes: grandPrixesFromSeason,
      );

      final Stream<List<SeasonGrandPrix>> finishedGrandPrixes$ = useCase();

      expect(finishedGrandPrixes$, emits(expectedFinishedGrandPrixes));
    },
  );
}
