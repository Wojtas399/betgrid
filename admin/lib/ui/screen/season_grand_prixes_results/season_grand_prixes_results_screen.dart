import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import 'component/season_grand_prixes_results_content.dart';
import 'cubit/season_grand_prixes_results_cubit.dart';

@RoutePage()
class SeasonGrandPrixesResultsScreen extends StatelessWidget {
  const SeasonGrandPrixesResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SeasonGrandPrixesResultsCubit>()..initialize(),
      child: const SeasonGrandPrixesResultsContent(),
    );
  }
}
