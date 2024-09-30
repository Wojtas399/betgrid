import '../../firebase/model/grand_prix_dto/grand_prix_dto.dart';
import '../../model/grand_prix.dart';

GrandPrix mapGrandPrixFromDto(GrandPrixDto grandPrixDto) => GrandPrix(
      id: grandPrixDto.id,
      season: 2024, //TODO: Read season from GrandPrixDto
      roundNumber: grandPrixDto.roundNumber,
      name: grandPrixDto.name,
      countryAlpha2Code: grandPrixDto.countryAlpha2Code,
      startDate: grandPrixDto.startDate,
      endDate: grandPrixDto.endDate,
    );
