import 'package:betgrid_shared/firebase/model/quali_bet_points_dto.dart';
import 'package:injectable/injectable.dart';

import '../../model/season_grand_prix_bet_points.dart';

@injectable
class QualiBetPointsMapper {
  QualiBetPoints mapFromDto(QualiBetPointsDto qualiBetPointsDto) =>
      QualiBetPoints(
        total: qualiBetPointsDto.total,
        q3P1: qualiBetPointsDto.q3P1,
        q3P2: qualiBetPointsDto.q3P2,
        q3P3: qualiBetPointsDto.q3P3,
        q3P4: qualiBetPointsDto.q3P4,
        q3P5: qualiBetPointsDto.q3P5,
        q3P6: qualiBetPointsDto.q3P6,
        q3P7: qualiBetPointsDto.q3P7,
        q3P8: qualiBetPointsDto.q3P8,
        q3P9: qualiBetPointsDto.q3P9,
        q3P10: qualiBetPointsDto.q3P10,
        q2P11: qualiBetPointsDto.q2P11,
        q2P12: qualiBetPointsDto.q2P12,
        q2P13: qualiBetPointsDto.q2P13,
        q2P14: qualiBetPointsDto.q2P14,
        q2P15: qualiBetPointsDto.q2P15,
        q1P16: qualiBetPointsDto.q1P16,
        q1P17: qualiBetPointsDto.q1P17,
        q1P18: qualiBetPointsDto.q1P18,
        q1P19: qualiBetPointsDto.q1P19,
        q1P20: qualiBetPointsDto.q1P20,
        totalQ1: qualiBetPointsDto.totalQ1,
        totalQ2: qualiBetPointsDto.totalQ2,
        totalQ3: qualiBetPointsDto.totalQ3,
        q1Multiplier: qualiBetPointsDto.q1Multiplier,
        q2Multiplier: qualiBetPointsDto.q2Multiplier,
        q3Multiplier: qualiBetPointsDto.q3Multiplier,
        multiplier: qualiBetPointsDto.multiplier,
      );
}
