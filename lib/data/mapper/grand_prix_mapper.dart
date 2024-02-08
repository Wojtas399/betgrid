import '../../firebase/model/grand_prix_dto/grand_prix_dto.dart';
import '../../model/grand_prix.dart';

GrandPrix mapGrandPrixFromDto(GrandPrixDto grandPrixDto) => GrandPrix(
      id: grandPrixDto.id,
      name: grandPrixDto.name,
      startDate: grandPrixDto.startDate,
      endDate: grandPrixDto.endDate,
    );
