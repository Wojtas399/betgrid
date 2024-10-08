import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import 'component/bets_content.dart';
import 'cubit/bets_cubit.dart';

@RoutePage()
class BetsScreen extends StatelessWidget {
  const BetsScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => getIt.get<BetsCubit>()..initialize(),
        child: const BetsContent(),
      );
}
