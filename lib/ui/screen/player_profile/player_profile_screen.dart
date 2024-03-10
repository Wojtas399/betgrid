import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/grand_prix.dart';
import '../../../model/player.dart';
import '../../component/avatar_component.dart';
import '../../component/grand_prix_item_component.dart';
import '../../component/scroll_animated_item_component.dart';
import '../../component/text/title.dart';
import '../../config/router/app_router.dart';
import '../../provider/grand_prix/all_grand_prixes_provider.dart';

@RoutePage()
class PlayerProfileScreen extends StatelessWidget {
  final Player player;

  const PlayerProfileScreen({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _AppBar.build(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).canvasColor,
            player: player,
            context: context,
          ),
          Consumer(
            builder: (_, ref, __) => ref.watch(allGrandPrixesProvider).when(
                  data: (List<GrandPrix>? grandPrixes) =>
                      _GrandPrixesList.build(
                    context: context,
                    grandPrixes: grandPrixes!,
                    playerId: player.id,
                  ),
                  error: (_, __) => SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        const Text('Cannot load grand prixes'),
                      ],
                    ),
                  ),
                  loading: () => _LoadingIndicator.build(),
                ),
          ),
        ],
      ),
    );
  }
}

class _AppBar extends SliverAppBar {
  const _AppBar({
    super.backgroundColor,
    super.foregroundColor,
    super.flexibleSpace,
  }) : super(
          pinned: true,
          expandedHeight: 300,
          surfaceTintColor: Colors.transparent,
        );

  factory _AppBar.build({
    required Player player,
    required BuildContext context,
    Color? backgroundColor,
    Color? foregroundColor,
  }) =>
      _AppBar(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        flexibleSpace: FlexibleSpaceBar(
          title: TitleLarge(
            player.username,
            color: Theme.of(context).canvasColor,
          ),
          centerTitle: true,
          titlePadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 0,
          ),
          background: LayoutBuilder(builder: (_, BoxConstraints constraints) {
            final double avatarSize = constraints.maxHeight * 0.55;

            return Center(
              child: SizedBox(
                width: avatarSize,
                height: avatarSize,
                child: Hero(
                  tag: player.id,
                  child: Avatar(
                    avatarUrl: player.avatarUrl,
                    username: player.username,
                  ),
                ),
              ),
            );
          }),
        ),
      );
}

class _GrandPrixesList extends SliverPadding {
  const _GrandPrixesList({required super.padding, super.sliver});

  factory _GrandPrixesList.build({
    required BuildContext context,
    required List<GrandPrix> grandPrixes,
    required String playerId,
  }) =>
      _GrandPrixesList(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 64),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            childCount: grandPrixes.length,
            (_, int index) {
              final grandPrix = grandPrixes[index];

              return ScrollAnimatedItem(
                child: GrandPrixItem(
                  betPoints: 0,
                  roundNumber: index + 1,
                  grandPrix: grandPrix,
                  onPressed: () {
                    context.navigateTo(
                      GrandPrixBetRoute(
                        grandPrixId: grandPrix.id,
                        playerId: playerId,
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      );
}

class _LoadingIndicator extends SliverPadding {
  const _LoadingIndicator({required super.padding, super.sliver});

  factory _LoadingIndicator.build() => _LoadingIndicator(
        padding: const EdgeInsets.only(top: 32),
        sliver: SliverList(
          delegate: SliverChildListDelegate(
            [
              const Center(
                child: CircularProgressIndicator(),
              )
            ],
          ),
        ),
      );
}
