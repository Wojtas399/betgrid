import 'package:flutter/material.dart';

import '../extensions/build_context_extensions.dart';
import 'gap/gap_vertical.dart';
import 'text_component.dart';

class SliverPlayerTotalPoints extends SliverPadding {
  SliverPlayerTotalPoints({
    super.key,
    double? points,
    bool isLoading = false,
  }) : super(
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
                    if (isLoading)
                      Container(
                        width: 24,
                        height: 24,
                        margin: const EdgeInsets.only(top: 20),
                        child: const CircularProgressIndicator(strokeWidth: 3),
                      ),
                    if (!isLoading)
                      DisplayLarge(
                        '$points',
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                  ],
                );
              },
            ),
          ),
        );
}
