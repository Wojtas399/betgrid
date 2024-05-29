import 'package:betgrid/model/grand_prix_bet_points.dart';
import 'package:betgrid/use_case/get_grand_prixes_bet_points_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockGetGrandPrixesBetPointsUseCase extends Mock
    implements GetGrandPrixesBetPointsUseCase {
  void mock({
    required List<GrandPrixBetPoints> grandPrixesBetPoints,
  }) {
    when(
      () => call(
        playersIds: any(named: 'playersIds'),
        grandPrixesIds: any(named: 'grandPrixesIds'),
      ),
    ).thenAnswer((_) => Stream.value(grandPrixesBetPoints));
  }
}
