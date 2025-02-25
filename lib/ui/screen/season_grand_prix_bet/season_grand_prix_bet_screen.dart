import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import 'component/season_grand_prix_bet_content.dart';
import 'cubit/season_grand_prix_bet_cubit.dart';

@RoutePage()
class SeasonGrandPrixBetScreen extends StatelessWidget {
  final int season;
  final String seasonGrandPrixId;
  final String? playerId;

  const SeasonGrandPrixBetScreen({
    super.key,
    required this.season,
    required this.seasonGrandPrixId,
    this.playerId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => getIt<SeasonGrandPrixBetCubit>(
            param1: SeasonGrandPrixBetCubitParams(
              season: season,
              seasonGrandPrixId: seasonGrandPrixId,
              playerId: playerId,
            ),
          )..initialize(),
      child: const SeasonGrandPrixBetContent(),
    );
  }
}
