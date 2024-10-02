import 'package:betgrid/data/mapper/grand_prix_bet_mapper.dart';
import 'package:betgrid/model/grand_prix_bet.dart';
import 'package:mocktail/mocktail.dart';

class MockGrandPrixBetMapper extends Mock implements GrandPrixBetMapper {
  void mockMapFromDto({
    required GrandPrixBet expectedGrandPrixBet,
  }) {
    when(
      () => mapFromDto(any()),
    ).thenReturn(expectedGrandPrixBet);
  }
}
