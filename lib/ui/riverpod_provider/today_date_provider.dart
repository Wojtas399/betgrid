import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'today_date_provider.g.dart';

@riverpod
DateTime todayDate(TodayDateRef ref) => DateTime.now();
