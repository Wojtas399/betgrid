import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import 'component/grand_prix_bet_content.dart';
import 'cubit/grand_prix_bet_cubit.dart';

//TODO: Improve the UI of this screen

@RoutePage()
class GrandPrixBetScreen extends StatelessWidget {
  final String grandPrixId;
  final String playerId;

  const GrandPrixBetScreen({
    super.key,
    required this.grandPrixId,
    required this.playerId,
  });

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => getIt.get<GrandPrixBetCubit>()
          ..initialize(
            playerId: playerId,
            grandPrixId: grandPrixId,
          ),
        child: const GrandPrixBetContent(),
      );
}
