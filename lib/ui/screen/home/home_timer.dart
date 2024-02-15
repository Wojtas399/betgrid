import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../component/gap/gap_vertical.dart';
import '../../component/text/title.dart';
import '../../extensions/build_context_extensions.dart';
import '../../riverpod_provider/duration_to_test_day_1_provider.dart';

class HomeTimer extends ConsumerWidget {
  const HomeTimer({super.key});

  final int hoursInDay = 24;
  final int minutesInHour = 60;
  final int secondsInMinute = 60;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final duration = ref.watch(durationToTestDay1Provider);
    final days = duration.inDays;
    final daysInHours = hoursInDay * days;
    final daysInMinutes = daysInHours * minutesInHour;
    final daysInSeconds = daysInMinutes * secondsInMinute;

    final hours = duration.inHours - daysInHours;
    final hoursInMinutes = minutesInHour * hours;
    final hoursInSeconds = hoursInMinutes * secondsInMinute;

    final minutes = duration.inMinutes - (daysInMinutes + hoursInMinutes);
    final minutesInSeconds = secondsInMinute * minutes;

    final seconds = duration.inSeconds -
        (daysInSeconds + hoursInSeconds + minutesInSeconds);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              TitleMedium('${context.str.homeTimerLabel}:'),
              const GapVertical8(),
              TitleLarge(
                '$days d. $hours g. $minutes m. $seconds s.',
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ),
        Divider(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.25),
          height: 0,
        ),
      ],
    );
  }
}
