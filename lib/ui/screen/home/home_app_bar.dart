import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/user.dart';
import '../../component/gap/gap_horizontal.dart';
import '../../config/router/app_router.dart';
import '../../provider/logged_user_data_notifier_provider.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const HomeAppBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
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
    final String? username = ref.watch(
      loggedUserDataNotifierProvider.select(
        (AsyncValue<User?> loggedUserData) => loggedUserData.value?.username,
      ),
    );
    final String? avatarUrl = ref.watch(
      loggedUserDataNotifierProvider.select(
        (AsyncValue<User?> loggedUserData) => loggedUserData.value?.avatarUrl,
      ),
    );

    return IconButton(
      onPressed: () {
        context.navigateTo(const ProfileRoute());
      },
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
