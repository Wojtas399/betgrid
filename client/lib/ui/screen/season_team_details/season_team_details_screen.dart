import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import 'component/season_team_details_content.dart';
import 'cubit/season_team_details_cubit.dart';

@RoutePage()
class SeasonTeamDetailsScreen extends StatelessWidget {
  final int season;
  final String seasonTeamId;

  const SeasonTeamDetailsScreen({
    super.key,
    required this.season,
    required this.seasonTeamId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              getIt<SeasonTeamDetailsCubit>()
                ..initialize(season: season, seasonTeamId: seasonTeamId),
      child: const SeasonTeamDetailsContent(),
    );
  }
}
