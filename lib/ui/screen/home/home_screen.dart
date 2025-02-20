import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import '../../common_cubit/season_cubit.dart';
import 'component/home_content.dart';
import 'cubit/home_cubit.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create:
        (BuildContext context) =>
            getIt.get<HomeCubit>(param1: context.read<SeasonCubit>())
              ..initialize(),
    child: const HomeContent(),
  );
}
