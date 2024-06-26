import '../../firebase/model/grand_prix_dto/grand_prix_dto.dart';
import '../../model/grand_prix.dart';

GrandPrix mapGrandPrixFromDto(GrandPrixDto grandPrixDto) => GrandPrix(
      id: grandPrixDto.id,
      roundNumber: grandPrixDto.roundNumber,
      name: grandPrixDto.name,
      countryAlpha2Code: grandPrixDto.countryAlpha2Code,
      startDate: grandPrixDto.startDate,
      endDate: grandPrixDto.endDate,
    );
