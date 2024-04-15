import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../model/user.dart' as user;
import '../../component/gap/gap_horizontal.dart';
import '../../controller/theme_mode_controller.dart';
import '../../extensions/build_context_extensions.dart';

class SignInAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SignInAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(Str.of(context).signInScreenTitle),
      actions: [
        Icon(
          MdiIcons.themeLightDark,
          color: context.colorScheme.outline,
        ),
        const GapHorizontal8(),
        const _ThemeSwitch(),
        const GapHorizontal8(),
      ],
    );
  }
}

class _ThemeSwitch extends ConsumerWidget {
  const _ThemeSwitch();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<user.ThemeMode> themeMode = ref.watch(
      themeModeControllerProvider,
    );

    return Switch(
      value: themeMode.value == user.ThemeMode.dark,
      onChanged: (bool isSwitched) {
        ref.read(themeModeControllerProvider.notifier).changeThemeMode(
              isSwitched ? user.ThemeMode.dark : user.ThemeMode.light,
            );
      },
    );
  }
}
