import 'package:betgrid/ui/common_cubit/season_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockSeasonCubit extends Mock implements SeasonCubit {
  void mockState({
    required int expectedState,
  }) {
    when(() => state).thenReturn(expectedState);
  }
}
