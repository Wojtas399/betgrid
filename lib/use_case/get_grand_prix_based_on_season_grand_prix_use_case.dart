import 'package:injectable/injectable.dart';

import '../data/repository/grand_prix_basic_info/grand_prix_basic_info_repository.dart';
import '../model/grand_prix.dart';
import '../model/grand_prix_basic_info.dart';
import '../model/season_grand_prix.dart';

@injectable
class GetGrandPrixBasedOnSeasonGrandPrixUseCase {
  final GrandPrixBasicInfoRepository _grandPrixBasicInfoRepository;

  const GetGrandPrixBasedOnSeasonGrandPrixUseCase(
    this._grandPrixBasicInfoRepository,
  );

  Stream<GrandPrix?> call(SeasonGrandPrix seasonGrandPrix) {
    return _grandPrixBasicInfoRepository
        .getGrandPrixBasicInfoById(seasonGrandPrix.grandPrixId)
        .map(
          (GrandPrixBasicInfo? grandPrixBasicInfo) => grandPrixBasicInfo != null
              ? GrandPrix(
                  seasonGrandPrixId: seasonGrandPrix.id,
                  name: grandPrixBasicInfo.name,
                  countryAlpha2Code: grandPrixBasicInfo.countryAlpha2Code,
                  roundNumber: seasonGrandPrix.roundNumber,
                  startDate: seasonGrandPrix.startDate,
                  endDate: seasonGrandPrix.endDate,
                )
              : null,
        );
  }
}
