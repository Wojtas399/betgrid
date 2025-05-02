import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../model/season_grand_prix_details.dart';
import '../../../component/season_grand_prix_item_component.dart';
import '../../../config/router/app_router.dart';
import '../cubit/season_grand_prixes_results_cubit.dart';
import '../cubit/season_grand_prixes_results_state.dart';

class SeasonGrandPrixesResultsContent extends StatelessWidget {
  const SeasonGrandPrixesResultsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: _Body());
  }
}

class _Body extends StatelessWidget {
  const _Body();

  void _onItemPressed(
    BuildContext context,
    String seasonGrandPrixId,
    int season,
  ) {
    context.pushRoute(
      SeasonGrandPrixResultsEditorRoute(
        season: season,
        seasonGrandPrixId: seasonGrandPrixId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final SeasonGrandPrixesResultsState state =
        context.watch<SeasonGrandPrixesResultsCubit>().state;

    return switch (state) {
      SeasonGrandPrixesResultsStateInitial() => const LinearProgressIndicator(),
      SeasonGrandPrixesResultsStateLoaded(
        :final int season,
        :final List<SeasonGrandPrixDetails> seasonGrandPrixes,
      ) =>
        ListView.separated(
          itemCount: seasonGrandPrixes.length,
          itemBuilder: (context, index) {
            final SeasonGrandPrixDetails seasonGrandPrixDetails =
                seasonGrandPrixes[index];

            return GestureDetector(
              onTap:
                  () => _onItemPressed(
                    context,
                    seasonGrandPrixDetails.seasonGrandPrixId,
                    season,
                  ),
              child: SeasonGrandPrixItem(
                seasonGrandPrixDetails: seasonGrandPrixDetails,
              ),
            );
          },
          separatorBuilder: (context, index) => const Divider(height: 0.0),
        ),
    };
  }
}
