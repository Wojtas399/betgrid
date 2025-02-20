import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../extensions/build_context_extensions.dart';
import '../../../component/gap/gap_vertical.dart';
import '../../../component/text_component.dart';
import '../cubit/player_profile_cubit.dart';
import '../cubit/player_profile_state.dart';

class PlayerProfileTotalPoints extends StatelessWidget {
  const PlayerProfileTotalPoints({super.key});

  @override
  Widget build(BuildContext context) {
    final isCubitLoading = context.select(
      (PlayerProfileCubit cubit) => cubit.state.status.isLoading,
    );
    final double? totalPoints = context.select(
      (PlayerProfileCubit cubit) => cubit.state.totalPoints,
    );

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      sliver: SliverToBoxAdapter(
        child: Builder(
          builder:
              (BuildContext context) => Column(
                children: [
                  HeadlineMedium(
                    context.str.points,
                    fontWeight: FontWeight.bold,
                  ),
                  const GapVertical8(),
                  if (isCubitLoading)
                    Container(
                      width: 24,
                      height: 24,
                      margin: const EdgeInsets.only(top: 20),
                      child: const CircularProgressIndicator(strokeWidth: 3),
                    ),
                  if (!isCubitLoading)
                    DisplayLarge(
                      '$totalPoints',
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.primary,
                    ),
                ],
              ),
        ),
      ),
    );
  }
}
