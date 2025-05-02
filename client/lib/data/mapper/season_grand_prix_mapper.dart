import 'package:betgrid_shared/firebase/model/season_grand_prix_dto.dart';
import 'package:injectable/injectable.dart';

import '../../model/season_grand_prix.dart';

@injectable
class SeasonGrandPrixMapper {
  SeasonGrandPrix mapFromDto(SeasonGrandPrixDto dto) {
    return SeasonGrandPrix(
      id: dto.id,
      season: dto.season,
      grandPrixId: dto.grandPrixId,
      roundNumber: dto.roundNumber,
      startDate: dto.startDate,
      endDate: dto.endDate,
    );
  }
}
