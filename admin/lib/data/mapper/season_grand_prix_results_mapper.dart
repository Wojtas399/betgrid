import 'package:betgrid_shared/firebase/model/season_grand_prix_results_dto.dart';
import 'package:injectable/injectable.dart';

import '../../model/season_grand_prix_results.dart';

@injectable
class SeasonGrandPrixResultsMapper {
  SeasonGrandPrixResults mapFromDto(SeasonGrandPrixResultsDto dto) {
    return SeasonGrandPrixResults(
      id: dto.id,
      season: dto.season,
      seasonGrandPrixId: dto.seasonGrandPrixId,
      qualiStandingsBySeasonDriverIds: dto.qualiStandingsBySeasonDriverIds,
      p1SeasonDriverId: dto.p1SeasonDriverId,
      p2SeasonDriverId: dto.p2SeasonDriverId,
      p3SeasonDriverId: dto.p3SeasonDriverId,
      p10SeasonDriverId: dto.p10SeasonDriverId,
      fastestLapSeasonDriverId: dto.fastestLapSeasonDriverId,
      dnfSeasonDriverIds: dto.dnfSeasonDriverIds,
      wasThereSafetyCar: dto.wasThereSafetyCar,
      wasThereRedFlag: dto.wasThereRedFlag,
    );
  }
}
