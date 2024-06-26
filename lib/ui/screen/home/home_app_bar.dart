import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../component/gap/gap_horizontal.dart';
import '../../config/router/app_router.dart';
import 'cubit/home_cubit.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const HomeAppBar({
    super.key,
    required this.title,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => AppBar(
        title: Text(title),
        actions: const [
          _Avatar(),
          GapHorizontal8(),
        ],
      );
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
        child: username == null && avatarUrl == null
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
