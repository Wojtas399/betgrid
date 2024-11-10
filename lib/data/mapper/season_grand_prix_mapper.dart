import 'package:injectable/injectable.dart';

import '../../model/season_grand_prix.dart';
import '../firebase/model/season_grand_prix_dto.dart';

@injectable
class SeasonGrandPrixMapper {
  SeasonGrandPrix mapFromDto(SeasonGrandPrixDto seasonGrandPrixDto) {
    return SeasonGrandPrix(
      id: seasonGrandPrixDto.id,
      season: seasonGrandPrixDto.season,
      grandPrixId: seasonGrandPrixDto.grandPrixId,
      roundNumber: seasonGrandPrixDto.roundNumber,
      startDate: seasonGrandPrixDto.startDate,
      endDate: seasonGrandPrixDto.endDate,
    );
  }
}
