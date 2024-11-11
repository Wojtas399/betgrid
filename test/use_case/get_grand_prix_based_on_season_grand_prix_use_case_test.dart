import 'package:betgrid/model/grand_prix_basic_info.dart';
import 'package:betgrid/model/grand_prix_v2.dart';
import 'package:betgrid/model/season_grand_prix.dart';
import 'package:betgrid/use_case/get_grand_prix_based_on_season_grand_prix_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../creator/season_grand_prix_creator.dart';
import '../mock/data/repository/mock_grand_prix_basic_info_repository.dart';

void main() {
  final grandPrixBasicInfoRepository = MockGrandPrixBasicInfoRepository();
  final useCase = GetGrandPrixBasedOnSeasonGrandPrixUseCase(
    grandPrixBasicInfoRepository,
  );

  final SeasonGrandPrix seasonGrandPrix = SeasonGrandPrixCreator(
    id: 'sgp1',
    grandPrixId: 'gp1',
    roundNumber: 2,
    startDate: DateTime(2024, 2),
    endDate: DateTime(2024, 2, 2),
  ).createEntity();
  final GrandPrixBasicInfo grandPrixBasicInfo = GrandPrixBasicInfo(
    id: seasonGrandPrix.grandPrixId,
    name: 'Africa grand prix',
    countryAlpha2Code: 'AF',
  );
  final GrandPrixV2 expectedGrandPrix = GrandPrixV2(
    seasonGrandPrixId: seasonGrandPrix.id,
    name: grandPrixBasicInfo.name,
    countryAlpha2Code: grandPrixBasicInfo.countryAlpha2Code,
    roundNumber: seasonGrandPrix.roundNumber,
    startDate: seasonGrandPrix.startDate,
    endDate: seasonGrandPrix.endDate,
  );

  tearDown(() {
    verify(
      () => grandPrixBasicInfoRepository.getGrandPrixBasicInfoById(
        seasonGrandPrix.grandPrixId,
      ),
    ).called(1);
    reset(grandPrixBasicInfoRepository);
  });

  test(
    'should emit null if there are no basic info about given grand prix in '
    'GrandPrixBasicInfoRepository',
    () async {
      grandPrixBasicInfoRepository.mockGetGrandPrixBasicInfoById();

      final Stream<GrandPrixV2?> grandPrix$ = useCase(seasonGrandPrix);

      expect(await grandPrix$.first, null);
    },
  );

  test(
    'should emit GrandPrix model which contains data from SeasonGrandPrix and '
    'GrandPrixBasicInfo',
    () async {
      grandPrixBasicInfoRepository.mockGetGrandPrixBasicInfoById(
        expectedGrandPrixBasicInfo: grandPrixBasicInfo,
      );

      final Stream<GrandPrixV2?> grandPrix$ = useCase(seasonGrandPrix);

      expect(await grandPrix$.first, expectedGrandPrix);
    },
  );
}
