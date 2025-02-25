import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import 'component/season_grand_prix_bet_preview_content.dart';
import 'cubit/season_grand_prix_bet_preview_cubit.dart';

@RoutePage()
class SeasonGrandPrixBetPreviewScreen extends StatelessWidget {
  final String playerId;
  final int season;
  final String seasonGrandPrixId;

  const SeasonGrandPrixBetPreviewScreen({
    super.key,
    required this.playerId,
    required this.season,
    required this.seasonGrandPrixId,
  });

  @override
  Widget build(BuildContext context) => BlocProvider(
    create:
        (_) => getIt.get<SeasonGrandPrixBetPreviewCubit>(
          param1: SeasonGrandPrixBetPreviewCubitParams(
            playerId: playerId,
            season: season,
            seasonGrandPrixId: seasonGrandPrixId,
          ),
        )..initialize(),
    child: const GrandPrixBetContent(),
  );
}
