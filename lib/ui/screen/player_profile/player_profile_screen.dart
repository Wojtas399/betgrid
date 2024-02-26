import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../model/player.dart';
import '../../component/avatar_component.dart';
import '../../component/text/title.dart';

@RoutePage()
class PlayerProfileScreen extends StatelessWidget {
  final Player player;

  const PlayerProfileScreen({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.primary,
            surfaceTintColor: Colors.transparent,
            foregroundColor: Theme.of(context).canvasColor,
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
              background: Center(
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Hero(
                    tag: player.id,
                    child: Avatar(
                      avatarUrl: player.avatarUrl,
                      username: player.username,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              List.generate(
                50,
                (index) => ListTile(
                  title: Text('$index'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
