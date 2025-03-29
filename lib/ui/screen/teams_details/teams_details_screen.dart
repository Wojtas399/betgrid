import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import '../../common_cubit/season_cubit.dart';
import 'component/teams_details_content.dart';
import 'cubit/teams_details_cubit.dart';

class TeamsDetailsScreen extends StatelessWidget {
  const TeamsDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              getIt<TeamsDetailsCubit>(param1: context.read<SeasonCubit>())
                ..initialize(),
      child: const TeamsDetailsContent(),
    );
  }
}
