import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../dependency_injection.dart';
import '../config/season_config.dart';
import 'today_date_provider.dart';

part 'duration_to_test_day_1_provider.g.dart';

@riverpod
class DurationToTestDay1 extends _$DurationToTestDay1 {
  @override
  Duration build() {
    final todayDate = ref.read(todayDateProvider);
    final testDay1Date = getIt<SeasonConfig>().testDay1;
    final secondsToTestDay1 = testDay1Date.difference(todayDate).inSeconds;
    Duration duration = Duration(seconds: secondsToTestDay1);
    final timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.inSeconds <= 0) {
        timer.cancel();
      } else {
        state -= const Duration(seconds: 1);
      }
    });
    ref.onDispose(timer.cancel);
    return duration;
  }
}
