import 'package:flutter/material.dart';

import '../../component/gap/gap_vertical.dart';
import '../../component/text/body.dart';
import '../../component/text/title.dart';
import '../../extensions/build_context_extensions.dart';

class GrandPrixBetPointsSummary extends StatelessWidget {
  final List<GrandPrixPointsSummaryDetail> details;
  final double totalPoints;

  const GrandPrixBetPointsSummary({
    super.key,
    required this.details,
    required this.totalPoints,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleLarge(context.str.grandPrixBetPointsDetails),
          const GapVertical8(),
          ...details.map(
            (detail) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BodyMedium('${detail.label}:'),
                BodyMedium(detail.value ?? '--'),
              ],
            ),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TitleMedium('${context.str.grandPrixBetTotal}: '),
              TitleMedium(
                '$totalPoints',
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class GrandPrixPointsSummaryDetail {
  final String label;
  final String? value;

  const GrandPrixPointsSummaryDetail({required this.label, this.value});
}