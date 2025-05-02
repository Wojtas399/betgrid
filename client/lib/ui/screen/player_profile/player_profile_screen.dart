import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import '../../common_cubit/season_cubit.dart';
import 'component/player_profile_content.dart';
import 'cubit/player_profile_cubit.dart';

@RoutePage()
class PlayerProfileScreen extends StatelessWidget {
  final String playerId;

  const PlayerProfileScreen({super.key, required this.playerId});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create:
        (_) => getIt.get<PlayerProfileCubit>(
          param1: getIt.get<SeasonCubit>(),
          param2: playerId,
        )..initialize(),
    child: const PlayerProfileContent(),
  );
}
