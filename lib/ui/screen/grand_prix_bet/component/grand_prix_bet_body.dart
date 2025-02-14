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
        ? const Center(child: CircularProgressIndicator())
        : const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: [
                _TotalPoints(),
                GapVertical24(),
                GrandPrixBetQualifications(),
                GrandPrixBetRace(),
              ],
            ),
          ),
        );
  }
}

class _TotalPoints extends StatelessWidget {
  const _TotalPoints();

  @override
  Widget build(BuildContext context) {
    final double? totalPoints = context.select(
      (GrandPrixBetCubit cubit) =>
          cubit.state.seasonGrandPrixBetPoints?.totalPoints,
    );

    return Center(
      child: Column(
        children: [
          HeadlineMedium(context.str.points, fontWeight: FontWeight.bold),
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
