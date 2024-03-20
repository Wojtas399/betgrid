import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../extensions/build_context_extensions.dart';
import '../provider/player_points_provider.dart';
import 'gap/gap_vertical.dart';
import 'text/display.dart';
import 'text/headline.dart';

class SliverPlayerTotalPoints extends SliverPadding {
  SliverPlayerTotalPoints({super.key, required String playerId})
      : super(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          sliver: SliverToBoxAdapter(
            child: Builder(
              builder: (BuildContext context) {
                return Column(
                  children: [
                    HeadlineMedium(
                      context.str.points,
                      fontWeight: FontWeight.bold,
                    ),
                    const GapVertical8(),
                    Consumer(
                      builder: (_, ref, __) {
                        final double? totalPoints = ref
                            .watch(
                              playerPointsProvider(playerId: playerId),
                            )
                            .value;

                        return DisplayLarge(
                          '${totalPoints ?? '--'}',
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        );
}
