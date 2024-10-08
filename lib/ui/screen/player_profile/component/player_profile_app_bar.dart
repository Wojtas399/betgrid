import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../model/player.dart';
import '../../../component/avatar_component.dart';
import '../../../component/text_component.dart';
import '../cubit/player_profile_cubit.dart';

class PlayerProfileAppBar extends SliverAppBar {
  const PlayerProfileAppBar({
    super.key,
    super.backgroundColor,
    super.foregroundColor,
    super.flexibleSpace,
  }) : super(
          pinned: true,
          expandedHeight: 300,
          surfaceTintColor: Colors.transparent,
        );

  factory PlayerProfileAppBar.build({
    required Color backgroundColor,
    required Color foregroundColor,
  }) =>
      PlayerProfileAppBar(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        flexibleSpace: Builder(
          builder: (BuildContext context) {
            final Player? player = context.select(
              (PlayerProfileCubit cubit) => cubit.state.player,
            );

            return player != null
                ? FlexibleSpaceBar(
                    title: TitleLarge(
                      player.username,
                      color: Theme.of(context).canvasColor,
                    ),
                    centerTitle: true,
                    titlePadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 0,
                    ),
                    background: LayoutBuilder(
                      builder: (_, BoxConstraints constraints) {
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
                                usernameFontSize: 56,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : const CircularProgressIndicator();
          },
        ),
      );
}
