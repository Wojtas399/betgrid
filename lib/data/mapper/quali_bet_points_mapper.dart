import 'package:betgrid_shared/firebase/model/quali_bet_points_dto.dart';
import 'package:injectable/injectable.dart';

import '../../model/grand_prix_bet_points.dart';

@injectable
class QualiBetPointsMapper {
  QualiBetPoints mapFromDto(QualiBetPointsDto qualiBetPointsDto) =>
      QualiBetPoints(
        totalPoints: qualiBetPointsDto.total,
        q3P1Points: qualiBetPointsDto.q3P1,
        q3P2Points: qualiBetPointsDto.q3P2,
        q3P3Points: qualiBetPointsDto.q3P3,
        q3P4Points: qualiBetPointsDto.q3P4,
        q3P5Points: qualiBetPointsDto.q3P5,
        q3P6Points: qualiBetPointsDto.q3P6,
        q3P7Points: qualiBetPointsDto.q3P7,
        q3P8Points: qualiBetPointsDto.q3P8,
        q3P9Points: qualiBetPointsDto.q3P9,
        q3P10Points: qualiBetPointsDto.q3P10,
        q2P11Points: qualiBetPointsDto.q2P11,
        q2P12Points: qualiBetPointsDto.q2P12,
        q2P13Points: qualiBetPointsDto.q2P13,
        q2P14Points: qualiBetPointsDto.q2P14,
        q2P15Points: qualiBetPointsDto.q2P15,
        q1P16Points: qualiBetPointsDto.q1P16,
        q1P17Points: qualiBetPointsDto.q1P17,
        q1P18Points: qualiBetPointsDto.q1P18,
        q1P19Points: qualiBetPointsDto.q1P19,
        q1P20Points: qualiBetPointsDto.q1P20,
        q1Points: qualiBetPointsDto.totalQ1,
        q2Points: qualiBetPointsDto.totalQ2,
        q3Points: qualiBetPointsDto.totalQ3,
        q1Multiplier: qualiBetPointsDto.q1Multiplier,
        q2Multiplier: qualiBetPointsDto.q2Multiplier,
        q3Multiplier: qualiBetPointsDto.q3Multiplier,
        multiplier: qualiBetPointsDto.multiplier,
      );
}
