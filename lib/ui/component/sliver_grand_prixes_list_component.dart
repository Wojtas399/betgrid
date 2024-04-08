import 'package:flutter/material.dart';

import '../provider/grand_prixes_with_points_provider.dart';
import 'grand_prix_item_component.dart';
import 'scroll_animated_item_component.dart';

class SliverGrandPrixesList extends SliverPadding {
  SliverGrandPrixesList({
    super.key,
    required String playerId,
    required List<GrandPrixWithPoints> grandPrixesWithPoints,
    required Function(String) onGrandPrixPressed,
    bool isLoading = false,
  }) : super(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 64),
          sliver: isLoading
              ? const SliverFillRemaining(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                    ],
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: grandPrixesWithPoints.length,
                    (context, index) {
                      final item = grandPrixesWithPoints[index];

                      return ScrollAnimatedItem(
                        child: GrandPrixItem(
                          betPoints: item.points,
                          roundNumber: index + 1,
                          grandPrix: item.grandPrix,
                          onPressed: () {
                            onGrandPrixPressed(item.grandPrix.id);
                          },
                        ),
                      );
                    },
                  ),
                ),
        );
}
