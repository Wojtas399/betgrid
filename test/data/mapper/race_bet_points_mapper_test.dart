import 'package:betgrid/data/mapper/race_bet_points_mapper.dart';
import 'package:betgrid/firebase/model/grand_prix_bet_points_dto/grand_prix_bet_points_dto.dart';
import 'package:betgrid/model/grand_prix_bet_points.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'mapRaceBetPointsFromDto, '
    'should map RaceBetPointsDto model to RaceBetPoints model',
    () {
      const double totalPoints = 20.0;
      const double p1Points = 2.0;
      const double p2Points = 0.0;
      const double p3Points = 2.0;
      const double p10Points = 4.0;
      const double fastestLapPoints = 2.0;
      const double dnfPoints = 6;
      const double dnfMultiplier = 1.5;
      const double safetyCarPoints = 1.0;
      const double redFlagPoints = 0.0;
      const RaceBetPointsDto raceBetPointsDto = RaceBetPointsDto(
        totalPoints: totalPoints,
        p1Points: p1Points,
        p2Points: p2Points,
        p3Points: p3Points,
        p10Points: p10Points,
        fastestLapPoints: fastestLapPoints,
        podiumAndP10Multiplier: null,
        dnfPoints: dnfPoints,
        dnfMultiplier: dnfMultiplier,
        safetyCarPoints: safetyCarPoints,
        redFlagPoints: redFlagPoints,
      );
      const RaceBetPoints expectedRaceBetPoints = RaceBetPoints(
        totalPoints: totalPoints,
        p1Points: p1Points,
        p2Points: p2Points,
        p3Points: p3Points,
        p10Points: p10Points,
        fastestLapPoints: fastestLapPoints,
        podiumAndP10Multiplier: null,
        dnfPoints: dnfPoints,
        dnfMultiplier: dnfMultiplier,
        safetyCarPoints: safetyCarPoints,
        redFlagPoints: redFlagPoints,
      );

      final RaceBetPoints raceBetPoints = mapRaceBetPointsFromDto(
        raceBetPointsDto,
      );

      expect(raceBetPoints, expectedRaceBetPoints);
    },
  );
}
