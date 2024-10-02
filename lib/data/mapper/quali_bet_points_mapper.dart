import 'package:injectable/injectable.dart';

import '../../model/grand_prix_bet_points.dart';
import '../firebase/model/grand_prix_bet_points_dto/grand_prix_bet_points_dto.dart';

@injectable
class QualiBetPointsMapper {
  QualiBetPoints mapFromDto(QualiBetPointsDto qualiBetPointsDto) =>
      QualiBetPoints(
        totalPoints: qualiBetPointsDto.totalPoints,
        q3P1Points: qualiBetPointsDto.q3P1Points,
        q3P2Points: qualiBetPointsDto.q3P2Points,
        q3P3Points: qualiBetPointsDto.q3P3Points,
        q3P4Points: qualiBetPointsDto.q3P4Points,
        q3P5Points: qualiBetPointsDto.q3P5Points,
        q3P6Points: qualiBetPointsDto.q3P6Points,
        q3P7Points: qualiBetPointsDto.q3P7Points,
        q3P8Points: qualiBetPointsDto.q3P8Points,
        q3P9Points: qualiBetPointsDto.q3P9Points,
        q3P10Points: qualiBetPointsDto.q3P10Points,
        q2P11Points: qualiBetPointsDto.q2P11Points,
        q2P12Points: qualiBetPointsDto.q2P12Points,
        q2P13Points: qualiBetPointsDto.q2P13Points,
        q2P14Points: qualiBetPointsDto.q2P14Points,
        q2P15Points: qualiBetPointsDto.q2P15Points,
        q1P16Points: qualiBetPointsDto.q1P16Points,
        q1P17Points: qualiBetPointsDto.q1P17Points,
        q1P18Points: qualiBetPointsDto.q1P18Points,
        q1P19Points: qualiBetPointsDto.q1P19Points,
        q1P20Points: qualiBetPointsDto.q1P20Points,
        q1Points: qualiBetPointsDto.q1Points,
        q2Points: qualiBetPointsDto.q2Points,
        q3Points: qualiBetPointsDto.q3Points,
        q1Multiplier: qualiBetPointsDto.q1Multiplier,
        q2Multiplier: qualiBetPointsDto.q2Multiplier,
        q3Multiplier: qualiBetPointsDto.q3Multiplier,
        multiplier: qualiBetPointsDto.multiplier,
      );
}

QualiBetPoints mapQualiBetPointsFromDto(QualiBetPointsDto qualiBetPointsDto) =>
    QualiBetPoints(
      totalPoints: qualiBetPointsDto.totalPoints,
      q3P1Points: qualiBetPointsDto.q3P1Points,
      q3P2Points: qualiBetPointsDto.q3P2Points,
      q3P3Points: qualiBetPointsDto.q3P3Points,
      q3P4Points: qualiBetPointsDto.q3P4Points,
      q3P5Points: qualiBetPointsDto.q3P5Points,
      q3P6Points: qualiBetPointsDto.q3P6Points,
      q3P7Points: qualiBetPointsDto.q3P7Points,
      q3P8Points: qualiBetPointsDto.q3P8Points,
      q3P9Points: qualiBetPointsDto.q3P9Points,
      q3P10Points: qualiBetPointsDto.q3P10Points,
      q2P11Points: qualiBetPointsDto.q2P11Points,
      q2P12Points: qualiBetPointsDto.q2P12Points,
      q2P13Points: qualiBetPointsDto.q2P13Points,
      q2P14Points: qualiBetPointsDto.q2P14Points,
      q2P15Points: qualiBetPointsDto.q2P15Points,
      q1P16Points: qualiBetPointsDto.q1P16Points,
      q1P17Points: qualiBetPointsDto.q1P17Points,
      q1P18Points: qualiBetPointsDto.q1P18Points,
      q1P19Points: qualiBetPointsDto.q1P19Points,
      q1P20Points: qualiBetPointsDto.q1P20Points,
      q1Points: qualiBetPointsDto.q1Points,
      q2Points: qualiBetPointsDto.q2Points,
      q3Points: qualiBetPointsDto.q3Points,
      q1Multiplier: qualiBetPointsDto.q1Multiplier,
      q2Multiplier: qualiBetPointsDto.q2Multiplier,
      q3Multiplier: qualiBetPointsDto.q3Multiplier,
      multiplier: qualiBetPointsDto.multiplier,
    );
