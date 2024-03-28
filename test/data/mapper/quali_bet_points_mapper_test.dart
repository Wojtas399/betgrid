import 'package:betgrid/data/mapper/quali_bet_points_mapper.dart';
import 'package:betgrid/firebase/model/grand_prix_bet_points_dto/grand_prix_bet_points_dto.dart';
import 'package:betgrid/model/grand_prix_bet_points.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'mapQualiBetPointsFromDto, '
    'should map QualiBetPointsDto model to QualiBetPoints model',
    () {
      const double totalPoints = 22;
      const double q3P1Points = 1.0;
      const double q3P2Points = 1.0;
      const double q3P3Points = 1.0;
      const double q3P4Points = 0.0;
      const double q3P5Points = 1.0;
      const double q3P6Points = 0.0;
      const double q3P7Points = 0.0;
      const double q3P8Points = 1.0;
      const double q3P9Points = 0.0;
      const double q3P10Points = 1.0;
      const double q2P11Points = 2.0;
      const double q2P12Points = 2.0;
      const double q2P13Points = 2.0;
      const double q2P14Points = 2.0;
      const double q2P15Points = 2.0;
      const double q1P16Points = 0.0;
      const double q1P17Points = 0.0;
      const double q1P18Points = 0.0;
      const double q1P19Points = 0.0;
      const double q1P20Points = 2.0;
      const double q1Points = 6.0;
      const double q2Points = 10;
      const double q3Points = 0.0;
      const double q1Multiplier = 1.5;
      const double q2Multiplier = 1.5;
      const double? q3Multiplier = null;
      const double multiplier = 3.0;
      const QualiBetPointsDto qualiBetPointsDto = QualiBetPointsDto(
        totalPoints: totalPoints,
        q3P1Points: q3P1Points,
        q3P2Points: q3P2Points,
        q3P3Points: q3P3Points,
        q3P4Points: q3P4Points,
        q3P5Points: q3P5Points,
        q3P6Points: q3P6Points,
        q3P7Points: q3P7Points,
        q3P8Points: q3P8Points,
        q3P9Points: q3P9Points,
        q3P10Points: q3P10Points,
        q2P11Points: q2P11Points,
        q2P12Points: q2P12Points,
        q2P13Points: q2P13Points,
        q2P14Points: q2P14Points,
        q2P15Points: q2P15Points,
        q1P16Points: q1P16Points,
        q1P17Points: q1P17Points,
        q1P18Points: q1P18Points,
        q1P19Points: q1P19Points,
        q1P20Points: q1P20Points,
        q1Points: q1Points,
        q2Points: q2Points,
        q3Points: q3Points,
        q1Multiplier: q1Multiplier,
        q2Multiplier: q2Multiplier,
        q3Multiplier: q3Multiplier,
        multiplier: multiplier,
      );
      const QualiBetPoints expectedQualiBetPoints = QualiBetPoints(
        totalPoints: totalPoints,
        q3P1Points: q3P1Points,
        q3P2Points: q3P2Points,
        q3P3Points: q3P3Points,
        q3P4Points: q3P4Points,
        q3P5Points: q3P5Points,
        q3P6Points: q3P6Points,
        q3P7Points: q3P7Points,
        q3P8Points: q3P8Points,
        q3P9Points: q3P9Points,
        q3P10Points: q3P10Points,
        q2P11Points: q2P11Points,
        q2P12Points: q2P12Points,
        q2P13Points: q2P13Points,
        q2P14Points: q2P14Points,
        q2P15Points: q2P15Points,
        q1P16Points: q1P16Points,
        q1P17Points: q1P17Points,
        q1P18Points: q1P18Points,
        q1P19Points: q1P19Points,
        q1P20Points: q1P20Points,
        q1Points: q1Points,
        q2Points: q2Points,
        q3Points: q3Points,
        q1Multiplier: q1Multiplier,
        q2Multiplier: q2Multiplier,
        q3Multiplier: q3Multiplier,
        multiplier: multiplier,
      );

      final QualiBetPoints qualiBetPoints = mapQualiBetPointsFromDto(
        qualiBetPointsDto,
      );

      expect(qualiBetPoints, expectedQualiBetPoints);
    },
  );
}
