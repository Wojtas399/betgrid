import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import '../../common_cubit/season_cubit.dart';
import 'component/players_body.dart';
import 'cubit/players_cubit.dart';

@RoutePage()
class PlayersScreen extends StatelessWidget {
  const PlayersScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => getIt.get<PlayersCubit>(
          param1: getIt.get<SeasonCubit>(),
        )..initialize(),
        child: const PlayersBody(),
      );
}
