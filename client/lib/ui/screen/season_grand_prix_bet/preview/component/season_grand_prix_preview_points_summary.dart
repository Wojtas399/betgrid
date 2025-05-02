import 'package:flutter/material.dart';

import '../../../../component/text_component.dart';
import '../../../../extensions/build_context_extensions.dart';

class SeasonGrandPrixBetPreviewPointsSummary extends StatelessWidget {
  final List<SeasonGrandPrixBetPreviewPointsSummaryDetail> details;
  final double? totalPoints;

  const SeasonGrandPrixBetPreviewPointsSummary({
    super.key,
    required this.details,
    this.totalPoints,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleMedium(
          context.str.seasonGrandPrixBetPreviewPointsDetails,
          fontWeight: FontWeight.bold,
        ),
        ...details.map(
          (detail) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BodyMedium(detail.label),
              BodyMedium(detail.value?.toString() ?? context.str.doubleDash),
            ],
          ),
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TitleMedium(context.str.seasonGrandPrixBetPreviewTotal),
            TitleMedium(
              totalPoints?.toString() ?? context.str.doubleDash,
              color: context.colorScheme.primary,
            ),
          ],
        ),
      ],
    ),
  );
}

class SeasonGrandPrixBetPreviewPointsSummaryDetail {
  final String label;
  final double? value;

  const SeasonGrandPrixBetPreviewPointsSummaryDetail({
    required this.label,
    this.value,
  });
}
