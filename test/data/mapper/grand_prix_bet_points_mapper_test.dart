import 'package:betgrid/data/firebase/model/grand_prix_bet_points_dto.dart';
import 'package:betgrid/data/firebase/model/quali_bet_points_dto.dart';
import 'package:betgrid/data/firebase/model/race_bet_points_dto.dart';
import 'package:betgrid/data/mapper/grand_prix_bet_points_mapper.dart';
import 'package:betgrid/model/grand_prix_bet_points.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../creator/quali_bet_points_creator.dart';
import '../../creator/race_bet_points_creator.dart';
import '../../mock/data/mapper/mock_quali_bet_points_mapper.dart';
import '../../mock/data/mapper/mock_race_bet_points_mapper.dart';

void main() {
  final qualiBetPointsMapper = MockQualiBetPointsMapper();
  final raceBetPointsMapper = MockRaceBetPointsMapper();
  final mapper = GrandPrixBetPointsMapper(
    qualiBetPointsMapper,
    raceBetPointsMapper,
  );

  tearDown(() {
    reset(qualiBetPointsMapper);
    reset(raceBetPointsMapper);
  });

  test(
    'mapFromDto, '
    'should map GrandPrixBetPointsDto model to GrandPrixBetPoints model',
    () {
      const String id = 'gpbp1';
      const String playerId = 'p1';
      const String grandPrixId = 'gp1';
      const double totalPoints = 10.0;
      final QualiBetPointsCreator qualiBetPointsCreator = QualiBetPointsCreator(
        totalPoints: 4.0,
        q3P1Points: 2.0,
        q2P12Points: 2.0,
      );
      final RaceBetPointsCreator raceBetPointsCreator = RaceBetPointsCreator(
        totalPoints: 6.0,
        p1Points: 1.0,
        p2Points: 1.0,
        p3Points: 1.0,
        p10Points: 2.0,
        fastestLapPoints: 1.0,
      );
      final QualiBetPointsDto qualiBetPointsDto =
          qualiBetPointsCreator.createDto();
      final QualiBetPoints qualiBetPoints =
          qualiBetPointsCreator.createEntity();
      final RaceBetPointsDto raceBetPointsDto =
          raceBetPointsCreator.createDto();
      final RaceBetPoints raceBetPoints = raceBetPointsCreator.createEntity();
      final GrandPrixBetPointsDto grandPrixBetPointsDto = GrandPrixBetPointsDto(
        id: id,
        playerId: playerId,
        grandPrixId: grandPrixId,
        totalPoints: totalPoints,
        qualiBetPointsDto: qualiBetPointsDto,
        raceBetPointsDto: raceBetPointsDto,
      );
      final GrandPrixBetPoints expectedGrandPrixBetPoints = GrandPrixBetPoints(
        id: id,
        playerId: playerId,
        grandPrixId: grandPrixId,
        totalPoints: totalPoints,
        qualiBetPoints: qualiBetPoints,
        raceBetPoints: raceBetPoints,
      );
      qualiBetPointsMapper.mockMapFromDto(
        expectedQualiBetPoints: qualiBetPoints,
      );
      raceBetPointsMapper.mockMapFromDto(
        expectedRaceBetPoints: raceBetPoints,
      );

      final GrandPrixBetPoints grandPrixBetPoints =
          mapper.mapFromDto(grandPrixBetPointsDto);

      expect(grandPrixBetPoints, expectedGrandPrixBetPoints);
    },
  );
}
