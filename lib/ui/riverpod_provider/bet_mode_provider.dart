import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../dependency_injection.dart';
import '../config/season_config.dart';
import 'today_date_provider.dart';

part 'bet_mode_provider.g.dart';

enum BetMode {
  edit,
  preview,
}

@riverpod
BetMode betMode(BetModeRef ref) {
  final today = ref.watch(todayDateProvider);
  return today.isAfter(getIt<SeasonConfig>().testDay1)
      ? BetMode.preview
      : BetMode.edit;
}
