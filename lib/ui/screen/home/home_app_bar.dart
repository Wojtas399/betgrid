import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../component/gap/gap_horizontal.dart';
import '../../config/router/app_router.dart';
import '../../extensions/build_context_extensions.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0.0,
      title: Text(context.str.homeScreenTitle),
      actions: const [
        _Avatar(),
        GapHorizontal16(),
      ],
    );
  }
}

class _Avatar extends ConsumerWidget {
  const _Avatar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () {
        context.navigateTo(const ProfileRoute());
      },
      icon: const CircleAvatar(
        child: Text('WP'),
      ),
    );
  }
}
