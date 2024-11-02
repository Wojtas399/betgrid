import 'package:flutter/material.dart';

import '../../../component/gap/gap_horizontal.dart';
import '../../../component/gap/gap_vertical.dart';
import '../../../component/padding/padding_components.dart';
import '../../../component/text_component.dart';
import '../../../extensions/build_context_extensions.dart';
import '../cubit/grand_prix_bet_state.dart';

class GrandPrixBetItem extends StatelessWidget {
  final String label;
  final Color? labelColor;
  final BetStatus? betStatus;
  final Widget betChild;
  final Widget resultsChild;
  final double? points;

  const GrandPrixBetItem({
    super.key,
    required this.label,
    this.labelColor,
    required this.betStatus,
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
                betStatus: betStatus,
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
  final BetStatus? betStatus;

  const _Header({
    required this.label,
    required this.labelColor,
    required this.betStatus,
  });

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TitleMedium(
            label,
            fontWeight: FontWeight.bold,
            color: labelColor,
          ),
          if (betStatus != null)
            Icon(
              switch (betStatus!) {
                BetStatus.pending => Icons.access_time,
                BetStatus.win => Icons.check_circle,
                BetStatus.loss => Icons.close,
              },
              size: 20,
              color: switch (betStatus!) {
                BetStatus.pending => context.colorScheme.outline,
                BetStatus.win => context.customColors?.win,
                BetStatus.loss => context.customColors?.loss,
              },
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
                  color: context.colorScheme.outline,
                ),
                const GapVertical4(),
                betChild,
                const GapVertical8(),
                LabelMedium(
                  context.str.grandPrixBetResult,
                  color: context.colorScheme.outline,
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
            color: context.colorScheme.outline,
          ),
          TitleMedium(points?.toString() ?? '--'),
        ],
      );
}
