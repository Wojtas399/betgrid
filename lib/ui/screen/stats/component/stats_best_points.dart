import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/gap/gap_vertical.dart';
import '../../../component/padding/padding_components.dart';
import '../../../component/text_component.dart';
import '../../../extensions/build_context_extensions.dart';
import '../cubit/stats_cubit.dart';
import '../stats_model/best_points.dart';

class StatsBestPoints extends StatelessWidget {
  const StatsBestPoints({super.key});

  @override
  Widget build(BuildContext context) {
    final bool areGroupedStats = context.select(
      (StatsCubit cubit) => cubit.state.areGroupedStats,
    );
    final BestPoints? bestPoints = context.select(
      (StatsCubit cubit) => cubit.state.stats?.bestPoints,
    );

    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: _Points(
                  label: 'Grand Prix',
                  points: bestPoints?.bestGpPoints?.points,
                  value: bestPoints?.bestGpPoints?.grandPrixName,
                  playerName:
                      areGroupedStats
                          ? bestPoints?.bestGpPoints?.playerName
                          : null,
                ),
              ),
              const VerticalDivider(),
              Expanded(
                child: _Points(
                  label: 'Kwalifikacje',
                  points: bestPoints?.bestQualiPoints?.points,
                  value: bestPoints?.bestQualiPoints?.grandPrixName,
                  playerName:
                      areGroupedStats
                          ? bestPoints?.bestQualiPoints?.playerName
                          : null,
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: _Points(
                  label: 'Wyścig',
                  points: bestPoints?.bestRacePoints?.points,
                  value: bestPoints?.bestRacePoints?.grandPrixName,
                  playerName:
                      areGroupedStats
                          ? bestPoints?.bestRacePoints?.playerName
                          : null,
                ),
              ),
              const VerticalDivider(),
              Expanded(
                child: _Points(
                  label: 'Kierowca',
                  points: bestPoints?.bestDriverPoints?.points,
                  value:
                      '${bestPoints?.bestDriverPoints?.driverName} ${bestPoints?.bestDriverPoints?.driverSurname}',
                  playerName:
                      areGroupedStats
                          ? bestPoints?.bestDriverPoints?.playerName
                          : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Points extends StatelessWidget {
  final String label;
  final double? points;
  final String? value;
  final String? playerName;

  const _Points({
    required this.label,
    required this.points,
    required this.value,
    this.playerName,
  });

  @override
  Widget build(BuildContext context) => Padding8(
    child: Column(
      children: [
        BodyMedium(label),
        const GapVertical8(),
        if (playerName != null) ...[
          BodyMedium(playerName!, color: context.colorScheme.primary),
          const GapVertical8(),
        ],
        if (points != null) ...[
          TitleLarge(
            points.toString(),
            color: context.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
          const GapVertical8(),
          BodyMedium(
            value ?? context.str.statsBestPointsUnknown,
            color: context.colorScheme.primary,
          ),
        ] else
          BodyMedium('--', color: context.colorScheme.outline),
      ],
    ),
  );
}
