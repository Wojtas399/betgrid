import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import '../../common_cubit/season_cubit.dart';
import 'component/season_grand_prix_bets_body.dart';
import 'cubit/season_grand_prix_bets_cubit.dart';

class SeasonGrandPrixBetsScreen extends StatelessWidget {
  const SeasonGrandPrixBetsScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create:
        (_) => getIt.get<SeasonGrandPrixBetsCubit>(
          param1: getIt.get<SeasonCubit>(),
        )..initialize(),
    child: const SeasonGrandPrixBetsBody(),
  );
}
