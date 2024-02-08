import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../component/gap/gap_horizontal.dart';
import '../../../config/theme/theme_notifier.dart';

class SignInAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SignInAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(Str.of(context).signInScreenTitle),
      actions: const [
        Icon(Icons.contrast),
        GapHorizontal8(),
        _ThemeSwitch(),
        GapHorizontal8(),
      ],
    );
  }
}

class _ThemeSwitch extends ConsumerWidget {
  const _ThemeSwitch();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeMode themeMode = ref.watch(themeNotifierProvider);

    return Switch(
      value: themeMode == ThemeMode.dark,
      onChanged: (bool isSwitched) {
        ref.read(themeNotifierProvider.notifier).changeThemeMode(
              isSwitched ? ThemeMode.dark : ThemeMode.light,
            );
      },
    );
  }
}
