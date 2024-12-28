import 'package:flutter/material.dart';

import '../../use_case/get_grand_prixes_with_points_use_case.dart';
import 'grand_prix_item_component.dart';
import 'scroll_animated_item_component.dart';

class SliverGrandPrixesList extends SliverPadding {
  SliverGrandPrixesList({
    super.key,
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
                          name: item.name,
                          countryAlpha2Code: item.countryAlpha2Code,
                          roundNumber: item.roundNumber,
                          startDate: item.startDate,
                          endDate: item.endDate,
                          onPressed: () => onGrandPrixPressed(
                            item.seasonGrandPrixId,
                          ),
                        ),
                      );
                    },
                  ),
                ),
        );
}
