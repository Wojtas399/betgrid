import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/gap/gap_vertical.dart';
import '../../../component/padding/padding_components.dart';
import '../../../component/text_component.dart';
import '../../../extensions/build_context_extensions.dart';
import '../cubit/stats_cubit.dart';
import '../cubit/stats_state.dart';

class StatsBestPoints extends StatelessWidget {
  const StatsBestPoints({super.key});

  @override
  Widget build(BuildContext context) {
    final StatsType statsType = context.select(
      (StatsCubit cubit) => cubit.state.type,
    );

    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: _Points(
                  label: 'Grand Prix',
                  points: 22.4,
                  value: 'Monaco GP',
                  playerName: statsType == StatsType.grouped ? 'Wojtas' : null,
                ),
              ),
              const VerticalDivider(),
              Expanded(
                child: _Points(
                  label: 'Kwalifikacje',
                  points: 12.4,
                  value: 'Azerbaijan GP',
                  playerName: statsType == StatsType.grouped ? 'Nexos' : null,
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
                  points: 8,
                  value: 'Las Vegas GP',
                  playerName: statsType == StatsType.grouped ? 'Nexos' : null,
                ),
              ),
              const VerticalDivider(),
              Expanded(
                child: _Points(
                  label: 'Kierowca',
                  points: 33.5,
                  value: 'Max Verstappen',
                  playerName:
                      statsType == StatsType.grouped ? 'xnaciiak' : null,
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
  final double points;
  final String value;
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
              BodyMedium(
                playerName!,
                color: context.colorScheme.primary,
              ),
              const GapVertical8(),
            ],
            TitleLarge(
              points.toString(),
              color: context.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
            const GapVertical8(),
            BodyMedium(
              value,
              color: context.colorScheme.primary,
            ),
          ],
        ),
      );
}
