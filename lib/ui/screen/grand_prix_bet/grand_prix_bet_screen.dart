import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import 'component/grand_prix_bet_content.dart';
import 'cubit/grand_prix_bet_cubit.dart';

@RoutePage()
class GrandPrixBetScreen extends StatelessWidget {
  final String playerId;
  final int season;
  final String seasonGrandPrixId;

  const GrandPrixBetScreen({
    super.key,
    required this.playerId,
    required this.season,
    required this.seasonGrandPrixId,
  });

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => getIt.get<GrandPrixBetCubit>(
          param1: GrandPrixBetCubitParams(
            playerId: playerId,
            season: season,
            seasonGrandPrixId: seasonGrandPrixId,
          ),
        )..initialize(),
        child: const GrandPrixBetContent(),
      );
}
