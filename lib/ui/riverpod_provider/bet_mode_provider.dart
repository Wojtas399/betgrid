import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'duration_to_test_day_1_provider.dart';

part 'bet_mode_provider.g.dart';

enum BetMode {
  edit,
  preview,
}

@riverpod
BetMode betMode(BetModeRef ref) {
  final durationToTestDay1 = ref.watch(durationToTestDay1Provider);
  return durationToTestDay1.inSeconds <= 0 ? BetMode.preview : BetMode.edit;
}
