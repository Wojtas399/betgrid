import 'package:betgrid/ui/common_cubit/season_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock/ui/mock_date_service.dart';

void main() {
  final dateService = MockDateService();

  blocTest(
    'should set current year as init state',
    build: () => SeasonCubit(dateService),
    setUp: () => dateService.mockGetNow(
      now: DateTime(2024),
    ),
    verify: (cubit) {
      expect(cubit.state, 2024);
    },
  );
}
