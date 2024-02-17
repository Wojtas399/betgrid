import 'package:betgrid/ui/config/season_config.dart';
import 'package:betgrid/ui/riverpod_provider/bet_mode_provider.dart';
import 'package:betgrid/ui/riverpod_provider/today_date_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../../mock/listener.dart';

class MockSeasonConfig extends Mock implements SeasonConfig {
  void mockTestDay1(DateTime dateTime) {
    when(() => testDay1).thenReturn(dateTime);
  }
}

void main() {
  final seasonConfig = MockSeasonConfig();

  ProviderContainer makeProviderContainer(DateTime todayDate) {
    final container = ProviderContainer(
      overrides: [
        todayDateProvider.overrideWithValue(todayDate),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUpAll(() {
    GetIt.I.registerFactory<SeasonConfig>(() => seasonConfig);
    seasonConfig.mockTestDay1(DateTime(2024, 2, 15));
  });

  test(
    'today date is before the date of test day 1, '
    'should return BetMode.edit',
    () {
      final container = makeProviderContainer(DateTime(2024, 2, 14));
      final listener = Listener<BetMode>();
      container.listen(
        betModeProvider,
        listener,
        fireImmediately: true,
      );

      verifyInOrder([
        () => listener(null, BetMode.edit),
      ]);
      verifyNoMoreInteractions(listener);
    },
  );

  test(
    'today date is after the date of test day 1, '
    'should return BetMode.preview',
    () {
      final container = makeProviderContainer(
        DateTime(2024, 2, 15, 0, 0, 0, 0, 1),
      );
      final listener = Listener<BetMode>();
      container.listen(
        betModeProvider,
        listener,
        fireImmediately: true,
      );

      verifyInOrder([
        () => listener(null, BetMode.preview),
      ]);
      verifyNoMoreInteractions(listener);
    },
  );
}
