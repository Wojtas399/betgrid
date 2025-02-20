import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/gap/gap_horizontal.dart';
import '../../../component/text_component.dart';
import '../../../config/router/app_router.dart';
import '../../../extensions/build_context_extensions.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      title: const _Logo(),
      actions: const [
        _Points(),
        GapHorizontal16(),
        _Avatar(),
        GapHorizontal8(),
      ],
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        TitleLarge('Bet', fontWeight: FontWeight.bold),
        TitleLarge('Grid', color: Colors.red, fontWeight: FontWeight.bold),
      ],
    );
  }
}

class _Points extends StatelessWidget {
  const _Points();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 6,
      children: [
        Icon(Icons.star_outline_rounded, color: context.colorScheme.primary),
        BlocSelector<HomeCubit, HomeState, double?>(
          selector: (state) => state.totalPoints,
          builder:
              (context, totalPoints) => TitleLarge(
                (totalPoints ?? 0).toStringAsFixed(1),
                color: context.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar();

  void _onAvatarPressed(BuildContext context) {
    context.navigateTo(const ProfileRoute());
  }

  @override
  Widget build(BuildContext context) {
    final String? username = context.select(
      (HomeCubit cubit) => cubit.state.username,
    );
    final String? avatarUrl = context.select(
      (HomeCubit cubit) => cubit.state.avatarUrl,
    );

    return IconButton(
      onPressed: () => _onAvatarPressed(context),
      icon: CircleAvatar(
        backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
        child:
            username == null && avatarUrl == null
                ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2.0),
                )
                : avatarUrl == null
                ? Text('${username?[0].toUpperCase()}')
                : null,
      ),
    );
  }
}
