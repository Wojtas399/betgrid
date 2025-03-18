import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../dependency_injection.dart';
import '../preview/component/season_grand_prix_bet_preview_app_bar.dart';
import '../preview/component/season_grand_prix_bet_preview_body.dart';
import '../preview/cubit/season_grand_prix_bet_preview_cubit.dart';
import '../cubit/season_grand_prix_bet_cubit.dart';
import '../cubit/season_grand_prix_bet_state.dart';

class SeasonGrandPrixBetPreviewContent extends StatelessWidget {
  const SeasonGrandPrixBetPreviewContent({super.key});

  @override
  Widget build(BuildContext context) {
    final SeasonGrandPrixBetState state =
        context.read<SeasonGrandPrixBetCubit>().state;

    int? season;
    String? seasonGrandPrixId;
    String? playerId;
    if (state is SeasonGrandPrixBetStatePreview) {
      season = state.season;
      seasonGrandPrixId = state.seasonGrandPrixId;
      playerId = state.playerId;
    }

    return season != null && seasonGrandPrixId != null && playerId != null
        ? BlocProvider(
          create:
              (_) => getIt<SeasonGrandPrixBetPreviewCubit>(
                param1: SeasonGrandPrixBetPreviewCubitParams(
                  season: season!,
                  seasonGrandPrixId: seasonGrandPrixId!,
                  playerId: playerId!,
                ),
              )..initialize(),
          child: const Scaffold(
            appBar: SeasonGrandPrixBetPreviewAppBar(),
            body: SafeArea(child: SeasonGrandPrixBetPreviewBody()),
          ),
        )
        : const Placeholder();
  }
}
