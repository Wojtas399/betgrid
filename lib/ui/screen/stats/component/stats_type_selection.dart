import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/custom_card_component.dart';
import '../../../extensions/build_context_extensions.dart';
import '../cubit/stats_cubit.dart';
import '../cubit/stats_state.dart';

class StatsTypeSelection extends StatefulWidget {
  const StatsTypeSelection({super.key});

  @override
  State<StatsTypeSelection> createState() => _StatsTypeSelectionState();
}

class _StatsTypeSelectionState extends State<StatsTypeSelection> {
  late StatsType _statsType;

  @override
  void initState() {
    super.initState();
    final Stats stats = context.read<StatsCubit>().state.stats!;
    _statsType = switch (stats) {
      GroupedStats() => StatsType.grouped,
      IndividualStats() => StatsType.individual,
    };
  }

  void _onGroupedPressed(BuildContext context) {
    const StatsType statsType = StatsType.grouped;
    setState(() {
      _statsType = statsType;
    });
    context.read<StatsCubit>().onStatsTypeChanged(statsType);
  }

  void _onIndividualPressed(BuildContext context) {
    const StatsType statsType = StatsType.individual;
    setState(() {
      _statsType = statsType;
    });
    context.read<StatsCubit>().onStatsTypeChanged(statsType);
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.all(8),
      child: Row(
        spacing: 16,
        children: [
          Expanded(
            child: _Btn(
              label: context.str.statsGrouped,
              isSelected: _statsType == StatsType.grouped,
              onPressed: () => _onGroupedPressed(context),
            ),
          ),
          Expanded(
            child: _Btn(
              label: context.str.statsIndividual,
              isSelected: _statsType == StatsType.individual,
              onPressed: () => _onIndividualPressed(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _Btn extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const _Btn({
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => isSelected
      ? FilledButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: onPressed,
          child: Text(label),
        )
      : TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: onPressed,
          child: Text(label),
        );
}
