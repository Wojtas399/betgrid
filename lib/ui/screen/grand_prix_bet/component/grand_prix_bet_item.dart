import 'package:flutter/material.dart';

import '../../../component/gap/gap_horizontal.dart';
import '../../../component/gap/gap_vertical.dart';
import '../../../component/padding/padding_components.dart';
import '../../../component/text_component.dart';
import '../../../extensions/build_context_extensions.dart';

class GrandPrixBetItem extends StatelessWidget {
  final String label;
  final Color? labelColor;
  final Widget betChild;
  final Widget resultsChild;
  final double? points;

  const GrandPrixBetItem({
    super.key,
    required this.label,
    this.labelColor,
    required this.betChild,
    required this.resultsChild,
    this.points,
  });

  @override
  Widget build(BuildContext context) => Card(
        child: Padding16(
          child: Column(
            children: [
              _Header(
                label: label,
                labelColor: labelColor,
              ),
              const Divider(height: 24),
              _Body(
                betChild: betChild,
                resultsChild: resultsChild,
                points: points,
              ),
            ],
          ),
        ),
      );
}

class _Header extends StatelessWidget {
  final String label;
  final Color? labelColor;

  const _Header({
    required this.label,
    required this.labelColor,
  });

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          LabelLarge(
            label,
            fontWeight: FontWeight.bold,
            color: labelColor,
          ),
          Icon(
            Icons.access_time,
            size: 20,
            color: context.colorScheme.outline,
          ),
        ],
      );
}

class _Body extends StatelessWidget {
  final Widget betChild;
  final Widget resultsChild;
  final double? points;

  const _Body({
    required this.betChild,
    required this.resultsChild,
    required this.points,
  });

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabelMedium(
                  context.str.grandPrixBetChoice,
                  fontWeight: FontWeight.w300,
                ),
                const GapVertical4(),
                betChild,
                const GapVertical8(),
                LabelMedium(
                  context.str.grandPrixBetResult,
                  fontWeight: FontWeight.w300,
                ),
                const GapVertical4(),
                resultsChild,
              ],
            ),
          ),
          const GapHorizontal16(),
          _Points(
            points: points,
          ),
        ],
      );
}

class _Points extends StatelessWidget {
  final double? points;

  const _Points({
    required this.points,
  });

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LabelLarge(
            context.str.points,
            fontWeight: FontWeight.w300,
          ),
          const GapVertical4(),
          TitleMedium(points?.toString() ?? '--'),
        ],
      );
}
