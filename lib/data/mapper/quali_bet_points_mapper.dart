import '../../firebase/model/grand_prix_bet_points_dto/grand_prix_bet_points_dto.dart';
import '../../model/grand_prix_bet_points.dart';

QualiBetPoints mapQualiBetPointsFromDto(QualiBetPointsDto qualiBetPointsDto) =>
    QualiBetPoints(
      totalPoints: qualiBetPointsDto.totalPoints,
      q1P1Points: qualiBetPointsDto.q1P1Points,
      q1P2Points: qualiBetPointsDto.q1P2Points,
      q1P3Points: qualiBetPointsDto.q1P3Points,
      q1P4Points: qualiBetPointsDto.q1P4Points,
      q1P5Points: qualiBetPointsDto.q1P5Points,
      q1P6Points: qualiBetPointsDto.q1P6Points,
      q1P7Points: qualiBetPointsDto.q1P7Points,
      q1P8Points: qualiBetPointsDto.q1P8Points,
      q1P9Points: qualiBetPointsDto.q1P9Points,
      q1P10Points: qualiBetPointsDto.q1P10Points,
      q2P11Points: qualiBetPointsDto.q2P11Points,
      q2P12Points: qualiBetPointsDto.q2P12Points,
      q2P13Points: qualiBetPointsDto.q2P13Points,
      q2P14Points: qualiBetPointsDto.q2P14Points,
      q2P15Points: qualiBetPointsDto.q2P15Points,
      q3P16Points: qualiBetPointsDto.q3P16Points,
      q3P17Points: qualiBetPointsDto.q3P17Points,
      q3P18Points: qualiBetPointsDto.q3P18Points,
      q3P19Points: qualiBetPointsDto.q3P19Points,
      q3P20Points: qualiBetPointsDto.q3P20Points,
      q1Multiplier: qualiBetPointsDto.q1Multiplier,
      q2Multiplier: qualiBetPointsDto.q2Multiplier,
      q3Multiplier: qualiBetPointsDto.q3Multiplier,
    );
