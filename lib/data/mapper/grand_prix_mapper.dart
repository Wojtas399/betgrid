import 'package:injectable/injectable.dart';

import '../../model/grand_prix.dart';
import '../firebase/model/grand_prix_dto/grand_prix_dto.dart';

@injectable
class GrandPrixMapper {
  GrandPrix mapFromDto(GrandPrixDto grandPrixDto) => GrandPrix(
        id: grandPrixDto.id,
        season: grandPrixDto.season,
        roundNumber: grandPrixDto.roundNumber,
        name: grandPrixDto.name,
        countryAlpha2Code: grandPrixDto.countryAlpha2Code,
        startDate: grandPrixDto.startDate,
        endDate: grandPrixDto.endDate,
      );
}

GrandPrix mapGrandPrixFromDto(GrandPrixDto grandPrixDto) => GrandPrix(
      id: grandPrixDto.id,
      season: grandPrixDto.season,
      roundNumber: grandPrixDto.roundNumber,
      name: grandPrixDto.name,
      countryAlpha2Code: grandPrixDto.countryAlpha2Code,
      startDate: grandPrixDto.startDate,
      endDate: grandPrixDto.endDate,
    );
