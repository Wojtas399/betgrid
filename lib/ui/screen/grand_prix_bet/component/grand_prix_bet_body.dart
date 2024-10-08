import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/gap/gap_vertical.dart';
import '../../../component/text_component.dart';
import '../../../extensions/build_context_extensions.dart';
import '../cubit/grand_prix_bet_cubit.dart';
import '../cubit/grand_prix_bet_state.dart';
import 'grand_prix_bet_qualifications.dart';
import 'grand_prix_bet_race.dart';

class GrandPrixBetBody extends StatelessWidget {
  const GrandPrixBetBody({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isCubitLoading = context.select(
      (GrandPrixBetCubit cubit) => cubit.state.status.isLoading,
    );

    return isCubitLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const GapVertical16(),
                const _TotalPoints(),
                const GapVertical16(),
                _Label(label: context.str.qualifications),
                const GrandPrixBetQualifications(),
                _Label(label: context.str.race),
                const GrandPrixBetRace(),
                const GapVertical32(),
              ],
            ),
          );
  }
}

class _TotalPoints extends StatelessWidget {
  const _TotalPoints();

  @override
  Widget build(BuildContext context) {
    final double? totalPoints = context.select(
      (GrandPrixBetCubit cubit) => cubit.state.grandPrixBetPoints?.totalPoints,
    );

    return Center(
      child: Column(
        children: [
          HeadlineMedium(
            context.str.points,
            fontWeight: FontWeight.bold,
          ),
          const GapVertical8(),
          DisplayLarge(
            '${totalPoints ?? '--'}',
            fontWeight: FontWeight.bold,
            color: context.colorScheme.primary,
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String label;

  const _Label({required this.label});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: context.colorScheme.outline.withOpacity(0.5),
            ),
          ),
        ),
        padding: const EdgeInsets.only(bottom: 16, left: 24, top: 16),
        child: HeadlineMedium(
          label,
          fontWeight: FontWeight.bold,
        ),
      );
}
