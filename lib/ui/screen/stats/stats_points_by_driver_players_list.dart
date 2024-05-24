import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/player.dart';
import '../../component/avatar_component.dart';
import '../../component/padding/padding_components.dart';
import '../../component/text_component.dart';
import '../../extensions/build_context_extensions.dart';
import 'cubit/stats_cubit.dart';

class StatsPointsByDriverPlayersList extends ConsumerWidget {
  const StatsPointsByDriverPlayersList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isLoading = context.select(
      (StatsCubit cubit) => cubit.state.arePointsForDriverLoading,
    );
    final pointsByDriverData = context.select(
      (StatsCubit cubit) => cubit.state.pointsByDriver,
    );

    if (isLoading) return const _LoadingContent();
    if (pointsByDriverData?.isEmpty == true) {
      return const _NoSelectedDriverInfo();
    }
    final playersPoints = [...?pointsByDriverData];
    playersPoints.sort(
      (p1, p2) => p1.points != p2.points
          ? p2.points.compareTo(p1.points)
          : p2.player.username.compareTo(p1.player.username),
    );
    return Column(
      children: playersPoints
          .map(
            (playerPoints) => _PlayerInfo(
              player: playerPoints.player,
              points: playerPoints.points,
            ),
          )
          .toList(),
    );
  }
}

class _NoSelectedDriverInfo extends StatelessWidget {
  const _NoSelectedDriverInfo();

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 100,
        child: Padding24(
          child: Center(
            child: LabelLarge(context.str.statsNoSelectedDriver),
          ),
        ),
      );
}

class _LoadingContent extends StatelessWidget {
  const _LoadingContent();

  @override
  Widget build(BuildContext context) => const SizedBox(
        height: 100,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
}

class _PlayerInfo extends StatelessWidget {
  final Player player;
  final double points;

  const _PlayerInfo({required this.player, required this.points});

  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: const EdgeInsets.fromLTRB(4, 4, 8, 4),
        title: Text(player.username),
        trailing: BodyMedium(
          points.toString(),
          fontWeight: FontWeight.bold,
        ),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 32,
              height: 32,
              child: Avatar(
                avatarUrl: player.avatarUrl,
                username: player.username,
                usernameFontSize: 16,
              ),
            ),
          ],
        ),
      );
}
