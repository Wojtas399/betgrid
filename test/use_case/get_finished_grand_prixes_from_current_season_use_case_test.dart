import 'package:betgrid/model/grand_prix_v2.dart';
import 'package:betgrid/model/season_grand_prix.dart';
import 'package:betgrid/use_case/get_finished_grand_prixes_from_current_season_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../creator/grand_prix_v2_creator.dart';
import '../creator/season_grand_prix_creator.dart';
import '../mock/data/repository/mock_season_grand_prix_repository.dart';
import '../mock/ui/mock_date_service.dart';
import '../mock/use_case/mock_get_grand_prix_based_on_season_grand_prix_use_case.dart';

void main() {
  final seasonGrandPrixRepository = MockSeasonGrandPrixRepository();
  final getGrandPrixBasedOnSeasonGrandPrixUseCase =
      MockGetGrandPrixBasedOnSeasonGrandPrixUseCase();
  final dateService = MockDateService();
  late GetFinishedGrandPrixesFromCurrentSeasonUseCase useCase;
  final DateTime now = DateTime(2024, 05, 28, 14, 30);

  setUp(() {
    useCase = GetFinishedGrandPrixesFromCurrentSeasonUseCase(
      seasonGrandPrixRepository,
      getGrandPrixBasedOnSeasonGrandPrixUseCase,
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
    reset(getGrandPrixBasedOnSeasonGrandPrixUseCase);
    reset(dateService);
  });

  test(
    'should return empty list if list of all season grand prixes is empty',
    () {
      seasonGrandPrixRepository.mockGetAllSeasonGrandPrixesFromSeason(
        expectedSeasonGrandPrixes: [],
      );

      final Stream<List<GrandPrixV2>> finishedGrandPrixes$ = useCase();

      expect(finishedGrandPrixes$, emits([]));
    },
  );

  test(
    'should return empty list if list of finished season grand prixes is empty',
    () async {
      final List<SeasonGrandPrix> allSeasonGrandPrixes = [
        SeasonGrandPrixCreator(
          startDate: DateTime(2024, 5, 30),
        ).createEntity(),
        SeasonGrandPrixCreator(
          startDate: DateTime(2024, 5, 28, 14, 30),
        ).createEntity(),
        SeasonGrandPrixCreator(
          startDate: DateTime(2024, 5, 28, 14, 31),
        ).createEntity(),
      ];
      seasonGrandPrixRepository.mockGetAllSeasonGrandPrixesFromSeason(
        expectedSeasonGrandPrixes: allSeasonGrandPrixes,
      );

      final Stream<List<GrandPrixV2>> finishedGrandPrixes$ = useCase();

      expect(finishedGrandPrixes$, emits([]));
    },
  );

  test(
    'should return grand prixes which start date is before now date',
    () {
      final List<SeasonGrandPrix> allSeasonGrandPrixes = [
        SeasonGrandPrixCreator(
          id: 'sgp1',
          startDate: DateTime(2024, 05, 27),
          endDate: DateTime(2024, 05, 29),
        ).createEntity(),
        SeasonGrandPrixCreator(
          id: 'sgp2',
          startDate: DateTime(2024, 05, 20),
          endDate: DateTime(2024, 05, 22),
        ).createEntity(),
        SeasonGrandPrixCreator(
          id: 'sgp3',
          startDate: DateTime(2024, 06, 02),
          endDate: DateTime(2024, 06, 04),
        ).createEntity(),
        SeasonGrandPrixCreator(
          id: 'sgp4',
          startDate: DateTime(2024, 05, 28),
          endDate: DateTime(2024, 05, 30),
        ).createEntity(),
        SeasonGrandPrixCreator(
          id: 'sgp5',
          startDate: DateTime(2024, 07, 10),
          endDate: DateTime(2024, 07, 12),
        ).createEntity(),
      ];
      final List<GrandPrixV2> expectedGrandPrixes = [
        GrandPrixV2Creator(
          seasonGrandPrixId: allSeasonGrandPrixes.first.id,
          startDate: allSeasonGrandPrixes.first.startDate,
          endDate: allSeasonGrandPrixes.first.endDate,
        ).create(),
        GrandPrixV2Creator(
          seasonGrandPrixId: allSeasonGrandPrixes[1].id,
          startDate: allSeasonGrandPrixes[1].startDate,
          endDate: allSeasonGrandPrixes[1].endDate,
        ).create(),
        GrandPrixV2Creator(
          seasonGrandPrixId: allSeasonGrandPrixes[3].id,
          startDate: allSeasonGrandPrixes[3].startDate,
          endDate: allSeasonGrandPrixes[3].endDate,
        ).create(),
      ];
      seasonGrandPrixRepository.mockGetAllSeasonGrandPrixesFromSeason(
        expectedSeasonGrandPrixes: allSeasonGrandPrixes,
      );
      when(
        () => getGrandPrixBasedOnSeasonGrandPrixUseCase.call(
          allSeasonGrandPrixes.first,
        ),
      ).thenAnswer((_) => Stream.value(expectedGrandPrixes.first));
      when(
        () => getGrandPrixBasedOnSeasonGrandPrixUseCase.call(
          allSeasonGrandPrixes[1],
        ),
      ).thenAnswer((_) => Stream.value(expectedGrandPrixes[1]));
      when(
        () => getGrandPrixBasedOnSeasonGrandPrixUseCase.call(
          allSeasonGrandPrixes[3],
        ),
      ).thenAnswer((_) => Stream.value(expectedGrandPrixes.last));

      final Stream<List<GrandPrixV2>> finishedGrandPrixes$ = useCase();

      expect(finishedGrandPrixes$, emits(expectedGrandPrixes));
    },
  );
}
