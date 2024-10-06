import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import '../../../use_case/get_grand_prixes_with_points_use_case.dart';
import '../../component/gap/gap_vertical.dart';
import '../../component/padding/padding_components.dart';
import '../../component/sliver_grand_prixes_list_component.dart';
import '../../component/sliver_player_total_points_component.dart';
import '../../component/text_component.dart';
import '../../config/router/app_router.dart';
import '../../extensions/build_context_extensions.dart';
import 'cubit/bets_cubit.dart';
import 'cubit/bets_state.dart';

@RoutePage()
class BetsScreen extends StatelessWidget {
  const BetsScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => getIt.get<BetsCubit>()..initialize(),
        child: const _Content(),
      );
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    final bool isCubitLoading = context.select(
      (BetsCubit cubit) => cubit.state.status.isLoading,
    );
    final double? totalPoints = context.select(
      (BetsCubit cubit) => cubit.state.totalPoints,
    );
    final List<GrandPrixWithPoints>? grandPrixesWithPoints = context.select(
      (BetsCubit cubit) => cubit.state.grandPrixesWithPoints,
    );

    return isCubitLoading
        ? Center(
            child: const CircularProgressIndicator(),
          )
        : totalPoints == null || grandPrixesWithPoints == null
            ? const _EmptyContentInfo()
            : const CustomScrollView(
                slivers: [
                  _TotalPoints(),
                  _GrandPrixes(),
                ],
              );
  }
}

class _EmptyContentInfo extends StatelessWidget {
  const _EmptyContentInfo();

  @override
  Widget build(BuildContext context) => Padding24(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TitleLarge(
                context.str.betsNoBetsTitle,
                fontWeight: FontWeight.bold,
              ),
              GapVertical16(),
              BodyMedium(
                context.str.betsNoBetsMessage,
                textAlign: TextAlign.center,
                color: context.colorScheme.outline,
              ),
            ],
          ),
        ),
      );
}

class _TotalPoints extends StatelessWidget {
  const _TotalPoints();

  @override
  Widget build(BuildContext context) {
    final double? totalPoints = context.select(
      (BetsCubit cubit) => cubit.state.totalPoints,
    );

    return SliverPlayerTotalPoints(
      points: totalPoints!,
    );
  }
}

class _GrandPrixes extends StatelessWidget {
  const _GrandPrixes();

  void _onGrandPrixPressed(String grandPrixId, BuildContext context) {
    final String? loggedUserId = context.read<BetsCubit>().state.loggedUserId;
    if (loggedUserId != null) {
      context.navigateTo(
        GrandPrixBetRoute(
          grandPrixId: grandPrixId,
          playerId: loggedUserId,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<GrandPrixWithPoints>? grandPrixesWithPoints = context.select(
      (BetsCubit cubit) => cubit.state.grandPrixesWithPoints,
    );

    return SliverGrandPrixesList(
      grandPrixesWithPoints: grandPrixesWithPoints!,
      onGrandPrixPressed: (String grandPrixId) =>
          _onGrandPrixPressed(grandPrixId, context),
    );
  }
}
